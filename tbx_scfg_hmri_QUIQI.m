function quiqi=tbx_scfg_hmri_QUIQI
% 
% PURPOSE: Compute dictionaries of covariance matrices from the motion 
% degradation index.The disctionary  will be used by spm_reml.m or 
% spm_reml_sc.m to account for heteroscedasticity of the data.
% See " reference to the paper " for more details
% 
%
% METHODS: SPM.mat created when designing the model is modified to add in
% SPM.xVi.Vi the dictionary of covariance matrices. 
%
%_______________________________________________________________________
% Name lab 
% Name Author  - february 2021
% ======================================================================

% ---------------------------------------------------------------------
% SPM.mat file
% ---------------------------------------------------------------------
spm_mat_file         = cfg_files;
spm_mat_file.tag     = 'spm_mat_file';
spm_mat_file.name    = 'SPM.mat file';
spm_mat_file.help    = {'Select the SPM.mat file containing the design of the model '};
spm_mat_file.ufilter = '^SPM.mat$';
spm_mat_file.num     = [1 1];

% ---------------------------------------------------------------------
% Power of the MDI included in the dictionary 
% ---------------------------------------------------------------------
lambda        = cfg_entry;
lambda.tag     = 'lambda';
lambda.name    = 'MDI power ';
lambda.val     = {[0]};
lambda.strtype = 'e';
lambda.num     = [1 Inf];
lambda.help    = {['Specify the powers of the MDI to include in the dictionary.',... 
    'Vector of integers is expected. By default, a power of 0 is used,'... 
    'equivalent to the OLS case ']};
% ---------------------------------------------------------------------
% MDI values 
% ---------------------------------------------------------------------
MDIvalues        = cfg_entry;
MDIvalues.tag     = 'MDIvalues';
MDIvalues.name    = 'MDI values';
MDIvalues.val     = {[ones(10,1) 2*ones(10,1)]};
MDIvalues.strtype = 'e';
MDIvalues.num     = [Inf Inf];
MDIvalues.help    = {['Specify the Motion Degradation Index ',...
    'for each participant (one line per participant). Several columns',...
    'can be used if several MDI are available (For example, T1 maps have ',...
    '2 MDI available for each participant , one from the PDw images and ',...
    'another one from the T1w images']};

% ---------------------------------------------------------------------
% Compute dictionnary of covariance matrices based on the otion degradation
% index
% ---------------------------------------------------------------------

quiqi         = cfg_exbranch;
quiqi.tag     = 'quiqi';
quiqi.name    = 'QUIQI';
quiqi.val     = { spm_mat_file lambda MDIvalues };
quiqi.help    = {'Given the MDI index of each participant, a dictionary of'...
    'covariance matrices is built and stored in SPM.xVi.Vi. this dictionary',...
    'will be used subsequently by spm_reml.m or spm_reml_sc.m to account for',...
    'the heteroscedasticity of the data when estimating the model parameters '};
quiqi.prog    = @hmri_quiqi;
