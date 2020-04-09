%__________________________________________________________________________
% Script:
%   -  to plot and mark the coordinates on anatomical brain!
% by Roberta Bianco 2017
%__________________________________________________________________________
%
addpath('/dir/scripts/nifti')
addpath('/dir/scripts/PPI')
clear

roi = {'rIFG'};


fid=fopen('/dir/DATA/RFX/visual/lIFG_inc-cong.txt');
data=textscan(fid, '%d %d %d %*s' , 'delimiter', '\t');
fclose(fid);
yourcoord =double(cell2mat(data));

nii = load_nii('/a/sw/spm/8.5236/8.3/2.19/canonical/single_subj_T1.nii');
figure
H = imageorth(nii.img);

%%
close all
for i=1:size(yourcoord,1)
    IJK(i,:) = round(xyz2ijk(yourcoord(i,:), nii));
end
meanijk = round(mean(IJK));

figure
imagesc(nii.img(:,:,meanijk(3))'); 
colormap gray; axis image
set(gca,'ydir','nor');
hold on
for i=1:size(yourcoord,1)
    ijk = xyz2ijk(yourcoord(i,:), nii);
    scatter(ijk(1), ijk(2), 'r+')
    
end
set(gca,'xdir','rev')

%
figure
ijk = round(xyz2ijk(yourcoord(i,:), nii));
imagesc(squeeze(nii.img(:,meanijk(2),:))'); colormap gray; axis image
set(gca,'ydir','nor');
hold on
for i=1:size(yourcoord,1)
    ijk = xyz2ijk(yourcoord(i,:), nii);
    scatter(ijk(1), ijk(3), 'r+')
    
end
set(gca,'xdir','rev')

%
figure
ijk = round(xyz2ijk(yourcoord(i,:), nii));
imagesc(squeeze(nii.img(meanijk(1),:,:))'); colormap gray; axis image
set(gca,'ydir','nor');
hold on
for i=1:size(yourcoord,1)
    ijk = xyz2ijk(yourcoord(i,:), nii);
    scatter(ijk(2), ijk(3), 'r+')
end
