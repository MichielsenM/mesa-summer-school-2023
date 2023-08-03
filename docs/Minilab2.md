---
layout: default
title: Minilab 2
---
# Minilab 2


The first step of this minilab is making sure that we can run <math>GYRE</math> as a standalone module outside of <math>MESA</math>. In order to be able to do so, we have to set the path to the <math>GYRE</math> directory in your shell-startup file, just like how you had to do so when installing <math>MESA</math>. Depending on your operating system this is likely to either `$HOME/.bashrc` or `$HOME/.zshrc`, but you can also check this using the command:

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
echo $0
</p></div>

The <math>GYRE</math> directory that has to be set is `$MESA_DIR/gyre/gyre`. So as an example, this is what my `$HOME/.zshrc` file looks like when the path to <math>GYRE</math> has been set correctly:


<div class="filetext-title"> .zshrc or .bashrc </div> 
<div class="filetext"><p>
export OMP_NUM_THREADS=4

export MESA_DIR=/Users/mped4857/Software/MESA/mesa-r23.05.1

export MESASDK_ROOT=/Applications/mesasdk
source $MESASDK_ROOT/bin/mesasdk_init.sh

export GYRE_DIR=/Users/mped4857/Software/MESA/mesa-r23.05.1/gyre/gyre
</p></div>


As long as the path to your <math>GYRE</math> directory (<math>GYRE_DIR</math>) is set after the path to your <math>MESA</math> directory (<math>MESA_DIR</math>), you can also just add `export GYRE_DIR=$MESA_DIR/gyre/gyre` to your shell-startup file.

Once the path to <math>GYRE</math> has been set, we need to first source our bash shell-startup file

<div class="terminal-title"> Terminal commands - example </div> 
<div class="terminal"><p>
source $HOME/.zshrc
</p></div>

Then the next step is to compile <math>GYRE</math>. To do so, we have to go to the <math>GYRE</math> directory and use the <math>make</math> command:

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
cd $GYRE_DIR
make
</p></div>

If the installation went smoothly, then now we should be able to run <math>GYRE</math> outside of <math>MESA</math>!<br>

Let's start by creating a new <math>MESA</math> work directory by copying the one we created for Minilab 1. If you were unable to complete Minilab 1, then you can download the solution from here **(include link with solution)**.  <!-- TODO -->

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
cp -r SPB_minilab_1 SPB_minilab_2
cd SPB_minilab_2
</p></div>


