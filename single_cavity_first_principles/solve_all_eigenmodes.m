function spectrum=solve_all_eigenmodes(sys,varargin)
%SOLVE_ALL_EIGENMODES Multi-shift search of the open-system complex plane.

ip=inputParser;
ip.addParameter('FrequencyRange',[1200 1900]);
ip.addParameter('ShiftFrequency',[1300+120i,1500+110i,1650+100i,1700+1i,1800+35i]);
ip.addParameter('NumCandidates',28);
ip.addParameter('DuplicateToleranceHz',1e-3);
ip.addParameter('ReturnModeSamples',false);
ip.addParameter('NumModeSamples',2000);
ip.parse(varargin{:});opt=ip.Results;

raw=zeros(0,10);
rawSamples=[];sampleIndices=[];
if opt.ReturnModeSamples
    if ~isfield(sys,'pmlElement') || ~any(sys.pmlElement)
        pool=1:sys.n;
    else
        pool=unique(double(sys.tet(:,~sys.pmlElement)));
    end
    pick=unique(round(linspace(1,numel(pool),min(opt.NumModeSamples,numel(pool)))));
    sampleIndices=pool(pick);
    rawSamples=zeros(numel(sampleIndices),0);
end
for sidx=1:numel(opt.ShiftFrequency)
    fs=opt.ShiftFrequency(sidx);
    sigma=(2*pi*fs/sys.cfg.c0)^2;
    k=opt.NumCandidates;
    eopts=struct('tol',5e-8,'maxit',1000,'disp',0,'p',max(2*k,40));
    fprintf('Complex shift %d/%d: %.1f%+.1fi Hz, %d eigenpairs ...\n', ...
        sidx,numel(opt.ShiftFrequency),real(fs),imag(fs),k);
    [V,D]=eigs(sys.K,sys.M,k,sigma,eopts);
    f=sys.cfg.c0/(2*pi)*sqrt(diag(D));
    flip=real(f)<0;f(flip)=-f(flip);
    keep=isfinite(f) & real(f)>=opt.FrequencyRange(1) & ...
        real(f)<=opt.FrequencyRange(2) & imag(f)>=-1;
    f=f(keep);V=V(:,keep);
    for q=1:numel(f)
        ch=extract_six_channels(sys,V(:,q),f(q));
        frac=[ch.lowerFraction,ch.upperFraction];
        raw(end+1,:)=[real(f(q)),imag(f(q)), ...
            real(f(q))/(2*max(abs(imag(f(q))),eps)),frac,sidx]; %#ok<AGROW>
        if opt.ReturnModeSamples
            rawSamples(:,end+1)=V(sampleIndices,q); %#ok<AGROW>
        end
    end
    clear V D
end

% Identical eigenpairs returned by neighboring shifts are removed without
% merging genuinely near-degenerate modes.
[~,order]=sortrows(raw(:,1:2),[1 2]);raw=raw(order,:);
if opt.ReturnModeSamples,rawSamples=rawSamples(:,order);end
take=true(size(raw,1),1);
for i=1:size(raw,1)
    if ~take(i),continue,end
    fi=complex(raw(i,1),raw(i,2));
    dup=find(take & (1:size(raw,1)).'>i & ...
        abs(complex(raw(:,1),raw(:,2))-fi)<opt.DuplicateToleranceHz);
    take(dup)=false;
end
raw=raw(take,:);
if opt.ReturnModeSamples,rawSamples=rawSamples(:,take);end
[~,order]=sort(raw(:,1));raw=raw(order,:);
if opt.ReturnModeSamples,rawSamples=rawSamples(:,order);end
n=size(raw,1);
T=array2table([(1:n).',raw],'VariableNames', ...
    {'theory_index','frequency_real_Hz','frequency_imag_Hz','Q', ...
    'Eoz1_fraction','Eoz0_fraction','Eoz_1_fraction', ...
    'Eof1_fraction','Eof0_fraction','Eof_1_fraction','source_shift_index'});
spectrum=struct('table',T,'frequency',complex(raw(:,1),raw(:,2)), ...
    'fractions',raw(:,4:9),'range',opt.FrequencyRange, ...
    'shift',opt.ShiftFrequency,'numRequestedPerShift',opt.NumCandidates);
if opt.ReturnModeSamples
    spectrum.modeSamples=rawSamples;
    spectrum.sampleIndices=sampleIndices(:);
end
end
