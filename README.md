# DynaSim mechanism files for simulating (Bazhenov et al., 2002)
 DynaSim-compatible mechanism files for simulation of the cortex and thalamus of
 (Bazhenov et al., 2002).

Adding these mechanism files and associated functions into where you keep your
mechanism files for [DynaSim](https://github.com/DynaSim/DynaSim), e.g.
`/your/path/to/dynasim/models`, should enable you to simulate the computational
cortex and thalamus from:

    Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of thalamocortical
    slow-wave sleep oscillations and transitions to activated states. The
    Journal of Neuroscience. 2002;22: 8691–8704.

The original code for the (Bazhenov et al., 2002) model can be found [here at
ModelDB](https://senselab.med.yale.edu/ModelDB/ShowModel.cshtml?model=28189).
Note that this is only intended to reproduce the qualitative behavior of the
"base", not the "extended" model of the paper. That said, there are
experimental adjustment factors in the code that would make modeling the
extended model easy. Also note that this is NOT intended as a bit-perfect
reproduction of the original model, but rather just an open-source, adequate
reproduction of the overall qualitative results.

## Install and Usage
The easiest way to get started with this is:
1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
   including adding it to your MATLAB path.
2. `git clone` or download this code's repo
   (https://github.com/asoplata/dynasim-bazhenov-2002-model) into
   `'/your/path/to/dynasim/models'`, i.e. the `'models'` subdirectory of your
   copy of the DynaSim repo.
3. Start MATLAB, and run the main runscript `runBazhenovModel.m`.

## References
1. Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of thalamocortical
   slow-wave sleep oscillations and transitions to activated states. The Journal
   of Neuroscience. 2002;22: 8691–8704.
