function specification = assembleSpecCortexOnly(dt, numCellsScaledown)
%ASSEMBLESPECCORTEXONLY - Construct and connect the cortex of the (Bazhenov et al., 2002) model
%
% assembleSpecification builds a (Bazhenov et al., 2002)-type DynaSim
% specification, including both its populations and connections from the many
% mechanism files contained in the 'models/' subdirectory.
%
% Inputs:
%   'dt': time resolution of the simulation, in ms
%   'numCellsScaledown': number to multiply each cell population size
%                        by, between 0 and 1. To run the full model, use 
%                        1. If one wishes to run a smaller model, since 
%                        the default model is rather large, use a 
%                        smaller proportion like 0.2.
%
% Outputs:
%   'specification': DynaSim specification structure for the (Bazhenov
%                    et al., 2002) model.
%
% Note: By default, the specification output by this function is set to the
%   'Awake' behavioral state as used in (Bazhenov et al., 2002). To change
%   this, use the `applyExperimentFactors.m` function.
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


% -------------------------------------------------------------------
%% 1. Make master equations and initialize
% -------------------------------------------------------------------
% Define equations of cell model (same for all populations)
eqns={
  'dv/dt=(@current)/Cm'
  'Cm = 0.75'    % uF/cm^2
  'spike_threshold = -25'
  'monitor v.spikes(spike_threshold, 1)'
  'vIC = -68'    % mV
  'vNoiseIC = 0' % mV
  'v(0) = vIC+vNoiseIC*rand(1,Npop)'
};

% WARNING: Until indicated otherwise, only use the 'euler' integration when
%     using these soma equations. Use of non-euler integration may contain a
%     small amount of error due to the 'v(t-dt)' not being interpolated
%     correctly for "intermediary" timesteps during the integration/solution
%     process.
% Note that the voltage for the axo-somatic compartment is calculated using
%     a "reduced form" derived from dv/dt=0, NOT using the normal dv/dt method.
%     For an explanation of this, see (Chen et al., 2012) page 5, section
%     'Intrinsic currents - cortex', first paragraph.
eqns_soma = {
strcat(['dv/dt=((@voltage + (kappa*S_SOMA.*(@current+6.74172)))./' ...
               '(1 + kappa*S_SOMA.*(@conductance)) - v(t-'],num2str(dt),'))./',num2str(dt))
  'kappa=10e3'   % kOhms
  'S_SOMA=1e-6'  % cm^2
  'vIC = -68'    % mV
  'vNoiseIC = 0' % mV
  'v(0) = vIC+vNoiseIC*rand(1,Npop)'
  'spike_threshold = 0'
  'monitor v.spikes(spike_threshold, 1)'
};

% Initialize DynaSim specification structure
specification=[];

% -------------------------------------------------------------------
%% 2. Assemble Cortex Model and Intracortical Connections
% -------------------------------------------------------------------
% PY cells and intercompartmental PY connections:
specification.populations(1).name='PYdr';
specification.populations(1).size=round(numCellsScaledown*20);
specification.populations(1).equations=eqns;
specification.populations(1).mechanism_list={...
    'iAppliedCurrent',...
    'iKLeak_PYdr_B02',...
    'iLeak_PYdr_B02',...
    'iNaP_PYdr_B02',...
    'iNa_PYdr_B02',...
    'iM_PYdr_B02',...
    'CaBuffer_PYdr_B02', 'iHVA_PYdr_B02','iKCa_PYdr_B02',...
    };

% Note that the soma mechanisms are somewhat sensitive to initial conditions
specification.populations(2).name='PYso';
specification.populations(2).size=round(numCellsScaledown*20);
specification.populations(2).equations=eqns_soma;
specification.populations(2).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_PYso_B02',...
    'iK_PYso_B02',...
    'iNaP_PYso_B02',...
    };

