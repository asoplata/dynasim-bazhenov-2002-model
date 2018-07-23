function output = newReleaseUpdate(timeSinceSpike, miniFreq, epsilon, N_pre)
%NEWRELEASEUPDATE - Calculate time until next Mini release
%
% This function is how we calculate new values of the state variable
% `newRelease` for the 'Mini'-type synaptic mechanisms in the DynaSim
% implementation of (Bazhenov et al., 2002). This is similar to the original
% code in "currents.cpp" lines 520-524. This needs to be in an external
% function for simplification of the many checks required for this.
%
% - References:
%     - Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of thalamocortical
%         slow-wave sleep oscillations and transitions to activated states. The
%         Journal of Neuroscience. 2002;22: 8691–8704.

% This corresponds to the `S` in the original code, in "currents.cpp" line 521.
S = rand(1,N_pre);
if S < epsilon
    S = epsilon;
end

% Note that, in the original code, the timeDifference, when utilized to
%     calculate the next "newrelease" value, is effectively never less than
%     100. In other words, unless timeSinceSpike is > 100, we DO NOT CARE what
%     value timeDifference is since it won't be used. This is important, since
%     when timeSinceSpike is small or zero, this causes our `output` to be Inf,
%     divided by zero, or astronomically large, which turns our values into
%     NaNs silently, which completely (and silently) breaks the simulation!
timeDifference = timeSinceSpike + (timeSinceSpike < 100).*100;

% The denominator here corresponds to the `SS` in the original code, in
%     "currents.cpp" line 520.
output = -log(S)./((2.0./(1.0+exp(-timeDifference./miniFreq))-1.0)./250.0);

end
