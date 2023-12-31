---
layout: default
title: Minilab 2
---
# Introduction <a id="minilab2_intro"></a>

In the previous minilab we had a look at how varying the extent of the exponential diffusive overshoot region changes the asymptotic period spacing of dipole ($\ell=1$) modes, $\Pi_{\ell=1}$. An even better option for studying CBM is using the individual g-mode oscillation periods of the stars, and study the changes in the morphology of their **period spacing patterns**. Such patterns are constructed by calculating the period differences $\Delta P$ between modes of the same degree $\ell$ and azimuthal order $m$ and consecutive radial orders $n$, and then plotting these differences as a function of the oscillation periods. For a chemically homogeneous, non-rotating star we expect these patterns to be homogenous as

\begin{equation}
  \Delta P \approx P_{2} - P_{1} \approx P_{3} - P_{2} \approx \dots \approx P_{n} - P_{n-1} \approx \frac{\Pi_0}{\sqrt{\ell (\ell +1)}}.
\end{equation}

<div style="align: left; text-align:center;">
    <img src="images/dP_config.jpeg" width="90%" /> 
</div>

As the star evolves on the main-sequence and consumes hydrogen in its core, the chemical profile of the star is no longer homogenous. Instead a chemical gradient is developed as the convective core contracts during the main-sequence evolution, which traps the oscillations and gives rise to dips in the period spacing pattern as demonstrated in the figure below.

<div style="align: left; text-align:center;">
    <img src="images/HRD_X_dP.png" width="900" /> 
    <div class="caption" style="width: 800"> Comparison between the hydrogen mass fraction profiles (b) and period spacing patterns (c) obtained at three different main-sequence evolutionary stages as indicated by the three round symbols on the evolutionary track in panel (a). Credit: May G. Pedersen. </div>
</div>

As internal mixing changes this gradient, it likewise results in changes in the morphology of the period spacing pattern. In this minilab we are going to study these changes to the patterns from exponential diffusive overshooting for a terminal age main-sequence $4\,{\rm M}_\odot$ SPB star. In order to calculate the stellar oscillations, we are going to use the stellar oscillation code `GYRE` which is included as part of the `MESA` installation.

# Aims <a id="minilab2_aims"></a>

**MESA + GYRE aims:** In this `MESA` lab you will learn how to run `GYRE` outside of `MESA`, what additional parameters are needed in your `MESA` `inlist` to generate files needed as input in `GYRE`, and how to construct a `GYRE inlist`. 

**Science aims:** Investigating what effect convective boundary mixing has on period spacing patterns of SPB stars.

# Minilab 2 <a id="minilab2_lab"></a>

**Warning!** These `MESA` labs have been put together with both low time and spatial resolution for the sake of having the models be completed within a sensible timeframe for the summer school. Before any of these steps or result can be used in any type of actual science case, carrying out a convergence study is crucial!
<br>

