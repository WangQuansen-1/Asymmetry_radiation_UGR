function result = run_single_cavity_first_principles(varargin)
%RUN_SINGLE_CAVITY_FIRST_PRINCIPLES Independent MATLAB wave calculation.
% Example:
%   result=run_single_cavity_first_principles;

ip=inputParser;
ip.addParameter('SolveEigenmodes',true,@islogical);
ip.addParameter('SolveRadiation',true,@islogical);
ip.addParameter('OutputDir','');
ip.parse(varargin{:});
cfg=single_cavity_parameters;
if ~isempty(ip.Results.OutputDir),cfg.outputDir=ip.Results.OutputDir;end
if ~isfolder(cfg.outputDir),mkdir(cfg.outputDir);end

sys=build_acoustic_fem(cfg);
result=struct('cfg',cfg,'mesh',rmfield(sys,{'K','Kbase','M','B'}));
if ip.Results.SolveEigenmodes
    result.eigen=solve_open_eigenmodes(sys);
    print_channels('Eigenmode',result.eigen.targetFrequency,result.eigen.targetChannels);
end
if ip.Results.SolveRadiation
    result.radiation=solve_point_source_radiation(sys,cfg.driveFrequency);
    print_channels('Point source',cfg.driveFrequency,result.radiation.channels);
end

save(fullfile(cfg.outputDir,'independent_result.mat'),'result','-v7.3');
write_outputs(result,cfg.outputDir);
end

function print_channels(label,f,ch)
fprintf('\n%s at %.9g%+.4gi Hz\n',label,real(f),imag(f));
fprintf(' lower [Eoz1 Eoz0 Eoz_1] = %.8f %.8f %.8f\n',ch.lowerFraction);
fprintf(' upper [Eof1 Eof0 Eof_1] = %.8f %.8f %.8f\n',ch.upperFraction);
end

function write_outputs(result,outDir)
rows={};
if isfield(result,'eigen')
    ch=result.eigen.targetChannels;
    rows(end+1,:)={'eigen',real(result.eigen.targetFrequency),imag(result.eigen.targetFrequency), ...
        ch.lowerFraction(1),ch.lowerFraction(2),ch.lowerFraction(3), ...
        ch.upperFraction(1),ch.upperFraction(2),ch.upperFraction(3)};
end
if isfield(result,'radiation')
    ch=result.radiation.channels;
    rows(end+1,:)={'radiation',result.radiation.frequency,0, ...
        ch.lowerFraction(1),ch.lowerFraction(2),ch.lowerFraction(3), ...
        ch.upperFraction(1),ch.upperFraction(2),ch.upperFraction(3)};
end
T=cell2table(rows,'VariableNames',{'case_name','frequency_real_Hz','frequency_imag_Hz', ...
    'Eoz1_fraction','Eoz0_fraction','Eoz_1_fraction', ...
    'Eof1_fraction','Eof0_fraction','Eof_1_fraction'});
writetable(T,fullfile(outDir,'six_channel_fractions.csv'));
end
