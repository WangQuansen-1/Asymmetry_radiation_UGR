function result=run_two_cavity_theory(varargin)
%RUN_TWO_CAVITY_THEORY Non-FEM/non-TCMT calculation and COMSOL comparison.
here=fileparts(mfilename('fullpath'));root=fileparts(here);
addpath(here,fullfile(root,'single_sector2_theory'));
ip=inputParser;ip.addParameter('Resolution','quick');
ip.addParameter('OutputDir',fullfile(here,'output_current'));
ip.addParameter('TxtFile',fullfile(root,'特征频率2.txt'));
ip.parse(varargin{:});opt=ip.Results;

switch lower(string(opt.Resolution))
    case "quick"
        cfg=two_cavity_parameters('cavityAngularMax',3,'cavityAxialMax',1, ...
            'ductAzimuthalMax',4,'ductRadialCount',3, ...
            'thetaQuadratureOrder',28,'zQuadratureOrder',24,'ductAxialMax',45);
        cfg.operatorBuilder=@build_two_cavity_augmented_operator;
        seeds=finite_pml_augmented_seeds(cfg,[1150 1599.999],[0.05 180]);
        args={'RealRangeHz',[1150 1599.999],'ImagRangeHz',[0.05 180], ...
            'GridSize',[17 11],'MaxCandidates',28,'ResidualTolerance',3e-5, ...
            'FminMaxIterations',180,'FminMaxEvaluations',550,'UseFsolve',true, ...
            'InitialSeedsHz',seeds};
    case "standard"
        cfg=two_cavity_parameters;
        cfg.operatorBuilder=@build_two_cavity_augmented_operator;
        seeds=finite_pml_augmented_seeds(cfg,[1150 1599.999],[0.05 180]);
        args={'RealRangeHz',[1150 1599.999],'ImagRangeHz',[0.05 180], ...
            'GridSize',[49 29],'MaxCandidates',100,'ResidualTolerance',1e-6, ...
            'FminMaxIterations',300,'FminMaxEvaluations',1000,'UseFsolve',true, ...
            'InitialSeedsHz',seeds};
    otherwise
        error('Resolution must be quick or standard.');
end

C=parse_comsol_sector_txt(opt.TxtFile);
C=C(C.frequency_real_Hz<1600,:);
R=find_single_sector_resonances(cfg,args{:},'Verbose',true);
M=two_cavity_radiation_channels(R);
comparison=compare_two_cavity_to_comsol(C,M,opt.OutputDir);
if ~exist(opt.OutputDir,'dir'),mkdir(opt.OutputDir);end
save(fullfile(opt.OutputDir,'two_cavity_theory_state.mat'),'cfg','C','R','M','comparison','-v7.3');
result=struct('cfg',cfg,'comsol',C,'roots',R,'channels',M,'comparison',comparison);
end

function seeds=finite_pml_augmented_seeds(cfg,rr,ir)
zL=-cfg.ductPhysicalLength/2-cfg.pmlStretch*cfg.pmlLength;
zR= cfg.ductPhysicalLength/2+cfg.pmlStretch*cfg.pmlLength;
q=(0:cfg.ductAxialMax).'*pi/(zR-zL);seeds=[];
for m=[0 1]
    d=find(cfg.duct.m==m&cfg.duct.n==0,1);
    f=cfg.c0/(2*pi)*sqrt(cfg.duct.alpha(d)^2+q.^2);
    f(real(f)<0)=-f(real(f)<0);
    keep=real(f)>=rr(1)&real(f)<=rr(2)&imag(f)>=ir(1)&imag(f)<=ir(2);
    fk=f(keep);seeds=[seeds;fk]; %#ok<AGROW>
    if m==1,seeds=[seeds;fk-4;fk+4];end %#ok<AGROW>
end
seeds=unique(round(real(seeds),7)+1i*round(imag(seeds),7),'stable');
end