specification.connections(1).direction='PYso<-PYdr';
specification.connections(1).mechanism_list={'iCOM_PYso_PYdr_B02'};
specification.connections(2).direction='PYdr<-PYso';
specification.connections(2).mechanism_list={...
    'iCOM_PYdr_PYso_B02',...
    'iAMPA_PYdr_PYso_B02',...
    'iNMDA_PYdr_PYso_B02'};

% IN cells and intercompartmental IN connections:
specification.populations(3).name='INdr';
specification.populations(3).size=round(numCellsScaledown*5);
specification.populations(3).equations=eqns;
specification.populations(3).mechanism_list={...
    'iAppliedCurrent',...
    'iKLeak_INdr_B02',...
    'iLeak_INdr_B02',...
    'iNa_INdr_B02',...
    'iM_INdr_B02',...
    'iHVA_INdr_B02','CaBuffer_INdr_B02','iKCa_INdr_B02',...
    };

% Note that the soma mechanisms are somewhat sensitive to initial conditions
specification.populations(4).name='INso';
specification.populations(4).size=round(numCellsScaledown*5);
specification.populations(4).equations=eqns_soma;
specification.populations(4).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_INso_B02',...
    'iK_INso_B02',...
    };

specification.connections(3).direction='INso<-INdr';
specification.connections(3).mechanism_list={'iCOM_INso_INdr_B02'};
specification.connections(4).direction='INdr<-INso';
specification.connections(4).mechanism_list={'iCOM_INdr_INso_B02'};

% PY<->IN connections/synapses
specification.connections(5).direction='INdr<-PYso';
specification.connections(5).mechanism_list={...
    'iAMPA_INdr_PYso_B02',...
    'iNMDA_INdr_PYso_B02'};

specification.connections(6).direction='PYdr<-INso';
specification.connections(6).mechanism_list={...
    'iGABAA_PYdr_INso_B02'};

% % -------------------------------------------------------------------
% %% 3. Assemble Thalamic Model and Intrathalamic Connections
% % -------------------------------------------------------------------
% specification.populations(5).name='TC';
% specification.populations(5).size=round(numCellsScaledown*1);
% specification.populations(5).equations=eqns;
% specification.populations(5).mechanism_list={...
%     'iAppliedCurrent',...
%     'iNa_TC',...
%     'iK_TC',...
%     'iLeak_TC',...
%     'iKLeak_TC',...
%     'CaBuffer_TC','iT_TC','iH_TC'};
% 
% specification.populations(6).name='TRN';
% specification.populations(6).size=round(numCellsScaledown*1);
% specification.populations(6).equations=eqns;
% specification.populations(6).mechanism_list={...
%     'iAppliedCurrent',...
%     'iNa_TRN',...
%     'iK_TRN',...
%     'iLeak_TRN',...
%     'iKLeak_TRN',...
%     'CaBuffer_TRN','iT_TRN'};
% 
% specification.connections(7).direction='TC<-TRN';
% specification.connections(7).mechanism_list={...
%     'iGABAA_TC_TRN',...
%     'iGABAB_TC_TRN'};
% specification.connections(8).direction='TRN<-TRN';
% specification.connections(8).mechanism_list={'iGABAA_TRN_TRN'};
% specification.connections(9).direction='TRN<-TC';
% specification.connections(9).mechanism_list={'iAMPA_TRN_TC'};

% % -------------------------------------------------------------------
% %% 4. Thalamo-cortical Connections
% % -------------------------------------------------------------------
% specification.connections(10).direction='PYdr<-TC';
% specification.connections(10).mechanism_list={'iAMPAdepr_PYdr_TC'};
% 
% specification.connections(11).direction='INdr<-TC';
% specification.connections(11).mechanism_list={'iAMPAdepr_INdr_TC'};
% 
% specification.connections(12).direction='TC<-PYso';
% specification.connections(12).mechanism_list={'iAMPA_TC_PYso'};
% 
% specification.connections(13).direction='TRN<-PYso';
% specification.connections(13).mechanism_list={'iAMPA_TRN_PYso'};
