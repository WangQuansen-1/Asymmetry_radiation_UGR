function T=two_cavity_radiation_channels(result)
%TWO_CAVITY_RADIATION_CHANNELS Six normalized radiated-power components.
n=numel(result.rootsHz);E=zeros(n,6);
for k=1:n
    p=result.nullVectors{k};st=result.state{k};
    if isfield(st,'augmented')&&st.augmented
        na=st.explicit.amplitudeCount;a=p(1:na);
        al=st.explicit.lowerPropagationPressureMap*a;
        au=st.explicit.upperPropagationPressureMap*a;
        el=real(st.explicit.powerWeight(:)).*abs(al).^2;
        eu=real(st.explicit.powerWeight(:)).*abs(au).^2;
    else
        v=st.Ycav*p;
        lo=st.radiation.lowerPropagationM;up=st.radiation.upperPropagationM;
        el=real(lo.powerWeight(:)).*abs(lo.velocityMap*v).^2;
        eu=real(up.powerWeight(:)).*abs(up.velocityMap*v).^2;
    end
    el=max(real(el),0);eu=max(real(eu),0);
    if sum(el)>0,el=el/sum(el);end
    if sum(eu)>0,eu=eu/sum(eu);end
    E(k,:)=[el(:).',eu(:).'];
end
T=table((1:n).',real(result.rootsHz),imag(result.rootsHz), ...
    E(:,1),E(:,2),E(:,3),E(:,4),E(:,5),E(:,6),E(:,1),E(:,4),result.residual, ...
    'VariableNames',{'theory_index','frequency_real_Hz','frequency_imag_Hz', ...
    'Eoz1_ratio','Eoz0_ratio','Eoz_1_ratio','Eof1_ratio','Eof0_ratio', ...
    'Eof_1_ratio','Forward','Backward','operator_residual'});
end
