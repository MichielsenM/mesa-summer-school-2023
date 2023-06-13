---
layout: default
title: Minilab 1
---
# Minilab 1

In this Minilab 1, we will start constructing the `inlist` we need to study period spacing patterns in SPB stars and investigate the effect of convective boundary mixing on the asymptotic period spacing $\Pi_0$, the convective core mass <math>m_{\rm cc}</math>, and the helium core mass $m_{\rm He, core}$ obtained at the terminal-age main-sequence (TAMS). As a first step, when starting a new project with MESA, we copy and rename the `$MESA_DIR/star/work` directory


```
cp -r $MESA_DIR/star/work SPB_minilab_1
cd SPB_minilab_1
```

For good measure, let's make sure that the standard MESA inlist runs
```
./clean & ./mk
./rn
```

Let it run until the `pgstar` window shows up, then terminate the run using `ctrl + c`. 

If everything is running as it should (if not, ask your TA for help!) then it is now time to start modifying your MESA inlists. We will be using the same inlists throughout Minilab 1, Minilab 2, and the Maxilab and keep adding things to them as we go along. To begin with, we will focus on the `inlist_project` file. Usually, we want to start the evolution from the pre-main-sequence, however, in an effort to save time for these labs we will instead start the evolution at the zero-age-mains-sequence (ZAMS) and evolve the star until core hydrogen exhaustion. To do this, we have to modify both `&star_job` and `&controls`

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


<p style="color: rgb(127, 255, 0)">
<b>Task1:</b> Modify the `&star_job` and <code>&controls</code> sections of <code>inlist_project</code> to start the evolution at the ZAMS and stop when the core <sup>1</sup>H mass fraction drops below 0.001, then try to evolve the star.
</p>

<details>
<summary> Hint </summary>
<p style="color: rgb(225, 191, 0)">
The parameters that need to be changed are <code>create_pre_main_sequence_model</code> and <code>stop_near_zams</code>.
</p>
</details>

Once the main-sequence evolution is running, we will keep modifying inlist_project.

<p style="color: rgb(127, 255, 0)">
<b>Task2:</b> What is the default nuclear network used by MESA? Change this in the <code>&star_job</code> section of <code>inlist_project</code> so <code>pp_cno_extras_o18_ne22.net</code> is used instead. Also include an abundance window to the <code>pgstar</code> output. What happens to the abundance <code>pgstar</code> window when you change the network?
</p>

<details>
<summary> Hint </summary>
<p style="color: rgb(225, 191, 0)">
The parameters that need to be added in <code>inlist_project</code> are <code>change_net</code> and <code>new_net_name</code>. To plot the abundance window, add <code>Abundance_win_flag = .true.</code> to <code>inlist_pgstar</code>.
</p>
</details>