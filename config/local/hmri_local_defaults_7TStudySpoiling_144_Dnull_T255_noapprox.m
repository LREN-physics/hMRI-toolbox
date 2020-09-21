function hmri_local_defaults_7TStudySpoiling_144_Dnull_T255_noapprox
% PURPOSE
% To set user-defined (site- or protocol-specific) defaults parameters
% which are used by the hMRI toolbox. Customized processing parameters can
% be defined, overwriting defaults from hmri_defaults. Acquisition
% protocols can be specified here as a fallback solution when no metadata
% are available. Note that the use of metadata is strongly recommended. 
%
% RECOMMENDATIONS
% Parameters defined in this file are identical, initially, to the ones
% defined in hmri_defaults.m. It is recommended, when modifying this file,
% to remove all unchanged entries and save the file with a meaningful name.
% This will help you identifying the appropriate defaults to be used for
% each protocol, and will improve the readability of the file by pointing
% to the modified parameters only.
%
% WARNING
% Modification of the defaults parameters may impair the integrity of the
% toolbox, leading to unexpected behaviour. ONLY RECOMMENDED FOR ADVANCED
% USERS - i.e. who have a good knowledge of the underlying algorithms and
% implementation. The SAME SET OF DEFAULT PARAMETERS must be used to
% process uniformly all the data from a given study. 
%
% HOW DOES IT WORK?
% The modified defaults file can be selected using the "Configure toolbox"
% branch of the hMRI-Toolbox. For customization of B1 processing
% parameters, type "help hmri_b1_standard_defaults.m". 
%
% DOCUMENTATION
% A brief description of each parameter is provided together with
% guidelines and recommendations to modify these parameters. With few
% exceptions, parameters should ONLY be MODIFIED and customized BY ADVANCED
% USERS, having a good knowledge of the underlying algorithms and
% implementation. 
% Please refer to the documentation in the github WIKI for more details. 
%__________________________________________________________________________
% Written by E. Balteau, 2017.
% Cyclotron Research Centre, University of Liege, Belgium

% Global hmri_def variable used across the whole toolbox
global hmri_def

% cleanup temporary directories. If set to true, all temporary directories
% are deleted at the end of map creation, only the "Results" directory and
% "Supplementary" subdirectory are kept. Setting "cleanup" to "false" might
% be convenient if one desires to have a closer look at intermediate
% processing steps. Otherwise "cleanup = true" is recommended for saving
% disk space.
hmri_def.cleanup = false;

hmri_def.MPMacq_set.names{8} = 'BSS_Repro_7T';
hmri_def.MPMacq_set.tags{8}  = 'BSS_Repro_7T';
hmri_def.MPMacq_set.vals{8}  = [19.5 19.5 6 26];

% 8) 500um protocol - seq version 7T from Leipzig for 500um:
hmri_def.imperfectSpoilCorr.BSS_Repro_7T.tag = 'BSS_Repro_7T';
hmri_def.imperfectSpoilCorr.BSS_Repro_7T.P2_a = flip([-1.16980544, -80.62148565,  58.65116683]);
hmri_def.imperfectSpoilCorr.BSS_Repro_7T.P2_b = flip([0.9574699 ,  0.20275525, -0.12037706]);
hmri_def.imperfectSpoilCorr.BSS_Repro_7T.enabled = hmri_def.imperfectSpoilCorr.enabled;
