---
layout: default
title: Minilab 1
---
# Introduction

Some basic introduction to the physics goes here...

# Minilab 1

In this Minilab 1, we will start constructing the `inlist` we need to study period spacing patterns in SPB stars and investigate the effect of convective boundary mixing on the asymptotic period spacing $\Pi_0$, the convective core mass $m_{\rm cc}$, and the helium core mass $m_{\rm He, core}$ obtained at the terminal-age main sequence (TAMS). As a first step, when starting a new project with `MESA`, we copy and rename the `$MESA_DIR/star/work` directory

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal">
  <p>cp -r $MESA_DIR/star/work SPB_minilab_1 <br>
  cd SPB_minilab_1</p>
</div>

For good measure, let's make sure that the standard `MESA` inlist runs
<div class="terminal-title"> Terminal commands </div> 
<div class="terminal">
  <p>./clean & ./mk <br>
  ./rn</p>
</div>


Let it run until the `pgstar` window shows up, then terminate the run using `ctrl + c`. 

<task><details>
<summary>Task 1</summary><p>
Copy and rename the <code>$MESA_DIR/star/work</code> directory as demonstrated above, then compile and run <code>MESA</code> to check that everything is running as it should.
</p></details></task>

If everything is running as it should (if not, ask your TA for help!) then it is now time to start modifying your `MESA` inlists. We will be using the same inlists throughout Minilab 1, Minilab 2, and the Maxilab and keep adding things to them as we go along. 

As `MESA` is running, you will notice that two `pgstar` windows show up. One is an HR diagram showing the evolutionary track of the star, with its current effective temperature and luminosity indicated by a red circle. The second window shows the current internal temperature versus density profile of the star, indicating also convective and other (non-)mixing regions by the colour of the profile, at what combined central densities and temperatures nuclear burning is taking place (part of the white dashed lines), the amount of generated energy (yellow, orange, and red outline of the profile), etc.

<div class="row">
  <div style="align: left; text-align:center;">
      <div class="column">
        <img src="images/hr_000205.png" width="500" />
      </div>
      <div class="column">
        <img src="images/trho_profile_000205.png" width="500" />
      </div>
  </div>
</div>