**Minilab 1 solution:** [download](https://raw.githubusercontent.com/MichielsenM/mesa-summer-school-2023/main/solutions/SPB_minilab1_solutions.zip)<br>
**Minilab 2 solution:** [download](https://raw.githubusercontent.com/MichielsenM/mesa-summer-school-2023/main/solutions/SPB_minilab2_solutions.zip)<br>

**For the TAs:** Additional instructions for plotting period spacing patterns are available at the bottom of the [home page](https://michielsenm.github.io/mesa-summer-school-2023/). We expect you to be in charge of plotting these patterns to avoid having the students spend time on trying to get the provided scripts to work. Should they have extra time available, however, they are more than welcome to try out the scripts themselves as well.<br><br>

The first step of this minilab is making sure that we can run <code>GYRE</code> as a standalone module outside of <code>MESA</code>. In order to be able to do so, we have to set the path to the <code>GYRE</code> directory in your shell-startup file, just like how you had to do so when installing <code>MESA</code>. Depending on your operating system this is likely to either `$HOME/.bashrc` or `$HOME/.zshrc`, but you can also check this using the command:

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
echo $0
</p></div>

The <code>GYRE</code> directory that has to be set is `$MESA_DIR/gyre/gyre`. So as an example, this is what my `$HOME/.zshrc` file looks like when the path to <code>GYRE</code> has been set correctly:


<div class="filetext-title"> .zshrc or .bashrc </div> 
<div class="filetext"><p><pre class="pre-filetext">
export OMP_NUM_THREADS=4

export MESA_DIR=/Users/mped4857/Software/MESA/mesa-r23.05.1

export MESASDK_ROOT=/Applications/mesasdk
source $MESASDK_ROOT/bin/mesasdk_init.sh

export GYRE_DIR=$MESA_DIR/gyre/gyre
</pre></p></div>

Once the path to <code>GYRE</code> has been set, we need to first source our bash shell-startup file

<div class="terminal-title"> Terminal commands - example </div> 
<div class="terminal"><p>
source $HOME/.zshrc
</p></div>

When initially installing `MESA`, the `GYRE` code should also have been compiled automatically. However, if this turns out not to be the case for you (this will become clear once you start trying to run `GYRE`) then you will have to complete the following two steps in your terminal to compile `GYRE` using `make` inside your `GYRE` directory. 

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
cd $GYRE_DIR<br>
make
</p></div>

If the installation went smoothly, then now we should be able to run <code>GYRE</code> outside of <code>MESA</code>!<br>

Let's start by creating a new <code>MESA</code> work directory by copying the one we created for Minilab 1. If you were unable to complete Minilab 1, then you can download the solution from [here](https://raw.githubusercontent.com/MichielsenM/mesa-summer-school-2023/main/solutions/SPB_minilab1_solutions.zip).

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
cp -r SPB_minilab_1 SPB_minilab_2 <br>
cd SPB_minilab_2<br>
./clean && ./mk
</p></div>

Also, delete the current contents of your `LOGS` directory to avoid confusion with previous models from minilab 1.

Before we run <code>GYRE</code> we have to first tell <code>MESA</code> to output profiles in a format that <code>GYRE</code> can read as input. We can do so by modifying the <code>&controls</code> section of <code>inlist_project</code>. These controls are called <a href="https://docs.mesastar.org/en/release-r23.05.1/reference/controls.html#controls-for-output" target="_blank"> controls for output</a> in the <code>MESA</code> documentation.<br>

<task><details>
<summary>Task 1</summary><p>
Add the following asteroseismology inlist parameters to <code>&controls</code>:
<ul>
 <li>Tell <code>MESA</code> to write the pulsation data along with the <code>MESA</code> profiles. </li>
 <li>Set the pulsation data format to <code>GYRE</code>. </li>
</ul>
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The parameters that have to be added are: <code>write_pulse_data_with_profile</code> and <code>pulse_data_format</code>
</p></details></hint>
<br>

<task><details>
<summary>Task 2</summary><p>
Amongst the people at your table, distribute the following values for the overshooting parameter <code>overshoot_f(1)</code> and use that in your <code>inlist_project</code>: 0.01, 0.02, 0.03, and 0.04. Likewise, change your <code>log_directory</code> parameter <code>LOGS/4Msun_#fov</code> to match the new value of the overshooting parameter. Then run <code>MESA</code>.
</p></details></task>

Your <code>inlist_project</code> should now look something like <a href="https://github.com/MichielsenM/mesa-summer-school-2023/blob/main/solutions/Minilab2_intermediate_solutions/inlist_project_task2" target="_blank"> this</a>.
When <code>MESA</code> is done running you should see that you now have additional output files in your `LOGS/4Msun_#fov` directory with a 'GYRE' extension, one for each of your <code>MESA</code> output <code>profile#.data</code> files of the format <code>profile#.data.GYRE</code>. It is these <code>profile#.data.GYRE</code> files that we need to use as input for the <code>GYRE</code> computations, where we use <code>GYRE</code> to calculate the associated theoretical oscillations for our <code>profile#.data</code> model. We note that as an alternative, the `GSM` format is another pulsation data format that is written specifically for `GYRE` and uses an `HDF5-based format` instead of the `plain-text format` that we get by using `'GYRE'` for the `pulse_data_format` parameter in `inlist_project`.  

Just like <code>MESA</code>, <code>GYRE</code> also has an inlist file that we have to either create or modify. Information on how to construct such a file is given on the
<a href="https://gyre.readthedocs.io/en/stable/" target="_blank"> <code>GYRE</code> documentation website</a>. Discussions, bugs and feature requests can be found on the <a href="http://user.astro.wisc.edu/~townsend/gyre-forums/index.php" target="_blank"> <code>GYRE</code> discussion forum</a>. As a starting point, let's create an empty <code>GYRE</code> input file called <code>gyre.in</code> inside our <code>MESA</code> work directory using your favourite text editor.

<div class="terminal-title"> Terminal commands - example </div> 
<div class="terminal"><p>
nano gyre.in
</p></div>

The setup of the different sections (i.e. namelists) that we need to include in <code>gyre.in</code> is the same as for your <code>MESA</code> <code>inlist_project</code> file, i.e. a section starts with <code>&name</code> and ends with <code>/</code>. As a minimum, we want to include the input model specifications (`&model`), which oscillation modes to compute (`&mode`), information on the inner and outer boundary of the model (`&osc`), which numerical solver to use (`&num`), how to scan the frequency region of interest (`&scan`), include an oscillatory weight parameter for the spatial grid (`&grid`), and what to output (`&ad_output` and `&nad_output`). More information on how to set these up is given in the <a href="[https://gyre.readthedocs.io/en/stable/ref-guide/input-files.html]http://user.astro.wisc.edu/~townsend/gyre-forums/index.php)" target="_blank"> Namelist Input Files</a> section on the <code>GYRE</code> documentation website. In addition to the above-mentioned namelist sections, <code>GYRE</code> also requires the physical constants to be defined in `&constants` as well as specifying the rotation setup (`&rot`). We are just going to use the default values for these. 


<div class="filetext-title"> gyre.in </div> 
<div class="filetext"><p><pre class="pre-filetext">
&constants
/

&model
/

&rot
/

&mode
/

&osc
/

&num
/

&scan
/

&grid
/

&ad_output
/

&nad_output
/ 

</pre></p></div>

<task><details>
<summary>Task 3</summary><p>
Create a <code>gyre.in</code> file and include the namelist sections <code>&constants</code>, <code>&model</code>, <code>&rot</code>, <code>&mode</code>, <code>&osc</code>, <code>&num</code>, <code>&scan</code>, <code>&grid</code>, <code>&ad_output</code>, and <code>&nad_output</code> as shown above.
</p></details></task>

Now that we have included the relevant namelist sections for this <code>MESA</code> lab, we will start by telling <code>GYRE</code> which model (`file`) it should use for the computations. When doing so, we also need to tell <code>GYRE</code> that this input model is an evolutionary model read from an external file (`model_type`) that was calculated by <code>MESA</code> (`file_format`). As a start, lets use `profile2.data.GYRE` as an input file.<br>

<task><details>
<summary>Task 4</summary><p>
In the <code>&model</code> namelist section, include the parameters:<br> 
<code>file = './LOGS/4Msun_#fov/profile2.data.GYRE'</code><br> 
<code>model_type = 'EVOL'</code><br> 
<code>file_format = 'MESA'</code>
</p></details></task>

Make sure you use your chosen value of $f_{\rm ov}$ in place of `#`. Other possible options for how to set these parameters as well as which additional parameters you can add to the `&model` section are listed under <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/model-params.html" target="_blank"> Stellar Model Parameters</a>.

Next, lets setup the <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/osc-params.html" target="_blank"> &osc</a> and <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/num-params.html" target="_blank"> &num</a> namelist sections.<br>

<task><details>
<summary>Task 5</summary><p>
In the <code>&osc</code> namelist section set the outer boundary parameter <code>outer_bound = 'VACUUM'</code> and the inner boundary parameter <code>inner_bound = 'REGULAR'</code>. These determine the outer and inner boundary conditions of the model when calculating the oscillations. In <code>&num</code> tell <code>GYRE</code> to use the 4th-order Gauss-Legendre Magnus solver for initial-value integrations <code>'MAGNUS_GL4'</code> using the <code>diff_scheme</code> parameter.
</p></details></task>

Once we have our numerics and model specifications, we now want to tell <code>GYRE</code> which oscillations to compute. We will do so using the two namelist sections <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/mode-params.html" target="_blank"> &mode</a> and <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/scan-params.html" target="_blank"> &scan</a>. For this <code>MESA</code> lab we will focus on dipole prograde ($\ell =1, m=1$) modes with radial orders between $-1$ and $-80$. Note that by convention, we use negative radial orders for g-modes and positive radial orders for p-modes. In principle, it doesn't matter what we are setting $m$ to be as long as we are fulfilling $m = -\ell, \dots, \ell$. This is because we are currently not including rotation in our <code>GYRE</code> computations, so all of the $m = -\ell, \dots, \ell$ modes for the same $\ell$ and $n$ value would have the same frequency. To include rotation, we would have to include additional parameters in the <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/rot-params.html" target="_blank"> &rot</a> namelist section  in our <code>GYRE</code> inlist file as rotation is turned off by default. You will see more on this during the <code>MESA</code> lab sessions on Thursday. For now, we stick to using ($\ell =1, m=1$) as these are the modes most commonly detected in SPB stars.<br>

<task><details>
<summary>Task 6</summary><p>
In the <code>&mode</code> namelist section, include the parameters:<br> 
<code>l = 1</code><br> 
<code>m = 1</code><br> 
<code>n_pg_min = -80</code><br> 
<code>n_pg_max = -1</code>
</p></details></task>

The relevant frequency range to consider for g-modes in SPB stars is between $0.05 {\rm d}^{-1}$0.05d<sup>-1</sup> and $5 {\rm d}^{-1}$ 5d<sup>-1</sup>. We will tell <code>GYRE</code> to split this range into 400 bins that are equally spaced in period rather than frequency. This is because the g-modes are approximately equally spaced in period contrary to p-modes that are equally spaced in frequency. Finally, we want the oscillation frequencies to be calculated in the inertial (i.e. observer) frame of reference. For recommendations on how to set up your <a href="https://gyre.readthedocs.io/en/stable/user-guide/understanding-grids/frequency-grids.html" target="_blank"> Frequency Grid</a> you can check out the <a href="https://gyre.readthedocs.io/en/stable/user-guide/understanding-grids.html" target="_blank"> Understanding Grids</a> section on the <code>GYRE</code> documentation website.<br>

<task><details>
<summary>Task 7</summary><p>
In the <code>&scan</code> namelist section, include the parameters:<br> 
<code>grid_type = 'INVERSE'</code><br> 
<code>freq_frame = 'INERTIAL'</code><br> 
<code>freq_min = 0.05</code><br> 
<code>freq_max = 5</code><br> 
<code>freq_min_units = 'CYC_PER_DAY'</code><br> 
<code>freq_max_units = 'CYC_PER_DAY'</code><br> 
<code>n_freq = 400</code>
</p></details></task>

When computing the oscillations we want to make sure that we have a high resolution in the spatial grid where large variations in the displacement perturbation $\xi$ are occurring. We do so by adding three additional parameters to <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/grid-params.html" target="_blank"> &grid</a> which are described in detail in <a href="https://gyre.readthedocs.io/en/stable/user-guide/understanding-grids/spatial-grids.html#spatial-grids" target="_blank"> Spatial Grids</a> section on the <code>GYRE</code> documentation website.<br>

<task><details>
<summary>Task 8</summary><p>
In the <code>&grid</code> namelist section, include the parameters:<br> 
<code>w_osc = 10</code><br> 
<code>w_exp = 2</code><br> 
<code>w_ctr = 10</code>
</p></details></task>

Now our last step is to tell <code>GYRE</code> what to output using <a href="https://gyre.readthedocs.io/en/stable/ref-guide/input-files/output-params.html" target="_blank"> &ad_output</a>. There are two types of output files to consider: the <a href="https://gyre.readthedocs.io/en/stable/ref-guide/output-files/summary-files.html#summary-files" target="_blank"> summary</a> and <a href="https://gyre.readthedocs.io/en/stable/ref-guide/output-files/detail-files.html" target="_blank"> detail</a> output files. The `summary` file provides an overview of the <code>GYRE</code> calculations for all considered modes, such as their frequencies, degree $\ell$, and azimuthal order $m$ values, whereas the `detail` files provide additional information on each one of the calculated modes such as their radial ($\xi_r$) and horizontal ($\xi_h$) displacements as a function of the radius coordinate. You, therefore, get one detail file per calculated mode. In this <code>MESA</code> lab, we are only interested in the `summary` files.<br>

<task><details>
<summary>Task 9</summary><p>
In the <code>&ad_output</code> namelist section, include the parameters:<br> 
<code>summary_file = './LOGS/4Msun_#fov/profile2_summary.txt'</code><br>
<code>summary_file_format = 'TXT'</code><br>
<code>summary_item_list = 'l,m,n_p,n_g,n_pg,freq'</code><br> 
<code>freq_units = 'CYC_PER_DAY'</code>
</p></details></task>

Did you notice that we will only be asking <code>GYRE</code> to output the adiabatic solutions (`&ad_output`) to the oscillation equations? We choose to do so here for a couple of reasons. The first and most important one is because it is faster and for this <code>MESA</code> lab, we are not going to look into which modes are excited which would require us to find the non-adiabatic solutions (`&nad_output`). The second reason is that we generally observe more modes than what are predicted to be excited by the standard opacity tables in <code>MESA</code>. We note that changing from adiabatic to nonadiabatic calculations will not result in any significant changes to the output oscillation frequencies, but is required in order to determine which modes are predicted to be excited.

If you have done everything correctly, then your <code>gyre.in</code> file should now look something like this


<div class="filetext-title"> gyre.in </div> 
<div class="filetext"><p><pre class="pre-filetext">
&constants
/

&model
  file = './LOGS/4Msun_0.01fov/profile2.data.GYRE'
  model_type = 'EVOL'
  file_format = 'MESA'
/

&rot
/

&mode
  l = 1
  m = 1
  n_pg_min = -80
  n_pg_max = -1
/

&osc
  outer_bound = 'VACUUM'
  inner_bound = 'REGULAR'
/

&num
  diff_scheme = 'MAGNUS_GL4'
/

&scan
  grid_type = 'INVERSE'
  freq_frame = 'INERTIAL'
  freq_min = 0.05
  freq_max = 5
  freq_min_units = 'CYC_PER_DAY'
  freq_max_units = 'CYC_PER_DAY'
  n_freq = 400
/

&grid
  w_osc = 10
  w_exp = 2
  w_ctr = 10
/

&ad_output
  summary_file = './LOGS/4Msun_0.01fov/profile2_summary.txt'
  summary_file_format = 'TXT'
  summary_item_list = 'l,m,n_p,n_g,n_pg,freq'
  freq_units = 'CYC_PER_DAY'
/

&nad_output
/  

</pre></p></div>

With our <code>gyre.in</code> file now setup and ready we can now run <code>GYRE</code>!

<div class="terminal-title"> Terminal command for running `GYRE` </div> 
<div class="terminal"><p>
$GYRE_DIR/bin/gyre gyre.in
</p></div>

If everything is running correctly, then this should give you output of the following format

<div class="terminal-title"> Terminal output from `GYRE` </div> 
<div class="terminal"><p><pre class="pre-terminal">
gyre [7.0]
----------

OpenMP Threads   : 4
Input filename   : gyre.in

Model Init
----------

Reading from MESA file
   File name ./LOGS/4Msun_0.01fov/profile2.data.GYRE
   File version 1.01
   Read 858 points
   No need to add central point

Mode Search
-----------

Mode parameters
   l : 1
   m : 1

Building frequency grid (REAL axis)
   added scan interval :  0.2131E-01 ->  0.2131E+01 (400 points, INVERSE)

Building spatial grid
   Scaffold grid from model
   Refined 275 subinterval(s) in iteration 1
   Refined 439 subinterval(s) in iteration 2
   Refined 488 subinterval(s) in iteration 3
   Refined 277 subinterval(s) in iteration 4
   Refined 202 subinterval(s) in iteration 5
   Refined 0 subinterval(s) in iteration 6
   Final grid has 1 segment(s) and 2539 point(s):
      Segment 1 : x range 0.0000 -> 1.0000 (1 -> 2539)

Starting search (adiabatic)

Evaluating discriminant
  Time elapsed :     1.693 s

Root Solving
   1    1     -80      0     80  0.77886348E-01  0.00000000E+00 0.1922E-13      7
   1    1     -79      0     79  0.78848053E-01  0.00000000E+00 0.3866E-13      7
   1    1     -78      0     78  0.79831095E-01  0.00000000E+00 0.3558E-13      7
   1    1     -77      0     77  0.80867358E-01  0.00000000E+00 0.2188E-13      7
   1    1     -76      0     76  0.81899870E-01  0.00000000E+00 0.3835E-13      7
   .    .      .       .      .         .               .           .           .
   .    .      .       .      .         .               .           .           .
   .    .      .       .      .         .               .           .           .
   .    .      .       .      .         .               .           .           .
   1    1      -5      0      5  0.10925157E+01  0.00000000E+00 0.2445E-13     10
   1    1      -4      0      4  0.13210318E+01  0.00000000E+00 0.2485E-14      9
   1    1      -3      0      3  0.17990437E+01  0.00000000E+00 0.2877E-13     12
  Time elapsed :      9.340 s   

</pre></p></div>


Notice that at the very beginning, <code>GYRE</code> is telling us that we are using <code>GYRE</code> version 7.0. Just like <code>MESA</code>, <code>GYRE</code> namelist parameters and sections can change between <code>GYRE</code> versions. Make sure you are always referring to the <code>GYRE</code> documentation for the <code>GYRE</code> version that you are using.

Currently, the profile file you have been using is likely very different from the one of the other people at your table. This is because they will be at different core hydrogen mass fractions. <br>

<task><details>
<summary>Task 10</summary><p>
Check what value of <code>center_h1</code> your <code>profile2.data</code> file corresponds to. How different is your value to the rest of the people at your table?
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
Look for the value of <code>center_h1</code> in the header at the top of your <code>profile2.data</code> file.
</p></details></hint>

Ideally when you are comparing period spacing patterns you want to make sure that you are comparing them for the same core hydrogen mass fraction $X_{\rm c}$. You can do so by decreasing the <code>MESA</code> time step around a specific value of $X_{\rm c}$ that you are interested in and then tell <code>MESA</code> to save a profile when you get close to this value. This is something you would do inside your `run_star_extras.f90`. For now, we will take a simpler approach, and instead decrease the time step as we approach core hydrogen exhaustion and then save a profile when <code>MESA</code> is terminated. <br>

<task><details>
<summary>Task 11</summary><p>
In your <code>inlist_project</code> file specify under <code>&star_job</code> that <code>MESA</code> has to output a profile when it terminates and name this profile <code>final_profile.data</code>. Under <code>&controls</code>, add the following two parameters: <code>delta_lg_XH_cntr_max = -1</code> and <code>delta_lg_XH_cntr_limit = 0.05</code>. Run <code>MESA</code> again.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The two parameters you have to add in <code>&star_job</code> are: <code>write_profile_when_terminate = .true.</code> and <code>filename_for_profile_when_terminate = 'LOGS/4Msun_#fov/final_profile.data'</code>.
</p></details></hint>

<br>
<task><details>
<summary>Task 12</summary><p>
Modify the two parameters <code>file</code> and <code>summary_file</code> in your <code>gyre.in</code> file to use your new <code>final_profile.data</code> file and rename the output summary file <code>final_summary_#fov.txt</code>. Also set <code>n_freq = 1000</code>. Then rerun <code>GYRE</code>.
</p></details></task>
<br>

Your <code>inlist_project</code> should now look something like <a href="https://github.com/MichielsenM/mesa-summer-school-2023/blob/main/solutions/Minilab2_intermediate_solutions/inlist_project_task12" target="_blank"> this</a> and your <code>gyre.in</code> something like <a href="https://github.com/MichielsenM/mesa-summer-school-2023/blob/main/solutions/Minilab2_intermediate_solutions/gyre.in_task12"> this</a>.
Once you have your `final_summary_#fov.txt` share it with your TA. They have a <code>python</code> script available to plot all of the period spacing patterns together and just need your `final_summary_#fov.txt` file. If you want to have a go at using these scripts to plot it yourself, you can get them from [here](https://raw.githubusercontent.com/MichielsenM/mesa-summer-school-2023/main/solutions/jupyter_notebook.zip). Make sure to check out the `notes.txt` file first or follow the instructions for the TAs at the bottom of the <a href="https://michielsenm.github.io/mesa-summer-school-2023/" target="_blank"> home page</a>.<br> 

<task><details>
<summary>Task 13</summary><p>
Compare the period spacing patterns for the four different overshooting parameters. How are they different/similar?
</p></details></task>
<br>

As an example of what the period spacing patterns might look like we show below the period spacing patterns calculated from the `final_summary_0.01fov.txt` (blue) and `profile2_summary.txt` (orange) `GYRE` output files assuming $f_{\rm ov} = 0.01$.

<div style="align: left; text-align:center;">
    <img src="images/example_patterns.png" width="100%" /> 
</div>
<br>


## Bonus exercise 1: Varying GYRE input parameters <a id="minilab2_bonus1"></a>

Currently, when you run <code>GYRE</code> you should see that all modes have $n_{\rm pg} = -n_{\rm g}$  and all g-modes between $n_{\rm g} = 3$ and $80$ are being output. The exact output will change depending on how you setup your <code>GYRE</code> inlist. For this bonus exercise we are going to investigate what happens when we change the parameters: `freq_min`, `freq_max`, `grid_type`, `n_freq`, and `summary_item_list`.<br>

<task><details>
<summary>Task B1.1</summary><p>
Change your parameter <code>n_freq</code> to 10, 50, 100, 200, 400, and 600. What happens to the number of output frequencies and time it takes for <code>GYRE</code> to finish its calculations? What is the minimum value for <code>n_freq</code> that you need to get all modes from $n_{\rm g} = 5$ to $80$?
</p></details></task>
<br>

<task><details>
<summary>Task B1.2</summary><p>
Play around with the two parameters <code>freq_min</code> and <code>freq_max</code>. What values do you need to use to get the full list of ($\ell, m$) = ($1,1$) from $n_{\rm pg} = -1$ to $-80$?
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
You may need to increase <code>n_freq</code> as well.
</p></details></hint>
<br>

<task><details>
<summary>Task B1.3</summary><p>
Change the parameter <code>grid_type</code> to <code>'LINEAR'</code> then run <code>GYRE</code>. What happens to your output? What value do you need to use for <code>n_freq</code> to get the same output as before?
</p></details></task>
<br>

<task><details>
<summary>Task B1.4</summary><p>
Have a look at the possible 
<a href="https://gyre.readthedocs.io/en/stable/ref-guide/output-files/summary-files.html#summary-files" target="_blank">summary file output</a> on the <code>GYRE</code> documentation website. Find the parameter for the stellar mass as well as the effective temperature perturbation amplitude and phase and included them as output for your <code>GYRE</code> computations. Run <code>GYRE</code> to make sure everything works.
</p></details></task>
<br>

Now before moving on to the next exercises, make sure you reset the parameters in your <code>gyre.in</code> file to the initial ones, i.e.<br>

<code>freq_min = 0.05</code><br>
<code>freq_max = 5.0</code><br>
<code>n_freq = 1000</code><br>
<code>grid_type = 'INVERSE'</code><br>
<code>summary_item_list = 'l,m,n_p,n_g,n_pg,freq'</code>

## Bonus exercise 2: Resolution impact on period spacing patterns <a id="minilab2_bonus2"></a>

So far, aside from additional time step resolution near the end of the main-sequence evolution, we have been using the default mesh grid and time step resolution in <code>MESA</code>. The period spacing patterns are very sensitive to the profile of the Brunt-Vaisala frequency, as it determines where the g-modes can propagate and how they get trapped near the core as a chemical gradient is developed when the convective core contracts. Therefore, if we want to model them we have to make sure that the Brunt-Vaisala frequency profile is converged. Remember that when using <code>MESA</code> for any type of science, **it is always important to test if your models are converged!**

For this bonus exercise, we are going to play around with the two parameters `mesh_delta_coeff` and `time_delta_coeff` and see how they change the Brunt-Vaisala frequency profile.<br>

<task><details>
<summary>Task B2.1</summary><p>
Copy <code>profile_columns.list</code> from <code>$MESA_DIR/star/defaults/</code> to your <code>SPB_minilab_2</code> work directory. Make sure that <code>brunt_N2</code>, <code>brunt_N2_structure_term</code>, and <code>brunt_N2_composition_term</code> are included as output.
</p></details></task>
<br>

<task><details>
<summary>Task B2.2</summary><p>
Add the following to <code>inlist_pgstar</code>:<br> 
<code>Profile_Panels1_win_flag = .true.</code><br> 
<code>Profile_Panels1_num_panels = 2</code><br> 
<code>Profile_Panels1_yaxis_name(1) = 'brunt_N2'</code><br>
<code>Profile_Panels1_other_yaxis_name(1) = ''</code><br>
<code>Profile_Panels1_yaxis_name(2) = 'brunt_N2_structure_term'</code><br>
<code>Profile_Panels1_other_yaxis_name(2) = 'brunt_N2_composition_term'</code><br> 
<code>Profile_Panels1_file_flag = .true.</code><br> 
<code>Profile_Panels1_file_dir = 'png'</code><br>
<code>Profile_Panels1_file_prefix = 'profile_panels1_1.0mdc_1.0tdc_'</code><br>
<code>Profile_Panels1_file_width = 12</code><br>
<code>Profile_Panels1_file_aspect_ratio = 0.75</code>
</p></details></task>
<br>

This will save the `pgstar` window showing the `Profile_Panels1` plot to the png directory. We will need those for comparisons later. An example of what this `pgstar` window looks like is shown below.<br>

<div style="align: left; text-align:center;">
    <img src="images/profile_panels1_1.0mdc_1.0tdc_000250.png" width="100%" /> 
</div>
<br>

<task><details>
<summary>Task B2.3</summary><p>
Include the two parameters <code>mesh_delta_coeff = 1.0</code> and <code>time_delta_coeff = 1.0</code> in your <code>inlist_project</code> under <code>&controls</code>. Change your output LOGS directory to <code>log_directory = 'LOGS/4Msun_#fov_1.0mdc_1.0tdc'</code>. Likewise make sure to change <code>filename_for_profile_when_terminate = 'LOGS/4Msun_#fov_1.0mdc_1.0tdc/final_profile.data'</code>. Then run <code>MESA</code>.
</p></details></task>
<br>

Take note of the output to the png directory. Is the Brunt-Vaisala frequency profile looking smooth?<br>

<task><details>
<summary>Task B2.4</summary><p>
Now change the <code>mesh_delta_coeff</code> and <code>time_delta_coeff</code> parameters to match the combinations listed in the table below. Remember to also change <code>log_directory</code>, <code>filename_for_profile_when_terminate</code>, and <code>Profile_Panels1_file_prefix</code> accordingly to not overwrite your previous saved files. Then rerun <code>MESA</code> and look at how your saved profile plots of the Brunt-Vaisala frequency profile compare to each other. Do they change as you change the mesh and time resolution? If so, in what way?

 <table>
  <tr>
    <th><code>mesh_delta_coeff</code> (mdc)</th>
    <th><code>time_delta_coeff</code> (tdc)</th>
  </tr>
  <tr>
    <td>1.0</td>
    <td>1.0</td>
  </tr>
  <tr>
    <td>1.0</td>
    <td>0.5</td>
  </tr>    
  <tr>
    <td>0.5</td>
    <td>1.0</td>
  </tr>
  <tr>
    <td>0.5</td>
    <td>0.5</td>
  </tr>
</table>
<br>

If you also run <code>GYRE</code> for each one of these configurations, you can check how the period spacing patterns are changing as well.

</p></details></task>
