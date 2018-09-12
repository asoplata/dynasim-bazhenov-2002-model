%{
# Simulation Runscript file

- Project 25:
    - Thalamocortical modeling of anesthesia for the MIT-BU P01 grantj, focused
    on SWO and propofol modeling
- Direction 5:
    - Explore SWO etc. in cortex-only (Bazhenov, 2002) model with and without
    propofol
- Question 1:
    - What happens when we take a cort SWO model and incr the tauGABAA
- Computational model 1:
    - Using the "dynasim-bazhenov-2002-model" model/mechanism code with
    "assembleSpecCortexOnly"
- Iteration 1:
    - meh
- References:
    - Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of thalamocortical
    slow-wave sleep oscillations and transitions to activated states. The
    Journal of Neuroscience. 2002;22: 8691–8704.

- Note: for full explanation of what each part of these parameters and functions
do, see the runscript in the GitHub repo for this model at:

    https://github.com/asoplata/dynasim-bazhenov-2002-model
    
Author: Austin E. Soplata <austin.soplata@gmail.com>
Copyright (C) 2018 Austin E. Soplata, Boston University, USA
%}

% -------------------------------------------------------------------
%% 0. Debug
% -------------------------------------------------------------------
debug = 0; % Only use 1 if cleaning
if debug == 1
    clf
    close all
    % % Note: the below may be dangerous!
    % if 7==exist(study_dir, 'dir')
    %     rmdir(study_dir, 's')
    % end
end

% -------------------------------------------------------------------
%% 1. Define simulation parameters
% -------------------------------------------------------------------
study_dir = mfilename;

time_end = 5000; % in milliseconds

% Needs to be set explicitly
dt = 0.01; % in milliseconds

% 1   = full size
% 0.2 = 20PY-5IN
numCellsScaledownFactor = 0.2;

vary={
% '(PYdr<-PYso,INdr<-PYso)', 'fac_AMPA_cort_large_vary', [-0.2,-0.1, 0, 0.1, 0.2];
% '(PYdr,INdr)','fac_KLeak_cort_large_vary',[-0.2,-0.1, 0, 0.1, 0.2];
%     'PYdr<-INso', 'propofolTauMult', [1, 2.5];
};

mex_flag =       0;
overwrite_flag = 1;
parfor_flag =    0;
% random_seed =    'shuffle';
% known good seeds: set equal to 1
random_seed =    1;
% random_seed =    11111;
% random_seed =    'shuffle';
save_data_flag = 0;
save_results_flag = 1;
verbose_flag =   1;
disk_flag = 0;

cluster_matlab_version = '2017b';
cluster_flag =   0;
if cluster_flag == 1
    memory_limit =   '254G';
    % Don't use >1 unless parfor_flag set, since no parfor_flag => -singleCompThread
    num_cores =      28;
else
    % probaly using qrsh or local machine
    memory_limit =   '8G';
    num_cores =      1;
    % num_cores =      2;
    % num_cores =      4;
end

% 2.5 = +150% of baseline
propofolDecayMultiplier = 1;
% 1 = baseline, no change
propofolCondMultiplier = 1;

% -------------------------------------------------------------------
%% 2. Assemble and customize the model
% -------------------------------------------------------------------
spec = assembleSpecReproducibleSWO(dt, numCellsScaledownFactor);

% % options: 'Awake', 'N2', 'N3', and 'REM'
% spec = applyExperimentFactors(spec, 'N3');

% spec = applyPropofol(spec, propofolDecayMultiplier, propofolCondMultiplier);

% % Remove all IC noise
% spec = removeNoiseIC(spec);

