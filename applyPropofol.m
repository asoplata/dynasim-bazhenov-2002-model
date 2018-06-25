function output = applyPropofol(bazhenovSpecification, decayTimeMultiplier, condMultiplier)
%APPLYPROPOFOL - Apply adjustment factors for applying propofol GABA-Aergic changes
%
% applyPropofol takes a (Bazhenov et al., 2002)-type DynaSim model
% specification and applies the adjustment factors for the "propofol" 
% anesthesia state.
%
% Inputs:
%   'bazhenovSpecification': DynaSim specification structure for the (Bazhenov
%                            et al., 2002) model
%       - see dsCheckModel and dsCheckSpecification for details
%   'decayTimeMultiplier': Amount to multiply GABA-A decay time from propofol
%   'condMultiplier': Amount to multiply GABA-A maximal conductance from propofol
%
% Outputs:
%   'output': DynaSim specification structure for the (Bazhenov
%             et al., 2002) model with the adjustment factors applied
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
    'PYdr<-INso', 'propofolTauMult',      decayTimeMultiplier;
    'PYdr<-INso', 'propofolCondMult',     condMultiplier;
    'PYdr<-INso', 'propofolMiniCondMult', condMultiplier;

    'TRN<-TRN', 'propofolTauMult',  decayTimeMultiplier;
    'TRN<-TRN', 'propofolCondMult', condMultiplier;

    'TC<-TRN', 'propofolTauMult',   decayTimeMultiplier;
    'TC<-TRN', 'propofolCondMult',  condMultiplier;
};

% ------------------------------------------
%% 3. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(bazhenovSpecification, modifications);
