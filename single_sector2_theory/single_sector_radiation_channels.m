function T=single_sector_radiation_channels(result)
%SINGLE_SECTOR_RADIATION_CHANNELS Radiation ratios of each theoretical pole.
% The pole eigenvector is aperture pressure; q=Y*p is the aperture velocity.

n=numel(result.rootsHz);E=zeros(n,6);F=zeros(n,1);B=zeros(n,1);
for k=1:n
    p=result.nullVectors{k};state=result.state{k};q=state.Ycav*p;
    lower=state.radiation.lowerPropagationM;
    upper=state.radiation.upperPropagationM;
    aLower=lower.velocityMap*q;aUpper=upper.velocityMap*q;
    eLower=real(lower.powerWeight(:)).*abs(aLower(:)).^2;
    eUpper=real(upper.powerWeight(:)).*abs(aUpper(:)).^2;
    eLower=max(eLower,0);eUpper=max(eUpper,0);
    if sum(eLower)>0,eLower=eLower/sum(eLower);end
    if sum(eUpper)>0,eUpper=eUpper/sum(eUpper);end
    E(k,:)=[eLower(:).',eUpper(:).'];F(k)=E(k,1);B(k)=E(k,4);
end
T=table((1:n).',real(result.rootsHz),imag(result.rootsHz), ...
    E(:,1),E(:,2),E(:,3),E(:,4),E(:,5),E(:,6),F,B,result.residual, ...
    'VariableNames',{'theory_index','frequency_real_Hz','frequency_imag_Hz', ...
    'Eoz1_ratio','Eoz0_ratio','Eoz_1_ratio','Eof1_ratio','Eof0_ratio', ...
    'Eof_1_ratio','Forward','Backward','operator_residual'});
end
