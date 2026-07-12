function result=run_loss_after_no_loss_gate(varargin)
%RUN_LOSS_AFTER_NO_LOSS_GATE Hard guard before any thermoviscous solve.
% The caller supplies a loss callback only after all no-loss complex
% eigenfrequencies satisfy the configured real- and imaginary-part limits.

ip=inputParser;
ip.addParameter('GateArguments',{});
ip.addParameter('LossCallback',[]);
ip.parse(varargin{:});opt=ip.Results;
[gateTable,gateSummary,passed]=validate_no_loss_gate(opt.GateArguments{:});
if ~passed
    error(['Thermoviscous calculation blocked: only %d/%d no-loss complex ', ...
        'eigenfrequencies satisfy both tolerances.'], ...
        gateSummary.passed_mode_count,gateSummary.mode_count);
end
if isempty(opt.LossCallback)
    result=struct('gateTable',gateTable,'gateSummary',gateSummary, ...
        'lossResult',[]);
else
    if ~isa(opt.LossCallback,'function_handle')
        error('LossCallback must be a function handle.');
    end
    result=struct('gateTable',gateTable,'gateSummary',gateSummary, ...
        'lossResult',opt.LossCallback());
end
end
