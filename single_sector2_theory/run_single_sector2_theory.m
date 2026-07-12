function result=run_single_sector2_theory(varargin)
%RUN_SINGLE_SECTOR2_THEORY End-to-end non-FEM, non-TCMT calculation.

ip=inputParser;ip.addParameter('Resolution','quick');
ip.addParameter('OutputDir',fullfile(fileparts(mfilename('fullpath')),'output'));
ip.parse(varargin{:});opt=ip.Results;
switch lower(string(opt.Resolution))
    case "quick"
        cfg=single_sector2_parameters('CavityAngularMax',3,'CavityAxialMax',1, ...
            'DuctAzimuthalMax',3,'DuctRadialCount',3, ...
            'ThetaQuadratureOrder',24,'ZQuadratureOrder',20);
        searchArgs={'RealRangeHz',[1200 1900],'ImagRangeHz',[0.1 250], ...
            'GridSize',[25 13],'MaxCandidates',24,'ResidualTolerance',1e-4, ...
            'FminMaxIterations',100,'FminMaxEvaluations',300,'UseFsolve',false};
    case "standard"
        cfg=single_sector2_parameters('CavityAngularMax',6,'CavityAxialMax',2, ...
            'DuctAzimuthalMax',7,'DuctRadialCount',5, ...
            'ThetaQuadratureOrder',48,'ZQuadratureOrder',40);
        searchArgs={'RealRangeHz',[1200 1900],'ImagRangeHz',[0.1 250], ...
            'GridSize',[45 25],'MaxCandidates',60,'ResidualTolerance',1e-6, ...
            'FminMaxIterations',250,'FminMaxEvaluations',800,'UseFsolve',true};
    otherwise
        error('Resolution must be quick or standard.');
end
C=parse_comsol_sector_txt;
R=find_single_sector_resonances(cfg,searchArgs{:},'Verbose',true);
M=single_sector_radiation_channels(R);
comparison=compare_single_sector_to_comsol(C,M,opt.OutputDir);
if ~exist(opt.OutputDir,'dir'),mkdir(opt.OutputDir);end
save(fullfile(opt.OutputDir,'single_sector2_theory_state.mat'),'cfg','R','M','comparison','-v7.3');
result=struct('cfg',cfg,'roots',R,'channels',M,'comparison',comparison);
end
