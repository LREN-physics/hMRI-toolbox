function hmri_quiqi_check(job)
%==========================================================================

% PURPOSE: Plot Residuals of the estimated model with respect to the Motion
% Degradation Index to evaluate the efficiency of the weighting
%
%
% METHODS: Spatial variance of the residuals of each subject is plotted
% with respect to their corresponfing MDI value
%
%_______________________________________________________________________
% Antoine Lutti
% 2021.04.01
% Neuroimaging Research Laboratory, Lausanne University Hospital &
% University of Lausanne, Lausanne, Switzerland
% Nad?ge Corbin
% 2021.03.30
% Centre de R?sonance Magn?tique des Syst?mes Biologiques, Bordeaux, France
%==========================================================================

hmri_log(sprintf('\t--- Evaluate residuals and MDI relationship ---'));
%% ***********************************************%%
% Get Inputs
%*************************************************%%

% SPM.mat file
spm_mat_file      =   job.spm_mat_file;
load(spm_mat_file{1});

% Order of the polynomial fit
pow      =   job.power;


%% ***********************************************%%
% Get Residuals files
%*************************************************%%
[pn fn]=fileparts(spm_mat_file{1});
ResFiles=cellstr(spm_select('FPList',pn,'^Res_'));

if length(ResFiles{1})==0
    error('No residual files could be found in the folder of the SPM.mat file')
end


%% ***********************************************%%
% Get Mask
%*************************************************%%

fileMask=cellstr(spm_select('FPList',pn,'^mask.nii'));

if length(fileMask{1})==0
    error('No mask could be found in the folder of the SPM.mat file')
end

Mask=spm_read_vols(spm_vol(fileMask{1}));
MaskIndx=find(Mask~=0);

%% ***********************************************%%
% Get MDI values
%*************************************************%%

if ~(isfield(SPM,'QUIQI_MDI'))
    error('There is no QUIQI_MDI field in the SPM structure')
end

MDIVals=SPM.QUIQI_MDI;

%% ***********************************************%%
% Compute variance of the residuals
%*************************************************%%

ResidVar=zeros(size(MDIVals,1),1);
for Subjctr=1:size(MDIVals,1)% reads-in individual residual maps and estimates variance
    
    tempRes=spm_read_vols(spm_vol(ResFiles{Subjctr}));
    ResidVar(Subjctr)=var(tempRes(MaskIndx),'omitnan');
    
end


%% ***********************************************%%
% Fit of the residuals with respect to MDI
%*************************************************%%

for type=1:size(MDIVals,2)
    [P,Rsq,yfit]=myPolyFit(MDIVals(:,type),ResidVar,pow,'Free');
    plotLinFit(MDIVals(:,type),ResidVar',yfit,P,pow,Rsq,['MDI (s^-^1) - Type ' num2str(type)],'Residuals (Var)',SPM.swd)
end

end

function [P,Rsq,yfit]=myPolyFit(X,Y,Powers,FitMethod)
% Polynomial fitting routine
% INPUTS:
%     - X: independent variable
%     - Y: dependent variable
%     - Powers: order of the polynomial fit
%     - FitMethod: allowed values: 1. 'NonNeg' - enforces positive
%     polynomial coefficients. 2. 'Free' - allows positive and negative
%     polynomial coefficients.

% OUTPUTS:
%     - P: polynomial coefficients
%     - Rsq: R-square of the fit
%     - yfit: fitted dependent variable
%
%__________________________________________________________________________
% Copyright (C) 2021 Laboratory for Neuroimaging Research
% Written by A. Lutti, 2021.
% Laboratory for Neuroimaging Research, Lausanne University Hospital, Switzerland

Powers=linspace(0,Powers,Powers+1);
P=zeros(size(Powers,2),size(Y,2));
Rsq=zeros(1,size(Y,2));
for ctr=1:size(Y,2)
    Ytemp=squeeze(Y(:,ctr));
    if strcmp(FitMethod,'NonNeg')
        Xmat=[];
        for ctr2=1:size(Powers,2)
            Xmat=cat(2,Xmat,X.^Powers(ctr2));
        end
        P(:,ctr) = lsqnonneg(Xmat,Ytemp);
        yfit =Xmat* P(:,ctr); %polyval(P(:,ctr),X);%yfit=P(1)*R2sArray+P(2)
    elseif strcmp(FitMethod,'Free')
        P(:,ctr)=polyfit(X,Ytemp,max(Powers));
        yfit =polyval(P(:,ctr),X);%yfit=P(1)*R2sArray+P(2)
        P(:,ctr)=P(end:-1:1,ctr)';%consistently with 'NonNeg', P is sorted in increasing powers of the model
    end
    SSresid = sum((Ytemp - yfit).^2);
    SStotal = (length(Ytemp)-1) * var(Ytemp);
    Rsq(ctr) = 1 - SSresid/SStotal;%     Slope = P(1)
end

end


function plotLinFit(X,Y,yfit,P,Powers,Rsq,xlabl,ylabl,SavePath)
% Plots data and their polynomial fits. Figure title includes polynomial
% coefficients and r-square
%
%__________________________________________________________________________
% Copyright (C) 2021 Laboratory for Neuroimaging Research
% Written by A. Lutti, 2021.
% Laboratory for Neuroimaging Research, Lausanne University Hospital, Switzerland

base=10;
figure
plot(X,Y,'.')
hold
plot(sort(X),sort(yfit),'m')
Powers=linspace(0,Powers,Powers+1);

ctr=1;
Str1=['(\alpha_' num2str(Powers(ctr))];
if P(ctr)~=0
    RoundingStr=['1e' num2str(-floor(log(abs(P(ctr)))./log(base))+1)];
    DisplayStr1=['1e' num2str(-floor(log(abs(P(ctr)))./log(base)))];
    DisplayStr2=['e' num2str(floor(log(abs(P(ctr)))./log(base)))];
    Str2=['(' num2str(round(P(ctr)*eval(RoundingStr))/eval(RoundingStr)*eval(DisplayStr1)) DisplayStr2];
else
    Str2=['(' num2str(0)];

end
for ctr=2:size(Powers,2)% (size(P,1)-1):-1:1
    Str1=[Str1,[', \alpha_' num2str(Powers(ctr))]];
    if P(ctr)~=0
        RoundingStr=['1e' num2str(-floor(log(abs(P(ctr)))./log(base))+1)];
        DisplayStr1=['1e' num2str(-floor(log(abs(P(ctr)))./log(base)))];
        DisplayStr2=['e' num2str(floor(log(abs(P(ctr)))./log(base)))];
        Str2=[Str2,[', ' num2str(round(P(ctr)*eval(RoundingStr))/eval(RoundingStr)*eval(DisplayStr1)) DisplayStr2]];
    else
        Str2=[Str2,', ' num2str(0)];
    end
end
Str1=[Str1,') = '];Str2=[Str2,')'];
title([Str1 Str2 '; R^2 = ' num2str(round(Rsq*1e2)/1e2)])
ylabel(ylabl);xlabel(xlabl);
saveas(gcf, fullfile(SavePath,'MDIvsRes'), 'fig');
end
