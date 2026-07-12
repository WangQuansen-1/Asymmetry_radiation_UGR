function result=track_comsol_tvb_modes_mac(varargin)
%TRACK_COMSOL_TVB_MODES_MAC Track lossless modes into the TVB spectrum.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('NoLossFile',fullfile(here,'comsol_no_loss_mac_eigenmodes.csv'));
ip.addParameter('LossFile',fullfile(here,'comsol_tvb_eigenmodes_mac.csv'));
ip.addParameter('FieldFile',fullfile(here,'comsol_tvb_mac_fields.mat'));
ip.addParameter('OutputFile',fullfile(here,'comsol_tvb_mac_mapping.csv'));
ip.addParameter('MaxRelativeShift',0.15);
ip.parse(varargin{:});opt=ip.Results;

R0=readtable(opt.NoLossFile,'VariableNamingRule','preserve');
RL=readtable(opt.LossFile,'VariableNamingRule','preserve');
if ismember('Eoz1_fraction',R0.Properties.VariableNames)
    forward0=R0.Eoz1_fraction;backward0=R0.Eof1_fraction;
else
    forward0=R0.Forward;backward0=R0.Backward;
end
F=load(opt.FieldFile,'fNoLoss','pNoLoss','fLoss','pLoss');
f0Table=complex(R0.frequency_real_Hz,R0.frequency_imag_Hz);
fLTable=complex(RL.frequency_real_Hz,RL.frequency_imag_Hz);
order0=frequency_row_map(f0Table,F.fNoLoss(:));
orderL=frequency_row_map(fLTable,F.fLoss(:));
P0=F.pNoLoss(order0,:);PL=F.pLoss(orderL,:);
validPoint=all(isfinite(P0),1) & all(isfinite(PL),1);
if ~any(validPoint)
    error('No finite pressure sampling points are shared by both spectra.');
end
P0=P0(:,validPoint);PL=PL(:,validPoint);
P0=P0./max(sqrt(sum(abs(P0).^2,2)),eps);
PL=PL./max(sqrt(sum(abs(PL).^2,2)),eps);
MAC=abs(P0*PL').^2;

nr=size(MAC,1);nl=size(MAC,2);C=1-MAC;
for i=1:nr
    rel=abs(real(fLTable)-real(f0Table(i)))/max(abs(real(f0Table(i))),eps);
    C(i,:)=C(i,:)+0.10*(rel(:).'/opt.MaxRelativeShift);
    C(i,rel>opt.MaxRelativeShift)=1e4+rel(rel>opt.MaxRelativeShift);
end
if exist('matchpairs','file')==2
    pairs=sortrows(matchpairs(C,1e6,'min'),1);
else
    pairs=greedy_pairs(C);
end

n=size(pairs,1);ii=pairs(:,1);jj=pairs(:,2);
T=table(R0.comsol_index(ii),RL.comsol_index(jj),MAC(sub2ind(size(MAC),ii,jj)), ...
    R0.frequency_real_Hz(ii),RL.frequency_real_Hz(jj), ...
    RL.frequency_real_Hz(jj)-R0.frequency_real_Hz(ii), ...
    R0.frequency_imag_Hz(ii),RL.frequency_imag_Hz(jj), ...
    RL.frequency_imag_Hz(jj)-R0.frequency_imag_Hz(ii), ...
    forward0(ii),RL.Forward(jj),backward0(ii),RL.Backward(jj), ...
    'VariableNames',{'no_loss_index','tvb_root_index','MAC', ...
    'no_loss_real_Hz','tvb_real_Hz','real_shift_Hz','no_loss_imag_Hz', ...
    'tvb_imag_Hz','imag_increment_Hz','no_loss_Forward','tvb_Forward', ...
    'no_loss_Backward','tvb_Backward'});
T.tracking_quality=repmat("low",n,1);
T.tracking_quality(T.MAC>=0.7)="moderate";
T.tracking_quality(T.MAC>=0.9)="high";
writetable(T,opt.OutputFile);
fprintf('MAC tracking: %d modes, high=%d, moderate=%d, median MAC=%.4f\n', ...
    n,nnz(T.tracking_quality=="high"),nnz(T.tracking_quality=="moderate"),median(T.MAC));
fprintf('Pressure sampling points used: %d/%d\n',nnz(validPoint),numel(validPoint));
result=struct('table',T,'MAC',MAC,'pairs',pairs);
end

function order=frequency_row_map(tableFrequency,fieldFrequency)
% Map sorted/exported frequency rows back to the solver's field row order.
scale=max(abs(tableFrequency),1);
C=abs(tableFrequency(:)-fieldFrequency(:).')./scale(:);
if exist('matchpairs','file')~=2,error('Statistics Toolbox matchpairs is required.');end
p=sortrows(matchpairs(C,1e6,'min'),1);
if size(p,1)~=numel(tableFrequency) || max(C(sub2ind(size(C),p(:,1),p(:,2))))>1e-8
    error('Could not align pressure-field rows with the frequency table.');
end
order=p(:,2);
end

function pairs=greedy_pairs(C)
pairs=zeros(min(size(C)),2);W=C;
for k=1:size(pairs,1)
    [~,q]=min(W,[],'all','linear');[i,j]=ind2sub(size(W),q);
    pairs(k,:)=[i,j];W(i,:)=inf;W(:,j)=inf;
end
pairs=sortrows(pairs,1);
end
