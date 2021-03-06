function output = applyPaperValues(bazhenovSpecification)
%APPLYPAPERVALUES - Apply values of model from paper, not code
%
% applyPaperValues takes a (Bazhenov et al., 2002)-type DynaSim model
% specification and applies the values given in the original paper, which are 
% not necessarily the same values as that seen in the source code. The default 
% values of this overall model (dynasim-bazhenov-2002-model) are based on the 
% values seen in the source code, not the paper.
%
% Inputs:
%   'bazhenovSpecification': DynaSim specification structure for the (Bazhenov
%                            et al., 2002) model
%       - see dsCheckModel and dsCheckSpecification for details
%
% Outputs:
%   'output': DynaSim specification structure for the (Bazhenov
%             et al., 2002) model with the paper's values applied
%
% Dependencies:
%   - This has only been tested on MATLAB version 2017a.
%
% References:
%   - Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of thalamocortical
%     slow-wave sleep oscillations and transitions to activated states. The
%     Journal of Neuroscience. 2002;22: 8691–8704.
%
% Author: Austin E. Soplata <austin.soplata@gmail.com>
% Copyright (C) 2018 Austin E. Soplata, Boston University, USA

% ------------------------------------------
%% 1. Combine all the changes to make
% ------------------------------------------

modifications = {...
'PYdr', 'gKLeak', 0.007;
'PYdr', 'gLeak',  0.023;
'PYdr', 'gNaP',   2.0;
'PYdr', 'gNa',    0.8;
'PYdr', 'gHVA',   0.012;
'PYdr', 'gKCa',   0.015;
'PYso', 'gNa',    3000;
'PYso', 'gK',     200;
'PYso', 'gNaP',   15;

'INdr', 'gKLeak', 0.034;
'INdr', 'gLeak',  0.006;
'INdr', 'gNa',    0.8;
'INdr', 'gHVA',   0.012;
'INdr', 'gKCa',   0.015;
'INso', 'gNa',    2500;
'INso', 'gK',     200;

'TC', 'gKLeak', 0.007;
'TC', 'gLeak',  0.01;
'TC', 'gNa',    90;
'TC', 'gK',     10;
'TC', 'gT',     2.5;
'TC', 'gH',     0.015;

'TRN', 'gKLeak', 0.016;
'TRN', 'gLeak',  0.05;
'TRN', 'gNa',    100;
'TRN', 'gK',     10;
'TRN', 'gT',     2.2;

% 0.024 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.15  mS/cm^2
'PYdr<-PYso', 'gAMPA',     0.15;
% 0.033 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.2   mS/cm^2
'PYdr<-PYso', 'gMiniAMPA', 0.2;
% 0.001 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.006 mS/cm^2
'PYdr<-PYso', 'gNMDA',     0.006;

% 0.012 uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.24 mS/cm^2
'INdr<-PYso', 'gAMPA',     0.24;
% 0.02  uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.4  mS/cm^2
'INdr<-PYso', 'gMiniAMPA', 0.4;
% 0.001 uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.02 mS/cm^2
'INdr<-PYso', 'gNMDA',     0.02;

% 0.024 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.15 mS/cm^2
'PYdr<-INso', 'gGABAA',     0.15;
% 0.02  uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.12 mS/cm^2
'PYdr<-INso', 'gMiniGABAA', 0.12;

% 0.05  uS * (1 mS / 1000 uS) * (1 / (2.9e-4 cm^2)) = 0.172 mS/cm^2
'TC<-TRN', 'gGABAA', 0.172;
% 0.02  uS * (1 mS / 1000 uS) * (1 / (2.9e-4 cm^2)) = 0.07  mS/cm^2
'TC<-TRN', 'gGABAB', 0.07;

% 0.05  uS * (1 mS / 1000 uS) * (1 / (1.43e-4 cm^2)) = 0.35 mS/cm^2
'TRN<-TRN', 'gGABAA', 0.35;

% 0.05  uS * (1 mS / 1000 uS) * (1 / (1.43e-4 cm^2)) = 0.35 mS/cm^2
'TRN<-TC', 'gAMPA', 0.35;

% 0.02 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.12 mS/cm^2
'PYdr<-TC', 'gAMPA', 0.12;
% 0.02 uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.4 mS/cm^2
'INdr<-TC', 'gAMPA', 0.4;
% 0.005  uS * (1 mS / 1000 uS) * (1 / (2.9e-4 cm^2)) = 0.0172  mS/cm^2
'TC<-PYso', 'gAMPA', 0.0172;
% 0.015  uS * (1 mS / 1000 uS) * (1 / (1.43e-4 cm^2)) = 0.105 mS/cm^2
'TRN<-PYso', 'gAMPA', 0.105;
};

% ------------------------------------------
%% 2. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(bazhenovSpecification, modifications);
