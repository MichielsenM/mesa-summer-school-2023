---
layout: default
title: Minilab 1
---
# Minilab 1

In this Minilab 1, we will start constructing the `inlist` we need to study period spacing patterns in SPB stars and investigate the effect of convective boundary mixing on the asymptotic period spacing &Pi;<sub>0</sub>, the convective core mass <i>m</i><sub>cc</sub>, and the helium core mass <i>m</i><sub>He, core</sub> obtained at the terminal-age main-sequence (TAMS). As a first step, when starting a new project with <math>MESA</math>, we copy and rename the `$MESA_DIR/star/work` directory


```
cp -r $MESA_DIR/star/work SPB_minilab_1
cd SPB_minilab_1
```

For good measure, let's make sure that the standard <math>MESA</math> inlist runs
```
./clean & ./mk
./rn
```

Let it run until the <math>pgstar</math> window shows up, then terminate the run using `ctrl + c`. 

If everything is running as it should (if not, ask your TA for help!) then it is now time to start modifying your <math>MESA</math> inlists. We will be using the same inlists throughout Minilab 1, Minilab 2, and the Maxilab and keep adding things to them as we go along. To begin with, we will focus on the <math>inlist_project</math> file. Usually, we want to start the evolution from the pre-main-sequence, however, in an effort to save time for these labs we will instead start the evolution at the zero-age-mains-sequence (ZAMS) and evolve the star until core hydrogen exhaustion. To do this, we have to modify both <math>&star_job</math> and <math>&controls</math>

```
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
```


<p style="color: rgb(0, 150, 0)">
<b>Task1:</b> Modify the <math>&star_job</math> and <math>&controls</math> sections of <math>inlist_project</math> to start the evolution at the ZAMS and stop when the core <sup>1</sup>H mass fraction drops below 0.001, then try to evolve the star.
</p>

<details>
<summary> Hint </summary>
<p style="color: rgb(225, 150, 0)">
The parameters that need to be changed are <code>create_pre_main_sequence_model</code> and <code>stop_near_zams</code>.
</p>
</details>

Once the main-sequence evolution is running, we will keep modifying inlist_project.

<p style="color: rgb(0, 150, 0)">
<b>Task2:</b> What is the default nuclear network used by <math>MESA</math>? Change this in the <math>&star_job</math> section of <math>inlist_project</math> so <math>pp_cno_extras_o18_ne22.net</math> is used instead. Also include an abundance window to the <math>pgstar</math> output. What happens to the abundance <math>pgstar</math> window when you change the network?
</p>

<details>
<summary><p style="color: rgb(225, 150, 0)">Hint</p></summary>
<p style="color: rgb(225, 150, 0)">
The parameters that need to be added in <math>inlist_project</math> are <code>change_net</code> and <code>new_net_name</code>. To plot the abundance window, add <code>Abundance_win_flag = .true.</code> to <math>inlist_pgstar</math>.
</p>
</details>

<p style="color: rgb(0, 150, 0)">
<b>Task3:</b> Make the following additional changes to <math>inlist_project</math>. The text in the parenthesis indicate where in the <math>inlist_project</math> file the required changes have to be made.
</p>

- <font style="color: rgb(0, 150, 0)"> Change the initial mass to 4M<sub>sun</sub> (<math>&controls</math>).  </font>
- <font style="color: rgb(0, 150, 0)"> Change the output LOGS directory to LOGS/4Msun\_0fov (<math>&controls</math>). </font>
- <font style="color: rgb(0, 150, 0)"> Relax the composition to X=0.71, Y=0.276, and Z=0.014 (<math>&star_job</math>, <math>&kap</math>, and <math>&controls</math>). In <math>&controls</math> add the following two parameters: <code>relax_dY = 0.001</code> and <code>relax_dlnZ = 1d-2</code>. </font>
- <font style="color: rgb(0, 150, 0)"> Use the OP opacity tables for the </font>[Asplund2009](https://ui.adsabs.harvard.edu/abs/2009ARA&A..47..481A)<font style="color: rgb(0, 150, 0)"> metal mixture (<math>&kap</math>). </font>
- <font style="color: rgb(0, 150, 0)"> Likewise, set initial metal mass fraction distribution to the one of </font>[Asplund2009](https://ui.adsabs.harvard.edu/abs/2009ARA&A..47..481A)<font style="color: rgb(0, 150, 0)"> (<math>&star_job</math>).  </font>
- <font style="color: rgb(0, 150, 0)"> Set <math>pgstar</math> to pause before terminating (<math>&star_job</math>). </font>
- <font style="color: rgb(0, 150, 0)"> Output history data at every time step instead of every fifth time step (<math>&controls</math>). </font>



<details>
<summary> Hint </summary>
<p style="color: rgb(225, 150, 0)">
The parameters that need to be added in <math>&star_job</math> are: <code>&relax_Y</code>, <code>&new_Y</code>, <code>&relax_Z</code>, <code>&new_Z</code>, <code>initial_zfracs</code>, and <code>pause_before_terminate</code>.
</p></details>
<details>
<summary> Hint </summary>
<p style="color: rgb(225, 150, 0)">
The parameters that need to be added in <math>&controls</math> are: <code>log_directory</code>, <code>&relax_dY = 0.001</code>, <code>&relax_dlnZ = 1d-2</code>, and <code>history_interval</code>.
</p></details>
<details>
<summary> Hint </summary>
<p style="color: rgb(225, 150, 0)">
The parameters that need to be changed in <math>&controls</math> are: \texttt{initial\_mass} and \texttt{initial\_z}. The latter one has to be commented out, or \texttt{MESA} will start complaining.
vscode find and replace
</p></details>
<details>
<summary> Hint </summary>
<p style="color: rgb(225, 150, 0)">
In \texttt{\&kap} the parameter \texttt{kap\_file\_prefix} has to be added while \texttt{Zbase} has to be changed to match the new metal mass fraction.}\\
</p></details>
<details>
<summary> Hint </summary>
<p style="color: rgb(225, 150, 0)">
Concerning figuring out how to set the \texttt{kap\_file\_prefix} parameter, you might notice if you look up this parameter on the \texttt{MESA} documentation website that the following options are listed: \texttt{gn93}, \texttt{gs98}, \texttt{a09}, \texttt{OP\_gs98}, and \texttt{OP\_a09\_nans\_removed\_by\_hand}. However, no explanation is given as to what these parameters actually stand for. From the naming of the parameters you might be able to guess which one you have to use, but if you want to be sure then one way to do this is to go to your \texttt{\$MESA\_DIR/data/kap\_data/} directory and look at the files there. In the file names, everything before \texttt{\_z\#.\#\_x\#.\#.data} corresponds to the input options for the \texttt{kap\_file\_prefix} parameter. If you choose one of the files there and open it, then the first line of the file will give you the explanation and reference to the table.
</p></details>
<details>
<summary> Hint </summary>
Concerning figuring out how to set the \texttt{initial\_zfracs} parameter, the \texttt{MESA} documentation website will let you know that the eight possible options are defined in the \texttt{\$MESA\_DIR/chem/public/chem\_def.f90} file. If you look from line number 299 and beyond, then you should be able to compare the references to the different metal mixtures.
</details>

