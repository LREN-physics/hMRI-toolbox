function hmri_quiqi(job)
%==========================================================================
%
% PURPOSE: Compute dictionaries of covariance matrices from the motion
% degradation index.The disctionary  will be used by spm_reml.m or
% spm_reml_sc.m to account for heteroscedasticity of the data.
% See " reference to the paper " for more details
%
%
% METHODS: SPM.mat created when designing the model is modified to add in
% SPM.xVi.Vi the dictionary of covariance matrices.
%==========================================================================

hmri_log(sprintf('\t--- Build dictionary of covariance matrices based on the MDI ---'));
%% ***********************************************%%
% Get Inputs
%*************************************************%%

% SPM.mat file
spm_mat_file      =   job.spm_mat_file;
load(spm_mat_file{1});

% vector of MDI 
MDIvalues      =   job.MDIvalues;

if size(MDIvalues,1)~= size (SPM.xX.X,1)
    error('The length of MDI values is different from the number of lines in the design matrix')
end


% vector of powers of MDI
lambda = job.lambda;

%% ***********************************************%%
% create vectors of MDI to the power of lambda
% ************************************************%%
MatCovDict=[]; 
for indMDI= 1:size(MDIvalues,2)
    for indLam=1:size(lambda,2)
        MatCovDict=cat(2,MatCovDict,MDIvalues(:,indMDI).^lambda(indLam));
    end
end
                    

%% ***********************************************%%
% Check if a dictionary is already present. 
% One will exist if a group comparison has been specified
%*************************************************%%

if isfield(SPM.xVi,'Vi')% Group comparison
    GroupIndx={};DataSize=size(SPM.xVi.Vi{1},1);
    for ctr=1:size(SPM.xVi.Vi,2)
        GroupIndx{ctr}=find(diag(SPM.xVi.Vi{ctr})~=0);
    end
else
    DataSize=size(SPM.xVi.V,1);
    GroupIndx{1}=find(diag(SPM.xVi.V)~=0);
end
%SPM=rmfield(SPM,'xVi');


%% ***********************************************%%
% Create dictionary of covariance matrices and
% store them in SPM.xVi.Vi
%*************************************************%%
ind=0;
for indGroup=1:size(GroupIndx,2)% separate basis function for each power of the MDI AND group
    for indMat=1:length(MatCovDict)
        ind=ind+1;
        DiagTerms=zeros(length(MDIvalues),1);
        DiagTerms(GroupIndx{indGroup},1)=MatCovDict(GroupIndx{indGroup},indMat);
        SPM.xVi.Vi(ind)={sparse(diag(DiagTerms))};
    end
end

save(fullfile(CurrentDir,'SPM.mat'), 'SPM')

end