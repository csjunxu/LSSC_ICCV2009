clear;
%% read  image directory
Original_image_dir = '../dnd_2017/images_srgb/';
fpath = fullfile(Original_image_dir, '*.mat');
im_dir  = dir(fpath);
im_num = length(im_dir);
addpath = 'libs';
load '../dnd_2017/info.mat';

method = 'LSSC';
write_MAT_dir = ['../dnd_2017Results/'];
write_sRGB_dir = ['../dnd_2017Results/' method];
if ~isdir(write_sRGB_dir)
    mkdir(write_sRGB_dir)
end

colorspace = 'opp' ;
print_to_screen = 0;
profile = 'np'; %or 'np'

PSNR = [];
SSIM = [];
RunTime = [];
for i = 1:im_num
    load(fullfile(Original_image_dir, im_dir(i).name));
    S = regexp(im_dir(i).name, '\.', 'split');
    [h,w,ch] = size(InoisySRGB);
    for j = 1:size(info(1).boundingboxes,1)
        IMname = [S{1} '_' num2str(j)];
        IMin = InoisySRGB(info(i).boundingboxes(j,1):info(i).boundingboxes(j,3),info(i).boundingboxes(j,2):info(i).boundingboxes(j,4),1:3);
        IM_GT = IMin;
        time0 = clock;
        for c = 1:ch
            nSig(c) = NoiseEstimation(IMin(:, :, c)*255, 8);
            IMout(:, :, c)=denoise(IMin(:, :, c), nSig(c), IM_GT(:,:,c));
        end
        RunTime = [RunTime etime(clock,time0)];
        fprintf('Total elapsed time = %f s\n', (etime(clock,time0)) );
        %% output
        PSNR = [PSNR csnr( IMout*255, IM_GT*255, 0, 0 )];
        SSIM = [SSIM cal_ssim( IMout*255, IM_GT*255, 0, 0 )];
        fprintf('The final PSNR = %2.4f, SSIM = %2.4f. \n', PSNR(end), SSIM(end));
        %% output
        imwrite(IMout, [write_sRGB_dir 'Real_' method '/' method '_our' num2str(im_num) '_' IMname '.png']);
    end
    clear InoisySRGB;
end
    mPSNR = mean(PSNR);
    mSSIM = mean(SSIM);
    mRunTime = mean(RunTime);
    matname = sprintf([write_sRGB_dir method '_dnd2017' num2str(im_num) '.mat']);
    save(matname,'PSNR','SSIM','mPSNR','mSSIM','RunTime','mRunTime');