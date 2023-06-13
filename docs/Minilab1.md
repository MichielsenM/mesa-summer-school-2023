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


<task>
<b>Task1:</b> Modify the <math>&star_job</math> and <math>&controls</math> sections of <math>inlist_project</math> to start the evolution at the ZAMS and stop when the core <sup>1</sup>H mass fraction drops below 0.001, then try to evolve the star.
</task>

<details>
<summary> Hint </summary>
<p>
The parameters that need to be changed are <code>create_pre_main_sequence_model</code> and <code>stop_near_zams</code>.
</p></details>

Once the main-sequence evolution is running, we will keep modifying inlist_project.

<task>
<b>Task2:</b> What is the default nuclear network used by <math>MESA</math>? Change this in the <math>&star_job</math> section of <math>inlist_project</math> so <math>pp_cno_extras_o18_ne22.net</math> is used instead. Also include an abundance window to the <math>pgstar</math> output. What happens to the abundance <math>pgstar</math> window when you change the network?
</task>

<details>
<summary>Hint</summary>
<p>
The parameters that need to be added in <math>inlist_project</math> are <code>change_net</code> and <code>new_net_name</code>. To plot the abundance window, add <code>Abundance_win_flag = .true.</code> to <math>inlist_pgstar</math>.
</p></details>

<task>
<b>Task3:</b> Make the following additional changes to <math>inlist_project</math>. The text in the parenthesis indicate where in the <math>inlist_project</math> file the required changes have to be made.

