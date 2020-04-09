%__________________________________________________________________________
% Batch script:
%   - % create PPI variable: VOI.img VOI.hdr >> VOI.mat
% by Roberta Bianco 2017
%__________________________________________________________________________
% 
clc
clear
clear matlabbatch
cd ('dir/PPI');

spm fmri
spm_jobman('initcfg')

sess= {'sess1', 'sess2', 'sess3', 'sess4'};
subject = {'01','02','03'};

% subject = {'VP01'};
task= '_plan_';
roi   = {'hand_left'};
coord = {[-34 -24 68]};
% root directory
% root directory
d0='dir/DATA/';


for b = 1: length(sess)
    for s = 1: length(subject)
        
        subdirGLM=[d0 subject{s} '/analysis' task sess{b} '/'];
        %rsltdir=[subdir roi{r} 'svc.rslt/'];
        
        %--setting variables-------------------------------------
        
        for r = 1:length(roi)
            
            matlabbatch{1}.spm.stats.ppi.spmmat = cellstr([subdirGLM 'SPM.mat']);
            matlabbatch{1}.spm.stats.ppi.type.ppi.voi = {[subdirGLM 'VOI_' roi{r} '_' sess{b} '_1.mat']};
            matlabbatch{1}.spm.stats.ppi.type.ppi.u = [1 1 -1; 2 1 1; 3 1 0];  %condition weigth contrast
            matlabbatch{1}.spm.stats.ppi.name = [roi{r} '_' sess{b}];
            matlabbatch{1}.spm.stats.ppi.disp = 0;
        end
        spm_jobman('run',matlabbatch);
        
    end
end
