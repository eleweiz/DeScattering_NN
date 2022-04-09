function [sPSF_z ballisticPSF_z scatteredPSF_z] = sim_get_modeled_sPSF(z,sl,dx,Nx,r_ex)
    
    z_range = -Nx*dx/2:dx:(Nx-1)*dx/2;

    Inorm_pk_z = 0.92*exp(-0.94*z/sl);% from [kim2007multifocal]

    fwhm_ballisticPSF = r_ex;% [um]
    fwhm_scatteredPSF = fwhm_ballisticPSF + 12.5*z/sl;% [um]
    
    sigma_ballisticPSF = fwhm_ballisticPSF/2.35482;% in[um]
    sigma_ballisticPSF = sigma_ballisticPSF/dx;% in PS pixel size
        
    sigma_scatteredPSF = fwhm_scatteredPSF/2.35482;% in[um]
    sigma_scatteredPSF = sigma_scatteredPSF/dx;% in PS pixel size
    
    ballisticPSF_surf = fspecial('gaussian',Nx,sigma_ballisticPSF);% same as excitaion PSF
    ballisticPSF_z = Inorm_pk_z*ballisticPSF_surf;

    scatteredPSF_z = (1-sum(ballisticPSF_z(:)))*fspecial('gaussian',Nx,sigma_scatteredPSF);% same as excitaion PSF

    sPSF_z = ballisticPSF_z+scatteredPSF_z;
end