Before we run <math>GYRE</math> we have to first tell <math>MESA</math> to output profiles in a format that <math>GYRE</math> can read as input. We can do so by modifying the <math>&controls</math> section of <math>inlist_project</math>. These controls are called [controls for output](https://docs.mesastar.org/en/release-r23.05.1/reference/controls.html#controls-for-output) in the <math>MESA</math> documentation.<br>

<task><details>
<summary>Task 1</summary><p>
Add the following asteroseismology inlist parameters to <math>&controls</math>:
<ul>
 <li>Tell <math>MESA</math> to write the pulsation data along with the <math>MESA</math> profiles. </li>
 <li>Set the pulsation data format to <math>GYRE</math>. </li>
</ul>
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The parameters that have to be added are: `write_pulse_data_with_profile = .true.` and `pulse_data_format = 'GYRE'`
</p></details></hint>


<task><details>
<summary>Task 2</summary><p>
Amongst the people at your table, distribute the following values for the overshooting parameter `overshoot_f(1)` and use that in your <math>inlist_project</math>: 0.01, 0.02, 0.03, and 0.04. Likewise change your `log_directory` parameter `LOGS/4Msun_#fov` to match the new value of the overshooting parameter. Then run <math>MESA</math>.
</p></details></task>

When <math>MESA</math> is done running you should see that you now have additional output files in your LOGS directory with a `GYRE' extension, one for each of your <math>MESA</math> output <math>profile#.data</math> files of the format <math>profile#.data.GYRE</math>. It is these <math>profile#.data.GYRE</math> files that we need to use as input for the <math>GYRE</math> computations, where we use <math>GYRE</math> to calculate the associated theoretical oscillations for our <math>profile#.data</math> model. 

Just like <math>MESA</math>, <math>GYRE</math> also has an inlist file that we have to either create or modify. Information on how to construct such a file is given on the
[<math>GYRE</math> documentation website](https://gyre.readthedocs.io/en/stable/). As a starting point, lets create an empty <math>GYRE</math> input file called <math>gyre.in</math> inside our <math>MESA</math> work directory using your favourite text editor.

<div class="terminal-title"> Terminal commands - example </div> 
<div class="terminal"><p>
nano gyre.in
</p></div>

The setup of the different sections (i.e. namelists) that we need to include in <math>gyre.in</math> is the same as for your <math>MESA</math> <math>inlist_project</math> file, i.e. a section starts with <math>&name</math> and ends with <math>/</math>. As a minimum, we want to include the input model specifications (`&model`), which oscillation modes to compute (`&mode`), information on the inner and outer boundary of the model (`&osc`), which numerical solver to use (`&num`), how to scan the frequency region of interest (`&scan`), include an oscillatory weight parameter for the spatial grid (`&grid`), and what to output (`&ad_output` and `&nad_output`). More information on how to set these up are given in the [Namelist Input Files](https://gyre.readthedocs.io/en/stable/ref-guide/input-files.html) section on the <math>GYRE</math> documentation website. In addition to the above mentioned namelist sections, <math>GYRE</math> also requires the physical constants to be defined in `&constants` as well as specifying the rotation setup (`&rot`). We are just going to use the default values for these. 


<div class="filetext-title"> gyre.in </div> 
<div class="filetext"><p><pre class="pre-filetext">
&constants
    (some specification)
/

&model
    (some specification)
/

&rot
    (some specification)
/

&mode
    (some specification)
/

&osc
    (some specification)
/

&num
    (some specification)
/

&scan
    (some specification)
/

&grid
    (some specification)
/

&ad_output
    (some specification)
/

&nad_output
    (some specification)
/
</pre></p></div>

<task><details>
<summary>Task 3</summary><p>
Create a <math>gyre.in</math> file and include the namelist sections `&constants`, `&model`, `&rot`, `&mode`, `&osc`, `&num`, `&scan`, `&grid`,  `&ad_output`, and `&nad_output` as shown above.
</p></details></task>

Now that we have included the relevant namelist sections for this <math>MESA</math> lab, we will start by telling <math>GYRE</math> which model (`file`) it should use for the computations. When doing so, we also need to tell <math>GYRE</math> that this input model is an evolutionary model read from an external file (`model_type`) that was calculated by <math>MESA</math> (`file_format`). As a start, lets use `profile2.data.GYRE` as an input file.<br>

<task><details>
<summary>Task 4</summary><p>
In the `&model` namelist section, include the parameters:<br> `file = './LOGS/4Msun_#fov/profile2.data.GYRE'`<br> `model_type = 'EVOL'`<br> `file_format = 'MESA'`
</p></details></task>

Make sure you use your chosen value of _f_<sub>ov</sub> in place of #. Other possible options for how to set these parameters as well as which additional parameters you can add to the `&model` section are listed under [Stellar Model Parameters](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/model-params.html).

Next, lets setup the [&osc](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/osc-params.html) and [&num](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/num-params.html) namelist sections.<br>

<task><details>
<summary>Task 5</summary><p>
In the `&osc` namelist section set the outer boundary parameter `outer_bound` to `'VACUUM'` and the inner boundary parameter `inner_bound` to `'REGULAR'`. These determine the outer and inner boundary conditions of the model when calculating the oscillations. In `&num` tell <math>GYRE</math> to use the 4th-order Gauss-Legendre Magnus solver for initial-value integrations `'MAGNUS_GL4'` using the `diff_scheme` parameter.
</p></details></task>

Once we have our numerics and model specifications, we now want to tell <math>GYRE</math> which oscillations to compute. We will do so using the two namelist sections [&mode](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/mode-params.html) and [&scan](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/scan-params.html). For this <math>MESA</math> lab we will focus on dipole prograde (&#8467;=1, _m_=1) modes with radial orders between -1 and -80. Note that by convention, we use negative radial orders for g-modes and positive radial orders for p-modes. In principle, it doesn't matter what we are setting _m_ to be as long as we are fulfilling _m_ = -&#8467;, ..., &#8467;. This is because we are currently not including rotation in our <math>GYRE</math> computations, so all of the _m_ = -&#8467;, ..., &#8467; modes for the same &#8467; and _n_ value would have the same frequency. To include rotation, we would have to include another namelist section in our <math>GYRE</math> inlist file called [&rot](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/rot-params.html). You will see more on this during the <math>MESA</math> lab sessions on Thursday.<br>

<task><details>
<summary>Task 6</summary><p>
In the `&mode` namelist section, include the parameters:<br> `l = 1`<br> `m = 1`<br> `n_pg_min = -80`<br> `n_pg_max = -1`.
</p></details></task>

The relevant frequency range to consider of g-modes in SPB stars is between 0.05d<sup>-1</sup> and 5d<sup>-1</sup>. We will tell <math>GYRE</math> to split this range into 400 bins that are equally spaced in period rather than frequency. This is because the g-modes are equally spaced in period contrary to p-modes that are equally spaced in frequency. Finally, we want the oscillation frequencies to be calculated in the inertial (i.e. observer) frame of reference. For recommendations on how to set up your [Frequency Grid](https://gyre.readthedocs.io/en/stable/user-guide/understanding-grids/frequency-grids.html#frequency-units) you can check out the [Understanding Grids](https://gyre.readthedocs.io/en/stable/user-guide/understanding-grids.html) section on the <math>GYRE</math> documentation website.<br>

<task><details>
<summary>Task 7</summary><p>
In the `&scan` namelist section, include the parameters:<br> `grid_type = 'INVERSE'`<br> `freq_frame = 'INERTIAL'`<br> `freq_min = 0.05`<br> `freq_max = 5`<br> `freq_min_units = 'CYC_PER_DAY'`<br> `freq_max_units = 'CYC_PER_DAY'`<br> `n_freq = 400`
</p></details></task>

When computing the oscillations we want to make sure that we have a high resolution in the spatial grid where large variations in &xi are occurring. We do so by adding three additional parameters to [&grid](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/grid-params.html) which are described in detail in [Spatial Grids](https://gyre.readthedocs.io/en/stable/user-guide/understanding-grids/spatial-grids.html#spatial-grids) section on the <math>GYRE</math> documentation website.<br>

<task><details>
<summary>Task 8</summary><p>
In the `&grid` namelist section, include the parameters:<br> `w_osc = 10`<br> `w_exp = 2`<br> `w_ctr = 10`.
</p></details></task>

Now our last step is to tell <math>GYRE</math> what to output using [&ad_output](https://gyre.readthedocs.io/en/stable/ref-guide/input-files/output-params.html). There are two types of output files to consider: the [summary](https://gyre.readthedocs.io/en/stable/ref-guide/output-files/summary-files.html#summary-files) and [detail](https://gyre.readthedocs.io/en/stable/ref-guide/output-files/detail-files.html) output files. The `summary` files provides an overview of the <math>GYRE</math> calculations for all considered modes, such as their frequencies, &#8467;, and _m_ values, whereas the `detail` files provides additional information on each one of the calculated modes such as their radial (&xi<sup>r</sup>) and horizontal (&xi<sup>h</sup>) displacements as a function of the radius coordinate. You therefore get one detail file per calculated mode. In this <math>MESA</math> lab, we are only interested in the `summary` files.<br>

<task><details>
<summary>Task 8</summary><p>
In the `&ad_output` namelist section, include the parameters:<br> `summary_file = './LOGS/4Msun_#fov/profile2_summary.txt'`<br>
`summary_file_format = 'TXT'`<br>
`summary_item_list = 'l,m,n_p,n_g,n_pg,freq'`<br> `freq_units = 'CYC_PER_DAY'`
</p></details></task>

Did you notice that we will only be asking <math>GYRE</math> to output the adiabatic solutions (`&ad_output`) to the oscillation equations? We choose to do so here for a couple of reasons. The first and most important one is because it is faster and for this <math>MESA</math> lab, we are not going to look into which modes are excited which would require us to find the non-adiabatic solutions (`&nad_output`). The second reason is that we generally observe more modes that what are predicted to be excited by the standard opacity tables in <math>MESA</math>. We note that changing from adiabatic to nonadiabatic calculations will not result in any significant changes to the output oscillation frequencies, but is required in order to determine which modes are predicted to be excited.

If you have done everything correctly, then your <math>gyre.in</math> file should now look something like this


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

With our <math>gyre.in</math> file now setup and ready we can now run <math>GYRE</math>!

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
$GYRE_DIR/bin/gyre gyre.in
</p></div>

If everything is running correctly, then this should give you output of the following format

<div class="terminal-title"> Terminal output </div> 
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
   l    m    n_pg    n_p    n_g       Re(omega)       Im(omega)        chi n_iter
   1    1     -80      0     80  0.77885037E-01  0.00000000E+00 0.6524E-14      7
   1    1     -79      0     79  0.78762922E-01  0.00000000E+00 0.4145E-13      7
   1    1     -78      0     78  0.79774829E-01  0.00000000E+00 0.5551E-14      7
   1    1     -77      0     77  0.80869740E-01  0.00000000E+00 0.2632E-13      7
   1    1     -76      0     76  0.81796757E-01  0.00000000E+00 0.2658E-14      7
   .    .      .       .      .         .               .           .           .
   .    .      .       .      .         .               .           .           .
   .    .      .       .      .         .               .           .           .
   .    .      .       .      .         .               .           .           .
   1    1      -5      0      5  0.10864651E+01  0.00000000E+00 0.1134E-14      7
   1    1      -4      0      4  0.13209126E+01  0.00000000E+00 0.2525E-14     12
   1    1      -3      0      3  0.18009122E+01  0.00000000E+00 0.3137E-13     12
  Time elapsed :      9.340 s   

</pre></p></div>


Notice that at the very beginning, <math>GYRE</math> is telling us that we are using <math>GYRE</math> version 7.0. Just like <math>MESA</math>, <math>GYRE</math> namelist parameters and sections can change between <math>GYRE</math> versions. Make sure you are always referring to the <math>GYRE</math> documentation for the <math>GYRE</math> version that you are using.

Currently, the profile file you have been using is likely very different from the one of other people at your table. This is because they will be at different core hydrogen mass fractions. <br>

<task><details>
<summary>Task 10</summary><p>
Check what value of `center_h1` that your `profile2.data` file corresponds to. How different is your value to the rest of the people at your table?
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
Look for the value of `center_h1` in the header at the top of your `profile2.data` file.
</p></details></hint>

Ideally when you are comparing period spacing patterns you want to make sure that you are comparing them for the same core hydrogen mass fraction X<sub>c</sub>. You can do so by decreasing the <math>MESA</math> time step around a specific value of X<sub>c</sub> that you are interested in and then tell <math>MESA</math> to save a profile when you get close to this value. This is something you would do inside your `run_star_extras.f90`. For now we will take a simpler approach, and instead decrease the time step as we approach core hydrogen exhaustion and then save a profile when <math>MESA</math> is terminated. <br>

<task><details>
<summary>Task 11</summary><p>
In your <math>inlist_project</math> file specify under `&star_job` that <math>MESA</math> has to output a profile when it terminates and name this profile `final_profile.data`. Under <math>&controls</math>, add the following two parameters: `delta_lg_XH_cntr_max = -1` and `delta_lg_XH_cntr_limit = 0.05`. Run <math>MESA</math> again.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The two parameters you have to add in `&star_job` are: `write_profile_when_terminate = .true.` and `filename_for_profile_when_terminate = 'LOGS/4Msun_#fov/final_profile.data'`.
</p></details></hint>

<task><details>
<summary>Task 12</summary><p>
Modify the two parameters `file` and `summary_file` in your <math>gyre.in</math> file to use your new `final_profile.data` file and rename the output summary file `final_summary_#fov.txt`. Also set `n_freq = 1000`. Then rerun <math>GYRE</math>.
</p></details></task>

Once you have your `final_summary_#fov.txt` share it with your TA. They have a `python` script available to plot all of the period spacing patterns together and just need your `final_summary_#fov.txt` file. If you want to have a go at using these scripts to plot it yourself, you can get them from [here](https://www.dropbox.com/sh/w53woz0m3l5axbq/AAC05hnNlPx6Hn_-VitieZcda?dl=0). Make sure to check out the `notes.txt` file first.<br> 

<task><details>
<summary>Task 13</summary><p>
Compare the period spacing patterns for the four different overshooting parameters. How are they different/similar?
</p></details></task>

## Bonus exercise 1: Varying <math>GYRE</math> input parameters

Currently, when you run <math>GYRE</math> you should see that all modes have &#x7C; _n_<sub>pg</sub> &#x7C; = _n_<sub>g</sub> and all g-modes between _n_<sub>g</sub> = 3 and 80 are being output. The exact output will change depending on how you setup your <math>GYRE</math> inlist. For this bonus exercise we are going to investigate what happens when we change the parameters: `freq_min`, `freq_max`, `grid_type`, `n_freq`, and `summary_item_list`.<br>

<task><details>
<summary>Task B1.1</summary><p>
Change your parameter `n_freq` to 10, 50, 100, 200, 400, and 600. What happens to the number of output frequencies and time it takes for <math>GYRE</math> to finish its calculations? What is the minimum value for `n_freq` that you need to get all modes from _n_<sub>g</sub> = 9 to 80?
</p></details></task>


<task><details>
<summary>Task B1.2</summary><p>
Play around with the two parameters `freq_min` and `freq_max`. What values do you need to use to get the full list of (&#8467;, _m_) = (1,1) from _n_<sub>pg</sub> = -1 to -80?
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
You may need to increase `n_freq` as well.
</p></details></hint>

<task><details>
<summary>Task B1.3</summary><p>
Change the parameter `grid_type` to `'LINEAR'` then run <math>GYRE</math>. What happens to your output? What value do you need to use for `n_freq` to get the same output as before?
</p></details></task>

<task><details>
<summary>Task B1.4</summary><p>
Have a look at the possible [summary file output](https://gyre.readthedocs.io/en/stable/ref-guide/output-files/summary-files.html#summary-files) on the <math>GYRE</math> documentation website. Find the parameter for the stellar mass as well as the effective temperature perturbation amplitude and phase and included them as output for your <math>GYRE</math> computations. Run <math>GYRE</math> to make sure everything works.
</p></details></task>

Now before moving on to the next exercises, make sure you reset the parameters in your <math>gyre.in</math> file to the initial ones, i.e.<br>

`freq_min = 0.05`<br>
`freq_max = 5.0`<br>
`n_freq = 1000`<br>
`grid_type = 'INVERSE'`<br>
`summary_item_list = 'l,m,n_p,n_g,n_pg,freq'`

## Bonus exercise 2: Resolution impact on period spacing patterns

So far, aside from additional time step resolution near the end of the main-sequence evolution, we have been using the default mesh grid and time step resolution in <math>MESA</math>. The period spacing patterns are very sensitive to the profile of the Brunt-Vaisala frequency, as it determines where the g-modes can propagate and how they get trapped near the core as a chemical gradient is developed when the convective core contracts. Therefore, if we want to model them we have to make sure that the Brunt-Vaisala frequency profile is converged. Remember that when using <math>MESA</math> for any type of science, **it is always important to test if your models are converged!**

For this bonus exercise we are going to play around with the two parameters `mesh_delta_coeff` and `time_delta_coeff` and see how they change the Brunt-Vaisala frequency profile.<br>

<task><details>
<summary>Task B2.1</summary><p>
Copy `profile_columns.list` from `$MESA_DIR/star/defaults/` to your `SPB_minilab_2` work directory. Make sure that `brunt_N2`, `brunt_N2_structure_term`, and `brunt_N2_composition_term` are included as output.
</p></details></task>

<task><details>
<summary>Task B2.2</summary><p>
Add the following to `inlist_pgstar`:<br> `Profile_Panels1_win_flag = .true.`<br> `Profile_Panels1_num_panels = 2`<br> `Profile_Panels1_yaxis_name(1) = 'brunt_N2'`<br>
`Profile_Panels1_other_yaxis_name(1) = ''`<br>
`Profile_Panels1_yaxis_name(2) = 'brunt_N2_structure_term'`<br>
`Profile_Panels1_other_yaxis_name(2) = 'brunt_N2_composition_term'`<br> 
`Profile_Panels1_file_flag = .true.`<br> 
`Profile_Panels1_file_dir = 'png'`<br>
`Profile_Panels1_file_prefix = 'profile_panels1_1.0mdc_1.0tdc_'`<br>
`Profile_Panels1_file_width = 12`<br>
`Profile_Panels1_file_aspect_ratio = 0.75`
</p></details></task>

This will save the `pgstar` window showing the `Profile_Panels1` plot to the png directory. We will need those for comparisons later.<br> 

<task><details>
<summary>Task B2.3</summary><p>
Include the two parameters `mesh_delta_coeff = 1.0` and `time_delta_coeff = 1.0` in your <math>inlist_project</math> under <math>&controls</math>. Change your output LOGS directory to `log_directory = 'LOGS/4Msun_#fov_1.0mdc_1.0tdc'`. Likewise make sure to change `filename_for_profile_when_terminate = 'LOGS/4Msun_#fov_1.0mdc_1.0tdc/final_profile.data'`. Then run <math>MESA</math>.
</p></details></task>

Take note of the output to the png directory. Is the Brunt-Vaisala frequency profile looking smooth?<br>

<task><details>
<summary>Task B2.4</summary><p>
Now change the `mesh_delta_coeff` and `time_delta_coeff` parameters to match the combinations listed in the table below. Remember to also change `log_directory`, `filename_for_profile_when_terminate`, and `Profile_Panels1_file_prefix` accordingly to not overwrite your previous saved files. Then rerun <math>MESA</math> and look at how your saved profile plots of the Brunt-Vaisala frequency profile. Do they change as you change the mesh and time resolution? If so, in what way?

 |  `mesh_delta_coeff (mdc)`  | `time_delta_coeff (tdc)` |
 |:---:|:---:|
 | 1.0 | 1.0 | 
 | 1.0 | 0.5 | 
 | 0.5 | 1.0 | 
 | 0.5 | 0.5 | 

If you also run <math>GYRE</math> for each one of these configurations, you can check how the period spacing patterns are changing as well.

</p></details></task>