format compact;
Original_image_dir  =    './data/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
for nSig = [60 80 20]
    PSNR = [];
    SSIM = [];
    for i=1:im_num
        I=double( imread(fullfile(Original_image_dir, im_dir(i).name)) )/255;
        Io=I;
        randn('seed',0);
        sigma=nSig/255;
        I=Io+sigma*randn(size(I));
        Iout=denoise(I,sigma,Io);
        PSNR =  [PSNR csnr( Iout*255, Io*255, 0, 0 )];
        SSIM      =  [SSIM cal_ssim( Iout*255, Io*255, 0, 0 )];
        imname = sprintf('LSSC_nSig%d_%s',nSig,im_dir(i).name);
        imwrite(Iout,imname);
    end 
     mPSNR=mean(PSNR);
    mSSIM=mean(SSIM);
    name = sprintf('LSSC_nSig%d.mat',nSig);
    save(name,'mPSNR','PSNR','SSIM','mSSIM');
end