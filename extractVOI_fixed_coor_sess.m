%__________________________________________________________________________
% Batch script:
%   - % create PPI variable: VOI.img VOI.hdr >> VOI.mat
% by Roberta Bianco 2017
%__________________________________________________________________________
% % Volume of Interest module

% define 2 regions of interest,where one will refer to the SPM.mat and the other to the sphere.
% The SPM index to provide for the nearest local maximum is the index in
% the list of 'Regions of Interest' that correspond to the SPM considered.
% Then the 'Expression' can be 'i2' or 'i1 & i2' whether you want all
% voxels within the sphere or only those that are also above the threshold
% in the SPM.

% mode
clc
clear
clear matlabbatch
cd ('dir/SCRIPTS/PPI_script/');
spm fmri
spm_jobman('initcfg')

sess= {'sess1', 'sess2', 'sess3', 'sess4'};
subject = {'01','02','03'};

% subject = {'VP01'};
task= '_plan_';
roi   = {'hand_left'};
coord = {[-34 -24 68]};
% root directory
d0='dir/DATA/';

for b = 1: length(sess)
    
    for s = 1: length(subject)
        
        clear matlabbatch;
        subdirGLM=[d0 subject{s} '/analysis' task sess{b} '/'];

        %--setting variables-------------------------------------
        
        for r = 1:length(roi)
            
            matlabbatch{1}.spm.util.voi.spmmat =cellstr([subdirGLM 'SPM.mat']);
            matlabbatch{1}.spm.util.voi.adjust = 0;
            matlabbatch{1}.spm.util.voi.session = 1;
            matlabbatch{1}.spm.util.voi.name = [roi{r} '_' sess{b}];
            matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
            matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 1;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
            matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 1;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = coord{r};
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 5;
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.local.mask = '';
            matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';    %'Expression' can be 'i2'=  all voxels within the sphere
            % 'i1 & i2'= only those that are also above the threshold in the SPM
            matlabbatch{2}.spm.stats.ppi.spmmat = {subdirGLM 'SPM.mat'};
            matlabbatch{2}.spm.stats.ppi.type.ppi.voi = {[subdirGLM 'VOI_' roi{r} '_' sess{b} '_1.mat']};
            matlabbatch{2}.spm.stats.ppi.type.ppi.u = [1 1 -1; 2 1 1; 3 1 0];
            matlabbatch{2}.spm.stats.ppi.name = [roi{r} '_' sess{b}];
            matlabbatch{2}.spm.stats.ppi.disp = 0;
        end
        spm_jobman('run',matlabbatch);
    end
    
end