%% Set ICs
stimSO = 0;
stimDR = 0;
modifications = {...
    'PYdr<-PYso', 'laMiniIC',     -10000;
    'INdr<-PYso', 'laMiniIC',     -10000;
    'PYdr<-INso', 'laMiniIC',     -10000;

    'PYdr<-PYso', 'gMiniAMPA', 0.363636;
    'INdr<-PYso', 'gMiniAMPA', 0.5;
    'PYdr<-INso', 'gMiniGABAA', 0.3;
    % 'PYdr<-INso', 'gMiniGABAA', 0.3/10;

    'PYdr<-PYso', 'gAMPA', 0.9;
    'INdr<-PYso', 'gAMPA', 1.0;
    'PYdr<-INso', 'gGABAA', 0.3;

    'PYdr<-INso', 'sGABAAIC', 0;
    'PYdr<-INso', 'sGABAANoiseIC', 0;
    'PYdr<-INso', 'deprGABAAIC', 1;
    'PYdr<-INso', 'deprGABAANoiseIC', 0;

    'PYdr<-PYso', 'sAMPAIC', 0;
    'PYdr<-PYso', 'sAMPANoiseIC', 0;
    'PYdr<-PYso', 'deprAMPAIC', 1;
    'PYdr<-PYso', 'deprAMPANoiseIC', 0;

    'INdr<-PYso', 'sAMPAIC', 0;
    'INdr<-PYso', 'sAMPANoiseIC', 0;
    'INdr<-PYso', 'deprAMPAIC', 1;
    'INdr<-PYso', 'deprAMPANoiseIC', 0;

    % 'PYdr<-PYso', 'gNMDA', 0.06;
    % 'INdr<-PYso', 'gNMDA', 0.16;
    % 'PYdr<-PYso', 'gNMDA', 0;
    % 'INdr<-PYso', 'gNMDA', 0;

    'PYdr', 'appliedStim', stimDR;
    'PYdr', 'mNaIC', 0.012;
    'PYdr', 'mNaNoiseIC', 0;
    'PYdr', 'hNaIC', 0.89;
    'PYdr', 'hNaNoiseIC', 0;
    'PYdr', 'mNaPIC', 0.0001;
    'PYdr', 'mNaPNoiseIC', 0;
    'PYdr', 'mHVAIC', 7.5e-5;
    'PYdr', 'mHVANoiseIC', 0;
    'PYdr', 'hHVAIC', 0.617;
    'PYdr', 'hHVANoiseIC', 0;
    'PYdr', 'mKCaIC', 5e-5;
    'PYdr', 'mKCaNoiseIC', 0;
    'PYdr', 'mMIC', 0.0145;
    'PYdr', 'mMNoiseIC', 0;
    'PYdr', 'CaBufferIC', 0.0001;
    'PYdr', 'CaBufferNoiseIC', 0;

    'PYso', 'appliedStim', stimSO;
    'PYso', 'mNaIC', 0.012;
    'PYso', 'mNaNoiseIC', 0;
    'PYso', 'hNaIC', 0.89;
    'PYso', 'hNaNoiseIC', 0;
    'PYso', 'mNaPIC', 0.0001;
    'PYso', 'mNaPNoiseIC', 0;
    'PYso', 'nKIC', 0.0003;
    'PYso', 'nKNoiseIC', 0;

    'INdr', 'appliedStim', stimDR;
    'INdr', 'mNaIC', 0.012;
    'INdr', 'mNaNoiseIC', 0;
    'INdr', 'hNaIC', 0.89;
    'INdr', 'hNaNoiseIC', 0;
    'INdr', 'mNaPIC', 0.0001;
    'INdr', 'mNaPNoiseIC', 0;
    'INdr', 'mHVAIC', 7.5e-5;
    'INdr', 'mHVANoiseIC', 0;
    'INdr', 'hHVAIC', 0.617;
    'INdr', 'hHVANoiseIC', 0;
    'INdr', 'mKCaIC', 5e-5;
    'INdr', 'mKCaNoiseIC', 0;
    'PYdr', 'mMIC', 0.0145;
    'PYdr', 'mMNoiseIC', 0;
    'INdr', 'CaBufferIC', 0.0001;
    'INdr', 'CaBufferNoiseIC', 0;

    'INso', 'appliedStim', stimSO;
    'INso', 'mNaIC', 0.012;
    'INso', 'mNaNoiseIC', 0;
    'INso', 'hNaIC', 0.89;
    'INso', 'hNaNoiseIC', 0;
    'INso', 'nKIC', 0.0003;
    'INso', 'nKNoiseIC', 0;
};
spec = dsApplyModifications(spec, modifications);

% -------------------------------------------------------------------
%% 3. Run the simulation
% -------------------------------------------------------------------
data = dsSimulate(spec,...
    'cluster_flag',cluster_flag,'dt',dt,...
    'cluster_matlab_version',cluster_matlab_version,...
    'memory_limit',memory_limit,'mex_flag',mex_flag,'num_cores',num_cores,...
    'overwrite_flag',overwrite_flag,'disk_flag',disk_flag,...
    'parfor_flag',parfor_flag,'random_seed',random_seed,...
    'save_data_flag',save_data_flag,'save_results_flag',save_results_flag,...
    'solver','euler','tspan',[0 time_end],...
    'study_dir',study_dir,'vary',vary,'verbose_flag',verbose_flag,...
    'plot_functions',{@dsPlot},...
    'plot_options',{{'plot_type','waveform','format','png'}});%,...
%                     {'plot_type','rastergram','format','png'},...
%                     {'plot_type','power','format','png','xlim',[0 40]}});
