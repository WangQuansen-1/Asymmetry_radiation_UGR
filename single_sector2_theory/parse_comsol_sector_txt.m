function result = parse_comsol_sector_txt(txtFile)
%PARSE_COMSOL_SECTOR_TXT Parse the COMSOL reference table for sector cavity 2.
%
%   RESULT = PARSE_COMSOL_SECTOR_TXT() reads "../特征频率.txt", relative to
%   this function.  RESULT = PARSE_COMSOL_SECTOR_TXT(TXTFILE) reads the
%   specified UTF-8 text file.
%
%   The expected COMSOL export has exactly five comment/header lines and
%   sixty data rows.  Every data row contains seven whitespace-separated
%   complex numbers:
%
%       frequency(kHz), Eoz1, Eoz0, Eoz_1, Eof1, Eof0, Eof_1
%
%   Frequencies are converted from kHz to Hz.  The six original complex
%   powers and their real parts are both retained.  Radiation fractions are
%   calculated from the REAL parts of the powers, as requested:
%
%       Forward  = real(Eoz1) / sum(real([Eoz1 Eoz0 Eoz_1]))
%       Backward = real(Eof1) / sum(real([Eof1 Eof0 Eof_1]))
%
%   This function only imports the independent COMSOL reference data.  It
%   performs no fitting and does not pass COMSOL eigenfrequencies into the
%   theoretical calculation.

    if nargin < 1 || isempty(txtFile)
        functionDir = fileparts(mfilename('fullpath'));
        txtFile = fullfile(functionDir, '..', '特征频率.txt');
    end

    if isstring(txtFile)
        if ~isscalar(txtFile)
            error('sector2:InvalidPath', ...
                'txtFile must be a character vector or a scalar string.');
        end
        txtFile = char(txtFile);
    end
    if ~(ischar(txtFile) && isrow(txtFile) && ~isempty(txtFile))
        error('sector2:InvalidPath', ...
            'txtFile must be a nonempty character vector or scalar string.');
    end
    if exist(txtFile, 'file') ~= 2
        error('sector2:FileNotFound', ...
            'COMSOL reference file was not found: %s', txtFile);
    end

    % Explicit UTF-8 decoding is required because the COMSOL header contains
    % Chinese characters.  No expression evaluator is used on file content.
    [fileID, message] = fopen(txtFile, 'rt', 'n', 'UTF-8');
    if fileID < 0
        error('sector2:FileOpenFailed', ...
            'Could not open COMSOL reference file "%s": %s', txtFile, message);
    end
    closeFile = onCleanup(@() fclose(fileID));
    raw = textscan(fileID, '%s', 'Delimiter', '\n', 'Whitespace', '');
    lines = raw{1};
    lines = regexprep(lines, '\r$', '');

    % Empty lines are harmless, but all nonempty content must still have the
    % prescribed five-header/sixty-row structure.
    isNonempty = ~cellfun(@(line) isempty(strtrim(line)), lines);
    lines = lines(isNonempty);
    expectedHeaderRows = 5;
    expectedDataRows = 60;
    if numel(lines) ~= expectedHeaderRows + expectedDataRows
        error('sector2:UnexpectedRowCount', ...
            ['Expected 5 nonempty header lines and 60 data rows (65 total), ' ...
             'but found %d nonempty lines in "%s".'], numel(lines), txtFile);
    end

    isHeader = cellfun(@(line) startsWith(strtrim(line), '%'), lines);
    if ~all(isHeader(1:expectedHeaderRows)) || any(isHeader(expectedHeaderRows+1:end))
        error('sector2:InvalidHeaderLayout', ...
            'The first five nonempty lines must be %% headers and no data row may start with %%.');
    end

    columnHeader = lines{expectedHeaderRows};
    requiredLabels = {'kHz', 'Eoz1', 'Eoz0', 'Eoz_1', ...
                      'Eof1', 'Eof0', 'Eof_1'};
    for labelIndex = 1:numel(requiredLabels)
        if ~contains(columnHeader, requiredLabels{labelIndex})
            error('sector2:MissingColumnLabel', ...
                'The fifth header line does not contain required label "%s".', ...
                requiredLabels{labelIndex});
        end
    end

    dataLines = lines(expectedHeaderRows+1:end);
    values = complex(zeros(expectedDataRows, 7));
    for rowIndex = 1:expectedDataRows
        columns = regexp(strtrim(dataLines{rowIndex}), '\s+', 'split');
        if numel(columns) ~= 7
            error('sector2:UnexpectedColumnCount', ...
                'Data row %d must contain 7 columns, but contains %d.', ...
                rowIndex, numel(columns));
        end
        for columnIndex = 1:7
            values(rowIndex, columnIndex) = parseFiniteComplex( ...
                columns{columnIndex}, rowIndex, columnIndex);
        end
    end

    frequency = 1000 .* values(:, 1); % COMSOL export: kHz -> Hz
    if any(real(frequency) <= 0)
        error('sector2:InvalidFrequency', ...
            'All frequency real parts must be positive.');
    end

    complexPower = values(:, 2:7);
    realPower = real(complexPower);
    downSum = sum(realPower(:, 1:3), 2);
    upSum = sum(realPower(:, 4:6), 2);
    if any(~isfinite(downSum) | downSum <= 0)
        error('sector2:InvalidDownstreamPower', ...
            'Each row must have a finite, positive real-power sum for Eoz channels.');
    end
    if any(~isfinite(upSum) | upSum <= 0)
        error('sector2:InvalidUpstreamPower', ...
            'Each row must have a finite, positive real-power sum for Eof channels.');
    end

    downFraction = realPower(:, 1:3) ./ downSum;
    upFraction = realPower(:, 4:6) ./ upSum;

    % Build the result in an explicit and stable column order.  solution_index
    % is the original COMSOL row/solution order, not a frequency reordering.
    result = table((1:expectedDataRows).', real(frequency), imag(frequency), ...
        'VariableNames', {'solution_index', 'frequency_real_Hz', ...
                          'frequency_imag_Hz'});

    complexNames = {'Eoz1_W', 'Eoz0_W', 'Eoz_1_W', ...
                    'Eof1_W', 'Eof0_W', 'Eof_1_W'};
    realNames = {'Eoz1_real_W', 'Eoz0_real_W', 'Eoz_1_real_W', ...
                 'Eof1_real_W', 'Eof0_real_W', 'Eof_1_real_W'};
    ratioNames = {'Eoz1_ratio', 'Eoz0_ratio', 'Eoz_1_ratio', ...
                  'Eof1_ratio', 'Eof0_ratio', 'Eof_1_ratio'};
    allFractions = [downFraction, upFraction];
    for channelIndex = 1:6
        result.(complexNames{channelIndex}) = complexPower(:, channelIndex);
        result.(realNames{channelIndex}) = realPower(:, channelIndex);
        result.(ratioNames{channelIndex}) = allFractions(:, channelIndex);
    end
    result.Forward = downFraction(:, 1);
    result.Backward = upFraction(:, 1);
end


function value = parseFiniteComplex(token, rowIndex, columnIndex)
%PARSEFINITECOMPLEX Strictly parse a+bi/a-bi without eval or str2num.

    decimal = '(?:\d+(?:\.\d*)?|\.\d+)';
    exponent = '(?:[Ee][+-]?\d+)?';
    realPattern = ['[+-]?', decimal, exponent];
    imagPattern = ['[+-]', decimal, exponent];
    pattern = ['^(?<real>', realPattern, ')(?<imag>', imagPattern, ')[ij]$'];
    parts = regexp(token, pattern, 'names', 'once');
    if isempty(parts)
        error('sector2:InvalidComplexNumber', ...
            ['Invalid complex number at data row %d, column %d. ' ...
             'Expected finite a+bi or a-bi notation.'], rowIndex, columnIndex);
    end

    realPart = str2double(parts.real);
    imagPart = str2double(parts.imag);
    if ~(isfinite(realPart) && isfinite(imagPart))
        error('sector2:NonfiniteValue', ...
            'Nonfinite value at data row %d, column %d.', rowIndex, columnIndex);
    end
    value = complex(realPart, imagPart);
end
