function output = removeNoiseIC(bazhenovSpecification)
%REMOVENOISEIC - Set all initial condition noise to 0 for (Bazhenov et al., 2002) models
%
% For a (Bazhenov et al., 2002)-style DynaSim specification, this function
% simply sets all the initial condition noise terms to 0, so that every
% simulation using this has the same starting conditions. This is useful for
% both reproducibility and debugging.
%
% Inputs:
%   'bazhenovSpecification': DynaSim specification structure for the (Bazhenov
%                            et al., 2002) model
%     - see dsCheckModel and dsCheckSpecification for details
%
% Outputs:
%   'output': DynaSim specification structure for the (Bazhenov
%             et al., 2002) model with all initial condition noise removed.
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
%% 1. Set all NoiseIC terms to 0
% ------------------------------------------
modifications  = {...
  'INdr',        'CaBufferNoiseIC'     ,     0;
  'TRN',         'CaBufferNoiseIC'     ,     0;
  'PYdr',        'CaBufferNoiseIC'     ,     0;
  'TC',          'CaBufferNoiseIC'     ,     0;
  'INdr<-PYso',  'sAMPANoiseIC'        ,     0;
  'INdr<-PYso',  'deprAMPANoiseIC'     ,     0;
  'INdr<-TC',    'sAMPANoiseIC'        ,     0;
  'INdr<-TC',    'deprAMPANoiseIC'     ,     0;
  'PYdr<-PYso',  'sAMPANoiseIC'        ,     0;
  'PYdr<-PYso',  'deprAMPANoiseIC'     ,     0;
  'PYdr<-TC',    'sAMPANoiseIC'        ,     0;
  'PYdr<-TC',    'deprAMPANoiseIC'     ,     0;
  'TRN<-PYso',   'sAMPANoiseIC'        ,     0;
  'TRN<-TC',     'sAMPANoiseIC'        ,     0;
  'TC<-PYso',    'sAMPANoiseIC'        ,     0;
  'PYdr<-INso',  'sGABAANoiseIC'       ,     0;
  'PYdr<-INso',  'deprGABAANoiseIC'    ,     0;
  'TRN<-TRN',    'sGABAANoiseIC'       ,     0;
  'TC<-TRN',     'sGABAANoiseIC'       ,     0;
  'TC<-TRN',     'rGABABNoiseIC'       ,     0;
  'TC<-TRN',     'gGABABNoiseIC'       ,     0;
  'TC',          'OpenHNoiseIC'        ,     0;
  'TC',          'PoneHNoiseIC'        ,     0;
  'TC',          'OpenLockedHNoiseIC'  ,     0;
  'INdr',        'mHVANoiseIC'         ,     0;
  'INdr',        'hHVANoiseIC'         ,     0;
  'PYdr',        'mHVANoiseIC'         ,     0;
  'PYdr',        'hHVANoiseIC'         ,     0;
  'INdr',        'mKCaNoiseIC'         ,     0;
  'PYdr',        'mKCaNoiseIC'         ,     0;
  'INso',        'nKNoiseIC'           ,     0;
  'TRN',         'nKNoiseIC'           ,     0;
  'PYso',        'nKNoiseIC'           ,     0;
  'TC',          'nKNoiseIC'           ,     0;
  'INdr',        'mMNoiseIC'           ,     0;
  'INdr<-PYso',  'neMiniNoiseIC'       ,     0;
  'INdr<-PYso',  'laMiniNoiseIC'       ,     0;
  'PYdr<-PYso',  'neMiniNoiseIC'       ,     0;
  'PYdr<-PYso',  'laMiniNoiseIC'       ,     0;
  'PYdr<-INso',  'neMiniNoiseIC'       ,     0;
  'PYdr<-INso',  'laMiniNoiseIC'       ,     0;
  'PYdr',        'mMNoiseIC'           ,     0;
  'INdr',        'mNaNoiseIC'          ,     0;
  'INdr',        'hNaNoiseIC'          ,     0;
  'INso',        'mNaNoiseIC'          ,     0;
  'INso',        'hNaNoiseIC'          ,     0;
  'TRN',         'mNaNoiseIC'          ,     0;
  'TRN',         'hNaNoiseIC'          ,     0;
  'PYdr',        'mNaPNoiseIC'         ,     0;
  'PYso',        'mNaPNoiseIC'         ,     0;
  'PYdr',        'mNaNoiseIC'          ,     0;
  'PYdr',        'hNaNoiseIC'          ,     0;
  'PYso',        'mNaNoiseIC'          ,     0;
  'PYso',        'hNaNoiseIC'          ,     0;
  'TC',          'mNaNoiseIC'          ,     0;
  'TC',          'hNaNoiseIC'          ,     0;
  'INdr<-PYso',  'sNMDANoiseIC'        ,     0;
  'PYdr<-PYso',  'sNMDANoiseIC'        ,     0;
  'TRN',         'mTNoiseIC'           ,     0;
  'TRN',         'hTNoiseIC'           ,     0;
  'TC',          'mTNoiseIC'           ,     0;
  'TC',          'hTNoiseIC'           ,     0;
  'INdr',        'vNoiseIC'            ,     0;
  'INso',        'vNoiseIC'            ,     0;
  'PYdr',        'vNoiseIC'            ,     0;
  'PYso',        'vNoiseIC'            ,     0;
  'TC',          'vNoiseIC'            ,     0;
  'TRN',         'vNoiseIC'            ,     0;
};

% ------------------------------------------
%% 2. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(bazhenovSpecification, modifications);
