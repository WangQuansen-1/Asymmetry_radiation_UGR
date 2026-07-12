function seeds=finite_pml_duct_seeds(cfg,realRange,imagRange)
%FINITE_PML_DUCT_SEEDS Analytic empty-duct/PML eigenfrequency seeds.
% Neumann axial modes are evaluated in the complex stretched length.  The
% seeds are used only to locate narrow roots of the coupled operator.

Leff=cfg.ductPhysicalLength+2*cfg.pmlStretch*cfg.pmlLength;
fmax=max(realRange);kmax=2*pi*fmax/cfg.c0;
alpha=unique(round(cfg.duct.alpha,12));
rows=complex(zeros(0,1));
for ia=1:numel(alpha)
    for ell=0:ceil(abs(kmax*Leff)/pi)+30
        beta=ell*pi/Leff;k=sqrt(alpha(ia)^2+beta^2);
        if real(k)<0,k=-k;end
        if imag(k)<0,k=conj(k);end
        f=cfg.c0*k/(2*pi);
        if real(f)>=realRange(1)&&real(f)<=realRange(2)&& ...
                imag(f)>=imagRange(1)&&imag(f)<=imagRange(2)
            rows(end+1,1)=f; %#ok<AGROW>
        end
    end
end
seeds=unique(round(real(rows),8)+1i*round(imag(rows),8));
end
