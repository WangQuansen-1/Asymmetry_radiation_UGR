function T=compute_comsol_tvb_reference(varargin)
%COMPUTE_COMSOL_TVB_REFERENCE Run TVB eigenstudy in an unsaved model copy.
% This helper requires COMSOL LiveLink. It never saves or overwrites the MPH.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('ModelFile',fullfile(fileparts(here), ...
    '双层结构非对称测试_仿照optic_左右手性相同_CPA_200-辐射.mph'));
ip.addParameter('OutputFile',fullfile(here,'comsol_tvb_eigenmodes.csv'));
ip.addParameter('NoLossOutputFile',fullfile(here,'comsol_no_loss_mac_eigenmodes.csv'));
ip.addParameter('ModelTag','LossAudit');
ip.addParameter('NumEigenvalues',60);
ip.addParameter('NoLossNumEigenvalues',30);
ip.addParameter('ShiftKHz',1.5);
ip.addParameter('FieldOutputFile',fullfile(here,'comsol_tvb_mac_fields.mat'));
ip.addParameter('NumSamplePoints',2000);
ip.parse(varargin{:});opt=ip.Results;

import com.comsol.model.util.*
if any(strcmp(cell(ModelUtil.tags),opt.ModelTag)),ModelUtil.remove(opt.ModelTag);end
cleanup=onCleanup(@()remove_copy(opt.ModelTag));
model=mphopen(opt.ModelFile,opt.ModelTag);
S=load(fullfile(here,'frozen_geometry_mesh.mat'),'mesh');
v=double(S.mesh.vertex);eligible=find(abs(v(3,:))<0.55);
pick=unique(round(linspace(1,numel(eligible),opt.NumSamplePoints)));
coord=v(:,eligible(pick));
eig=model.study('std1').feature('eig');
tvb=model.component('comp1').physics('acpr').feature('tvb1');
tvb.active(false);
disabled=cell(eig.getStringArray('disabledphysics'));
if ~any(strcmp(disabled,'acpr/tvb1')),disabled{end+1}='acpr/tvb1';end
eig.set('disabledphysics',disabled);
eig.set('neigs',opt.NoLossNumEigenvalues);
eig.set('neigsactive',true);
eig.set('shift',num2str(opt.ShiftKHz,16));
fprintf('Running COMSOL no-loss eigenstudy (%d requested eigenvalues) ...\n', ...
    opt.NoLossNumEigenvalues);
model.study('std1').run;
fNoLoss=mphglobal(model,'freq','dataset','dset1','complexout','on');
pNoLoss=mphinterp(model,'p','coord',coord,'dataset','dset1');
T0=spectrum_table(model,fNoLoss);
writetable(T0,opt.NoLossOutputFile);

disabled=cell(eig.getStringArray('disabledphysics'));
disabled=disabled(~strcmp(disabled,'acpr/tvb1'));
eig.set('disabledphysics',disabled);
tvb.active(true);
eig.set('neigs',opt.NumEigenvalues);
fprintf('Running COMSOL TVB eigenstudy (%d requested eigenvalues) ...\n', ...
    opt.NumEigenvalues);
model.study('std1').run;

f=mphglobal(model,'freq','dataset','dset1','complexout','on');
pLoss=mphinterp(model,'p','coord',coord,'dataset','dset1');
fLoss=f;
save(opt.FieldOutputFile,'coord','fNoLoss','pNoLoss','fLoss','pLoss','-v7.3');
n=numel(f);T=spectrum_table(model,f);

pml=model.component('comp1').coordSystem('pml1').selection.entities;
try
    domains=model.component('comp1').physics('acpr').feature('fpam1').selection.entities;
    Ep=mphint2(model,'abs(acpr.p)^2','volume','selection',pml,'dataset','dset1');
    Et=mphint2(model,'abs(acpr.p)^2','volume','selection',domains,'dataset','dset1');
    T.pml_fraction=real(Ep(:)./Et(:));
catch ME
    warning('PML participation was not evaluated: %s',ME.message);
    T.pml_fraction=nan(n,1);
end
writetable(T,opt.OutputFile);
fprintf('Saved %d TVB eigenmodes to %s\n',n,opt.OutputFile);
clear cleanup
remove_copy(opt.ModelTag);
end

function T=spectrum_table(model,f)
n=numel(f);T=table((1:n).',real(f(:)),imag(f(:)), ...
    'VariableNames',{'comsol_index','frequency_real_Hz','frequency_imag_Hz'});
T.Q=T.frequency_real_Hz./(2*abs(T.frequency_imag_Hz));
names={'Eoz1','Eoz0','Eoz_1','Eof1','Eof0','Eof_1'};
for k=1:numel(names)
    value=mphglobal(model,names{k},'dataset','dset1');T.(names{k})=real(value(:));
end
dz=T.Eoz1+T.Eoz0+T.Eoz_1;df=T.Eof1+T.Eof0+T.Eof_1;
T.Forward=T.Eoz1./dz;T.Backward=T.Eof1./df;
end

function remove_copy(tag)
import com.comsol.model.util.*
try
    if any(strcmp(cell(ModelUtil.tags),tag)),ModelUtil.remove(tag);end
catch
end
end