Both of these `pgstar` windows are the default windows being shown in `MESA` when you copy the `$MESA_DIR/star/work` directory. Depending on your laptop/desktop these windows might appear small and difficult to read. Fortunately, `MESA` provides a variety of parameters that we can use to make changes to the default `pgstar` windows, including their sizes. We can do so within the file `inlist_pgstar`. The `pgstar` documentation can be found [here](https://docs.mesastar.org/en/release-r23.05.1/reference/pgstar.html#). 

<task><details>
<summary>Task 2</summary><p>
Modify your <code>inlist_pgstar</code> file until you are satisfied with the sizes of your <code>pgstar</code> windows. Note that any changes that you make to <code>inlist_pgstar</code> and save while <code>MESA</code> is running are automatically updated on the fly.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The two <code>pgstar</code> plotting windows are called <code>HR window</code> 
(<a href="https://docs.mesastar.org/en/release-r23.05.1/reference/pgstar.html#hr-window">documentation</a>) and <code>TRho Profile Window</code> (<a href="https://docs.mesastar.org/en/release-r23.05.1/reference/pgstar.html#trho-profile-window">documentation</a>). The names of the parameters that you should be varying are: <code>HR_win_width</code>, <code>HR_win_aspect_ratio</code>, <code>TRho_Profile_win_width</code>, and <code>TRho_Profile_win_aspect_ratio</code>. These are already included in <code>inlist_pgstar</code> by default.
</p></details></hint>

While we don't recommend using figures generated with `pgstar` in papers, these figures are very useful both for troubleshooting and making sure that `MESA` is doing what we expect it to do. This will become more clear in the Maxilab once we start to include our own custom mixing profiles in `MESA`. 

Now that the `pgstar` windows are on the right scale, we will focus on the `inlist_project` file. Usually, we want to start the evolution from the pre-main sequence, however, in an effort to save time for these labs we will instead start the evolution at the zero-age main sequence (ZAMS) using a pre-generated starting model for a $4M_\odot$ star and evolve the star until core hydrogen exhaustion. To do this, we have to modify both `&star_job` and `&controls`. 

<div class="filetext-title"> inlist_project </div> 
<div class="filetext"><p><pre class="pre-filetext">
&star_job
  ...

  ! begin with a pre-main sequence model
    create_pre_main_sequence_model = .true.
  ...

/ ! end of star_job namelist

...

&controls
  ...

  ! when to stop

    ! stop when the star nears ZAMS (Lnuc/L > 0.99)
    Lnuc_div_L_zams_limit = 0.99d0
    stop_near_zams = .true.

    ! stop when the center mass fraction of h1 drops below this limit
    xa_central_lower_limit_species(1) = 'h1'
    xa_central_lower_limit(1) = 1d-3

  ...

/ ! end of controls namelist
</pre></p></div>

You can find the `&star_job` documentation [here](https://docs.mesastar.org/en/release-r23.05.1/reference/star_job.html), while the corresponding documentation website for the `&controls` parameters are located [here](https://docs.mesastar.org/en/release-r23.05.1/reference/controls.html). If you want to have a look at the inlist used to create the starting model, you can download it from [here](https://www.dropbox.com/s/elxoxppd67ojmtz/inlist_ZAMS_Y0.28_Z0.02?dl=0), but you don't need it to do these `MESA` labs.

<task><details>
<summary>Task 3</summary><p>
Modify the <code>&star_job</code> and <code>&controls</code> sections of <code>inlist_project</code> to start the evolution at the ZAMS by loading in the provided ZAMS model <a href="https://www.dropbox.com/s/o3djdn8d98rlln1/SPB_ZAMS_Y0.28_Z0.02.mod?dl=0">SPB_ZAMS_Y0.28_Z0.02.mod</a> for a $4\,$M$_\odot$ star and stop the evolution when the core <sup>1</sup>H mass fraction drops below 0.001. Also include an abundance window to the <code>pgstar</code> output, then try to evolve the star.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The parameters that need to be changed are <code>create_pre_main_sequence_model</code> (<code>&star_job</code>) and <code>stop_near_zams</code>(<code>&controls</code>), while two additional parameters (<code>load_saved_model</code> and <code>load_model_filename</code>) have to be included in <code>&star_job</code> to load the <code>SPB_ZAMS_Y0.28_Z0.02.mod</code> file. To plot the abundance window, add <code>Abundance_win_flag = .true.</code> to <code>inlist_pgstar</code> (<a href="https://docs.mesastar.org/en/release-r23.05.1/reference/pgstar.html#abundance-window">documentation</a>).
</p></details></hint>

As `MESA` is running, you should now see a third `pgstar` window appear, showing the abundance profiles as a function of mass. The x-axis is color coded according to the internal mixing taking place in different regions of the star, and matches that being shown in the `TRho_profile` window. If you are unhappy with the size of this window, you can change in the size and aspect ratios of it in `inlist_pgstar` using the parameters `Abundance_win_width` and `Abundance_win_aspect_ratio`. 

<div style="align: left; text-align:center;">
    <img src="images/abund_000255.png" width="700" /> 
</div>

<br>
Once the main-sequence evolution is running, we will keep modifying `inlist_project`. First we change the nuclear network to include additional reactions and isotopes relevant for the CNO-cycle. A list of default nuclear networks options availble in `MESA` are listed in the `$MESA_DIR/data/net_data/nets` directory. We refer to the `MESA` labs tomorrow for more details on nuclear networks. 

<task><details>
<summary>Task 4</summary><p>
What is the default nuclear network used by <code>MESA</code>? Change this in the <code>&star_job</code> section of <code>inlist_project</code> so <code>pp_cno_extras_o18_ne22.net</code> is used instead. Also include an abundance window to the <code>pgstar</code> output. What happens to the abundance <code>pgstar</code> window when you change the network?
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The parameters that need to be added in <code>inlist_project</code> are <code>change_net</code> and <code>new_net_name</code>.
</p></details></hint>

<hint><details>
<summary> Hint </summary><p>
Prior to changing the network, you can find out what the name of the default nuclear network is by running <code>MESA</code> and looking at the terminal output. Alternatively, you can look at the parameter <code>default_net_name</code> in the <a href="https://docs.mesastar.org/en/release-r23.05.1/reference/controls.html#nuclear-reaction-controls">nuclear networks controls</a> section of the <code>controls</code> documentation webpage.
</p></details></hint>

Next we are going to change the name of the `LOGS` directory where the `MESA` output `history.data` and `profile#.data` files gets saved in preparation of varying the convective boundary mixing of the star without overwriting previous `MESA` calculations. We will also relax the composition of the star to match the Galactic standard measured from B-type stars in the solar neighbourhood (<a href="https://ui.adsabs.harvard.edu/abs/2012A%26A...539A.143N/abstract">Nieve & Przybilla 2012</a>; <a href="https://ui.adsabs.harvard.edu/abs/2013EAS....63...13P/abstract">Przybilla et al. 2013</a>), change the opacity tables to the OP tables calculate for the metal mixture of <a href="https://ui.adsabs.harvard.edu/abs/2009ARA&A..47..481A">Asplund et al. (2009)</a> to match the initial metal mixture used in our starting model `SPB_ZAMS_Y0.28_Z0.02.mod` for the sake of consistency, and increase the frequency at which the history output is saved to the `history.data` file. 

The choice of opacity tables and metal mixtures is particularly important when we try to predict which oscillations get excited by the $\kappa$-mechanism (i.e. opacity or heat mechanism) operating in partial ionization zones. This the mechanism operating in partial inization zone of iron, also known as the iron opacity bump, is responsible for exciting the gravity mode pulsations found in SPB stars. The choice of the metal mixture determines how the mass fractions of the metal isotopes (i.e. anything other than hydrogen and helium) are distributed, and highly impacts the opacities in the iron pratial ionization zone as demonstrated in the figure below. Furthermore, the choice of opacities and metal mixtures will also modify the predicted oscillation frequencies (see, e.g., Figure 3 of <a href="https://ui.adsabs.harvard.edu/abs/2015A%26A...580A..27M/abstract">Morraveji et al. (2015)</a>). Studying mode excitation is outside the scope of these `MESA` labs and we refer instead to previous `MESA` labs by Rich Townsend and Radek Smolec from the [2019](https://cococubed.com/mesa_summer_schools/mesa_summer_school_2019/) and [2021](https://cococubed.com/mesa_summer_schools/mesa_summer_school_2021/index.html) MESA Summer Schools.

<div style="align: left; text-align:center;">
    <img src="images/opacities.jpeg" width="600" /> 
    <div class="caption" style="width: 600"> Example Rosseland opacity $\kappa$ versus temperature profiles for a $10M_\odot$ star, with convective regions indicated by the vertical blue-purple zones. A default <code>MESA</code> opacity profile is shown in dashed blue. Corresponding opacity profiles resulting from increasing the metal mixture of iron (red dashed) and both iron and nickle (full black) clearly show an increase in the opacity in the partial ionization zone of iron at around $\log T\sim 5.3$. Credit: <a href="https://ui.adsabs.harvard.edu/abs/2016MNRAS.455L..67M/abstract">Morraveji (2016)</a>.</div>
</div>

<br>
<task><details>
<summary>Task 5</summary><p>
Make the following additional changes to <code>inlist_project</code>. The text in the parenthesis indicate where in the <code>inlist_project</code> file the required changes have to be made.
</p>
<ul>
<li> Change the output LOGS directory to <code>LOGS/4Msun_0fov</code> (<code>&controls</code>). </li>
<li> Relax the composition to $X=0.71$, $Y=0.276$, and $Z=0.014$ (<code>&star_job</code>, <code>&kap</code>, and <code>&controls</code>). In <code>&controls</code> add the following two parameters: <code>relax_dY = 0.001</code> and <code>relax_dlnZ = 1d-2</code>. These latter two parameters determine how quickly the composition is relaxed to the new desired values of $Y$ and $Z$. </li>
<li> Use the OP opacity tables for the <a href="https://ui.adsabs.harvard.edu/abs/2009ARA&A..47..481A">Asplund et al. (2009)</a>  metal mixture (<code>&kap</code>) and make sure to also set the <code>Zbase</code> parameter (<code>&kap</code>, <a href="https://docs.mesastar.org/en/release-r23.05.1/reference/kap.html">documentation</a>) equal to 0.014 so the base metallicity of the opacity tables match the new value of $Z$. </li>
<li> Set <code>pgstar</code> to pause before terminating (<code>&star_job</code>). </li>
<li> Output history data at every time step instead of every fifth time step (<code>&controls</code>).</li>
</ul>
</details></task>

<hint><details>
<summary> Hint </summary><p>
The parameters that need to be added in <code>&star_job</code> are: <code>relax_Y</code>, <code>new_Y</code>, <code>relax_Z</code>, <code>new_Z</code>, and <code>pause_before_terminate</code>.
</p></details></hint>

<hint><details>
<summary> Hint </summary><p>
The parameters that need to be added in <code>&controls</code> are: <code>log_directory</code>, <code>relax_dY = 0.001</code>, <code>relax_dlnZ = 1d-2</code>, and <code>history_interval</code>.
</p></details></hint>

<hint><details>
<summary> Hint </summary><p>
Concerning figuring out how to set the <code>kap_file_prefix</code> parameter, you might notice if you look up this parameter on the <code>MESA</code> documentation website that the following options are listed: <code>gn93</code>, <code>gs98</code>, <code>a09</code>, <code>OP_gs98</code>, and <code>OP_a09_nans_removed_by_hand</code>. However, no explanation is given as to what these parameters actually stand for. From the naming of the parameters you might be able to guess which one you have to use, but if you want to be sure then one way to do this is to go to your <code>$MESA_DIR/data/kap_data/</code> directory and look at the files there. In the file names, everything before <code>_z#.#_x#.#.data</code> corresponds to the input options for the <code>kap_file_prefix</code> parameter. If you choose one of the files there and open it, then the first line of the file will give you the explanation and reference to the table.
</p></details></hint>
<br>

Once you have implemented the changes above, try to run `MESA` and see if all the implemented changes work as they should. If you tried to change the two parameters `initial_z` and `initial_y` to match the new compositions, you will see in the terminal output that `MESA` is ignoring these changes. You may also see that although the parameter `initial_mass = 15` is still set in the `inlist_project` file, then this choice of initial mass is also being ignored. As a reminder, the mass of the loaded model is $4M_\odot$.

<div class="terminal-title"> Terminal output </div> 
<div class="terminal"><pre class="pre-terminal">
 ___________  ...  ___________   ...	_________ ...

       step   ...  Mass          ...	Y_surf    ...
  lg_dt_yrs   ...  lg_Mdot       ...	Z_surf    ...
    age_yrs   ...  lg_Dsurf      ...	Z_cntr    ...
 ___________  ...  ___________   ...	_________ ...
 
        240   ...  4.000000      ...	0.280000  ...
 6.3041E+00   ...  -99.000000    ...	0.020000  ...
 1.0143E+08   ...  -9.311364     ...	0.019646  ...
</pre></div>


This is because the initial mass and composition have already been set by the input `MESA` model `SPB_ZAMS_Y0.28_Z0.02.mod`, which we are telling `MESA` to load. If we wanted to change these values, then we can relax the composition of the input model (as we are doing in this minilab) and likewise we can relax the inital mass of the model.

Once your new `inlist_project` is working, the next step is to start including convective boundary mixing. Before doing so, lets adjust the plotting window of the `pgstar` HR diagram and include one additional `pgstar` plotting window showing the mixing profile. You may also notice that the evolutionary track showing up in the `HR window` only takes up a small part of the `pgstar` plot. This is because we are now considering a $4M_\odot$ star instead of the default $15M_\odot$ star, and we are focusing only on the main-sequence evolution. An example comparion of the `HR window` before and after zooming in on the evolutionary track is shown below. 

<div class="row">
  <div style="align: left; text-align:center;">
      <div class="column">
        <img src="images/hr_v2_000285.png" width="500" />
        <div class="caption" style="width: 500"> New <code>HR window</code> before modifying x- and y-axes limits.</div>
      </div>
      <div class="column">
        <img src="images/hr_v3_000285.png" width="500" />
        <div class="caption" style="width: 500"> Example new <code>HR window</code> after modifying x- and y-axes limits.</div>
      </div>
  </div>
</div>
<br>

<task><details>
<summary>Task 6</summary><p>
Zoom in on the MS evolutionary track of the start in the <code>pgstar</code> HR window and include an additional <code>pgstar</code> window showing the mixing profile. 
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
Modify the four input parameters <code>HR_logT_min</code>, <code>HR_logT_max</code>, <code>HR_logL_min</code>, and <code>HR_logL_max</code> in <code>inlist_pgstar</code>. You can do this on the fly while <code>MESA</code> is running. Look up "Mixing window" in the <code>MESA</code> <code>pgstar</code> <a href="https://docs.mesastar.org/en/release-r23.05.1/reference/pgstar.html#mixing-window">documentation</a>. The parameter you want to add to <code>inlist_pgstar</code> is <code>Mixing_win_flag</code>.
</p></details></hint>
<br>

The final input parameters we want to add to `inlist_project` are related to the convective boundary mixing. For this exercise we will only consider exponential diffusive overshoot on top of the hydrogen burning convective core: 

$$D_{\rm ov} (r) = D_0 \exp \left(\frac{-2 \left[r-r_0\right]}{f_{\rm ov} H_{\rm p,0}} \right)$$

This type of mixing is one out of two overshoot mixing schemes that have been implemented in `MESA`. $D_0$ is the diffusive mixing coefficient at $r_0 = r_{\rm cc} - f_0 H_{\rm p,cc}$ , i.e. at a step of $f_0 H_{\rm p,cc}$  inside the convective core boundary at radius coordinate $r_{\rm cc}$. This step is required because the diffusive mixing coefficient for the convective zone approaches zero at the core boundary. $H_{\rm p,0}$ is the pressure scale height at $r_0$, $H_{\rm p, cc}$ is the pressure scale height at $r_{\rm cc}$, and $f_{\rm ov}$ is the overshoot parameter. For this exercise, we will fix $f_0 = 0.002$  and vary $f_{\rm ov}$ from 0.005 to 0.04.


<task><details>
<summary>Task 7</summary><p>
Look up the parameters required to include convective boundary mixing (overshoot) in <code>MESA</code>. Include these parameters in <code>inlist_project</code> (<code>&controls</code>), replace the (:) with (1), set the overshoot scheme to exponential on top of the core during hydrogen burning, set $f_0 = 0.002$, and choose a value for $f_{\rm ov}$ between 0.005 to 0.04. Run <code>MESA</code>. Change the name of your output LOGS directory <code>LOGS/4Msun_#fov</code> so that <code>#</code> corresponds to your choice of $f_{\rm ov}$. What happens to the <code>pgstar</code> mixing and HR windows? Note that models with a higher $f_{\rm ov}$ parameter will take longer to run, so if your laptop is slow make sure to choose a low value and have someone else at your table choose a high value.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The parameters to be added to <code>&controls</code> in <code>inlist_project</code> are: <code>overshoot_scheme(1)</code>, <code>overshoot_zone_type(1)</code>, <code>overshoot_zone_loc(1)</code>, <code>overshoot_bdy_loc(1)</code>, <code>overshoot_f(1)</code>, and <code>overshoot_f0(1) = 0.002</code>. <code>overshoot_f(1)</code> is the overshooting parameter that you will be varying.
</p></details></hint>
<br>

<task><details>
<summary>Task 8</summary><p>
Include <code>overshoot_D_min = 1d-2</code> in <code>inlist_project</code> (<code>&controls</code>). What happens to the mixing profile shown in your mixing window? What is the default value of <code>overshoot_D_min</code>?
</p></details></task>
<br>

Your final `pgstar` mixing window should end up looking something like this depending on your choice of $f_{\rm ov}$:

<div style="align: left; text-align:center;">
    <img src="images/mixing_000255.png" width="500" /> 
</div>
<br>

Now that we have the desired physics included in our `MESA` inlists, it is time to see how exponential diffusive overshooting impacts the convective core mass ($m_{\rm cc}$), the helium core mass obtained that the TAMS ($m_{\rm He, core}$), the age of the star at the TAMS ($\tau_{\rm TAMS}$), the <sup>14</sup>N mass fraction at the surface <i>X</i>(<sup>14</sup>N)<sub>surf</sub>, and the asymptotic period spacing of $\ell =1$ g-modes ($\Pi_{\ell=1}$). To do so, we first have to make sure that these are included as part of the history output.

<task><details>
<summary>Task 9</summary><p>
Copy <code>history_columns.list</code> from <code>$MESA_DIR/star/defaults</code> to <code>SPB_minilab_1</code>. Make sure that the following parameters are included in <code>history_columns.list</code>: <code>mass_conv_core</code>, <code>he_core_mass</code>, <code>surface_n14</code>, <code>center_h1</code>,
and <code>delta_Pg</code>. Also add the parameter <code>delta_Pg_mode_freq = 20</code> to your <code>inlist_project</code> file under <code>\&controls</code>.
Run <code>MESA</code> and answer/do the following:
</p>
<ul>
<li> In the  <a href="https://docs.google.com/spreadsheets/d/1KrAoaLLOtSo-p8H_E2XO77FEUni6PugNR7jKK6_I71c/edit#gid=713862144">Google spreadsheet</a> note down your name and choice of $f_{\rm ov}$, as well as $m_{\rm He, core}$, $\tau_{\rm TAMS}$, and $X(^{14}{\rm N})_{\rm surf}$ at TAMS. </li>
<li> Find the value of $\Pi_{\ell=1}$ and $m_{\rm cc}$ at <code>center_h1 &sim; 0.35</code> (i.e. halfway through core hydrogen burning) and add these to the Google spreadsheet.</li>
<li> How do these values change for different values of $f_{\rm ov}$?</li>
</ul>
</details></task>


<hint><details>
<summary> Hint </summary><p>
The convective core mass (<code>mass_conv_core</code>), helium core mass (<code>he_core_mass</code>), star age (<code>star_age</code>), and center <sup>1</sup>H mass fraction (<code>center_h1</code>) parameters are already included in the history output by default. The only additional ones you have to add are <code>surface_n14</code> and <code>delta_Pg</code>.
</p></details></hint>

<hint><details>
<summary> Hint </summary><p>
When finding the values at <code>center_h1 &sim; 0.35</code> just select the ones that are closest to this value.
</p></details></hint>

## Bonus exercise!