- Change the initial mass to 4M<sub>sun</sub> (<math>&controls</math>).  
- Change the output LOGS directory to LOGS/4Msun\_0fov (<math>&controls</math>). 
- Relax the composition to X=0.71, Y=0.276, and Z=0.014 (<math>&star_job</math>, <math>&kap</math>, and <math>&controls</math>). In <math>&controls</math> add the following two parameters: <code>relax_dY = 0.001</code> and <code>relax_dlnZ = 1d-2</code>. 
- Use the OP opacity tables for the [Asplund2009](https://ui.adsabs.harvard.edu/abs/2009ARA&A..47..481A) metal mixture (<math>&kap</math>). 
- Likewise, set initial metal mass fraction distribution to the one of [Asplund2009](https://ui.adsabs.harvard.edu/abs/2009ARA&A..47..481A) (<math>&star_job</math>).
- Set <math>pgstar</math> to pause before terminating (<math>&star_job</math>). 
- Output history data at every time step instead of every fifth time step (<math>&controls</math>).

</task>

<details>
<summary> Hint </summary>
<p>
The parameters that need to be added in <math>&star_job</math> are: <code>&relax_Y</code>, <code>&new_Y</code>, <code>&relax_Z</code>, <code>&new_Z</code>, <code>initial_zfracs</code>, and <code>pause_before_terminate</code>.
</p></details>
<details>
<summary> Hint </summary>
<p>
The parameters that need to be added in <math>&controls</math> are: <code>log_directory</code>, <code>&relax_dY = 0.001</code>, <code>&relax_dlnZ = 1d-2</code>, and <code>history_interval</code>.
</p></details>
<details>
<summary> Hint </summary>
<p>
The parameters that need to be changed in <math>&controls</math> are: \texttt{initial\_mass} and \texttt{initial\_z}. The latter one has to be commented out, or \texttt{MESA} will start complaining.
vscode find and replace
</p></details>
<details>
<summary> Hint </summary>
<p>
In \texttt{\&kap} the parameter \texttt{kap\_file\_prefix} has to be added while \texttt{Zbase} has to be changed to match the new metal mass fraction.}\\
</p></details>
<details>
<summary> Hint </summary>
<p>
Concerning figuring out how to set the \texttt{kap\_file\_prefix} parameter, you might notice if you look up this parameter on the \texttt{MESA} documentation website that the following options are listed: \texttt{gn93}, \texttt{gs98}, \texttt{a09}, \texttt{OP\_gs98}, and \texttt{OP\_a09\_nans\_removed\_by\_hand}. However, no explanation is given as to what these parameters actually stand for. From the naming of the parameters you might be able to guess which one you have to use, but if you want to be sure then one way to do this is to go to your \texttt{\$MESA\_DIR/data/kap\_data/} directory and look at the files there. In the file names, everything before \texttt{\_z\#.\#\_x\#.\#.data} corresponds to the input options for the \texttt{kap\_file\_prefix} parameter. If you choose one of the files there and open it, then the first line of the file will give you the explanation and reference to the table.
</p></details>
<details>
<summary> Hint </summary>
<p>
Concerning figuring out how to set the \texttt{initial\_zfracs} parameter, the \texttt{MESA} documentation website will let you know that the eight possible options are defined in the \texttt{\$MESA\_DIR/chem/public/chem\_def.f90} file. If you look from line number 299 and beyond, then you should be able to compare the references to the different metal mixtures.
</p></details>

Once you have implemented the changes above, try to run \texttt{MESA} and see if all the implemented changes work as they should. If you tried to change the two parameters \texttt{initial\_z} and \texttt{initial\_y} to match the new compositions, you will see that \texttt{MESA} starts to complain and gives you the message:

```
 WARNING: requested initial_z does not match zams file initial_z.
                                    zams file initial_z    2.0000000000000000D-02
                                    requested initial_z    1.4000000000000000D-02



 failed in read_zams_header
File: ../private/init_model.f90, Line:  194, Message: get1_zams_model
ERROR STOP 1

Error termination. Backtrace:
#0  0x13a91e147
#1  0x13a91ecf7
#2  0x13a91ffb3
#3  0x102af7c83
#4  0x102682d5f
#5  0x102683ea7
#6  0x10268f9eb
#7  0x10269088f
#8  0x1026cb017
#9  0x1026de7ff
#10  0x1026e7b03
#11  0x1026e8a9b
#12  0x1026e8c5b
#13  0x102138ff7
#14  0x102139093
#15  0x1021390d3
```


This is because \texttt{MESA} only has initial ZAMS starting models available for \texttt{initial\_z = 0.02} and \texttt{initial\_y = 0.28} (see \texttt{\$MESA\_DIR/data/star\_data/zams\_models/zams\_z2m2\_y28.data}) and therefore does not known what to do if you try to change these initial compositions. One option is create such starting ZAMS models of different composition, and another is to start from one of these predefined ZAMS models and relax the composition to the one that you want. For this exercise we did the latter of the two options.

Once your new \texttt{inlist\_project} is working, the next step is to start including convective boundary mixing. Before doing so, lets adjust the plotting window of the \texttt{pgstar} HR diagram and include one additional \texttt{pgstar} plotting windows showing the mixing profile.


<task><b>Task4:</b> Zoom in on the MS evolutionary track of the start in the \texttt{pgstar} HR window and include an additional \texttt{pgstar} window showing the mixing profile. </task>

<details>
<summary> Hint </summary>
<p>
Modify the four input parameters \texttt{HR\_logT\_min}, \texttt{HR\_logT\_max}, \texttt{HR\_logL\_min}, and \texttt{HR\_logL\_max} in \texttt{inlist\_pgstar}. You can do this on the fly while \texttt{MESA} is running. Look up "Mixing window" in the \texttt{MESA} \texttt{pgstar} documentation. The parameter you want to add to \texttt{inlist\_pgstar} is \texttt{Mixing\_win\_flag}.
</p></details>

The final input parameters we want to add to \texttt{inlist\_project} is convective boundary mixing. For this exercise we will only consider exponential diffusive overshoot on top of the hydrogen burning convective core: 

#TODO INSERT EQUATION

This type of mixing is one out of two overshoot mixing schemes that have been implemented in \texttt{MESA}. $D_0$ is the diffusive mixing coefficient at $r_0 = r_{\rm cc} - f_0 H_{\rm p, cc}$, i.e. at a step of $f_0 H_{\rm p, cc}$ inside the convective core boundary at radius coordinate $r_{\rm cc}$, $H_{\rm p, 0}$ is the pressure scale height at $r_0$, $H_{\rm p, cc}$ is the pressure scale height at $r_{\rm cc}$, and $f_{\rm ov}$ is the overshoot parameter. For this exercise, we will fix $f_0 = 0.002$ and vary $f_{\rm ov}$ from 0.005 to 0.04.


<task>
<b>Task 5:</b> Look up the parameters required to include convective boundary mixing (overshoot) in \texttt{MESA}. Include these parameters in \texttt{inlist\_project} (\texttt{\&controls}), replace the (:) with (1), set the overshoot scheme to exponential on top of the core during hydrogen burning, set $f_0 = 0.002$, and choose a value for $f_{\rm ov}$ between 0.005 to 0.04. Run \texttt{MESA}. Change the name of your output LOGS directory \texttt{LOGS/4Msun\_\#fov} so that \# corresponds to your choice of $f_{\rm ov}$. What happens to the \texttt{pgstar} mixing and HR windows? Note that models with a higher $f_{\rm ov}$ parameter will take longer to run, so if your laptop is slow make sure to choose a low value and have someone else at your table choose a high value.
</task>

<details>
<summary> Hint </summary>
<p>
The parameters to be added to \texttt{\&controls} in \texttt{inlist\_project} are: \texttt{overshoot\_scheme(1)}, \texttt{overshoot\_zone\_type(1)}, \texttt{overshoot\_zone\_loc(1)}, \texttt{overshoot\_bdy\_loc(1)}, \texttt{overshoot\_f(1)}, and \texttt{overshoot\_f0(1) = 0.002}. \texttt{overshoot\_f(1)} is the overshooting parameter that you will be varying.
</p></details>

<task>
<b>Task 6:</b> Include \texttt{overshoot\_D\_min = 1d-2} in \texttt{inlist\_project} (\texttt{\&controls}). What happens to the mixing profile shown in your mixing window? What is the default value of \texttt{overshoot\_D\_min}?
</task>

Now that we have the desired physics included in our \texttt{MESA} inlists, it is time to see how exponential diffusive overshooting impacts the convective core mass ($m_{\rm cc}$), the helium core mass obtained that the TAMS ($m_{\rm He,core}$), the age of the star at the TAMS ($\tau_{\rm TAMS}$), the $^{14}$N mass fraction at the surface ($X(^{14}{\rm N})_{\rm surf}$), and the asymptotic period spacing of $\ell=1$ g-modes ($\Pi_{\ell=1}$). To do so, we first have to make sure that these are included as part of the history output.

<task>
<b>Task 7:</b> Copy \texttt{history\_columns.list} from \texttt{\$MESA\_DIR/star/defaults} to \texttt{SPB\_minilab\_1}. Make sure that the following parameters are included in \texttt{history\_columns.list}: convective core mass, helium core mass, star age, surface $^{14}$N mass fraction, center $^{1}$H mass fraction, and asymptotic g-mode period spacing for $\ell=1$ modes. Run \texttt{MESA} and answer/do the following:

- In the Google spreadsheet (to be made with link) note down your $m_{\rm He,core}$, $\tau_{\rm TAMS}$, and $X(^{14}{\rm N})_{\rm surf}$ at TAMS. 
- Find the value of $\Pi_{\ell=1}$ and $m_{\rm cc}$ at \texttt{center\_h1}$\sim 0.35$ (i.e. halfway through core hydrogen burning) and add these to the Google spreadsheet.
- How do these values change for different values of $f_{\rm ov}$?
</task>


<details>
<summary> Hint </summary>
<p>
The convective core mass (\texttt{mass\_conv\_core}), helium core mass (\texttt{he\_core\_mass}), star age (\texttt{star\_age}), and center $^{1}$H mass fraction (\texttt{center h1}) parameters are already included in the history output by default. The only additional ones you have to add are \texttt{surface n14} and \texttt{delta\_Pg}.
</p></details>
