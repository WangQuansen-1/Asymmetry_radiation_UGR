function eigResult = solve_open_eigenmodes(sys)
%SOLVE_OPEN_EIGENMODES Solve K p = k^2 M p near the target frequency.

cfg=sys.cfg;
sigma=(2*pi*cfg.targetEigenfrequency/cfg.c0)^2;
opts=struct('tol',2e-8,'maxit',600,'disp',0);
[V,D]=eigs(sys.K,sys.M,cfg.numEigenmodes,sigma,opts);
lambda=diag(D);
freq=cfg.c0/(2*pi)*sqrt(lambda);
flip=real(freq)<0; freq(flip)=-freq(flip);
[~,order]=sort(abs(real(freq)-cfg.targetEigenfrequency));
freq=freq(order);V=V(:,order);

channels=cell(numel(freq),1);
score=zeros(numel(freq),1);
for k=1:numel(freq)
    channels{k}=extract_six_channels(sys,V(:,k),freq(k));
    score(k)=channels{k}.lowerFraction(1)+channels{k}.upperFraction(1);
end
near=abs(real(freq)-cfg.targetEigenfrequency)<120;
if any(near)
    candidates=find(near); [~,j]=max(score(near)); target=candidates(j);
else
    target=1;
end
eigResult=struct('frequency',freq,'modes',V,'channels',{channels}, ...
    'targetIndex',target,'targetFrequency',freq(target), ...
    'targetChannels',channels{target});
end
