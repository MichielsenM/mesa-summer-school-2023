---
layout: default
title: Maxilab
---
# Maxilab

For this Maxilab we will now start digging into our <code>run_star_extras.f90</code> file and make changes both to the <code>MESA</code> output as well as change the mixing profile used in the radiative envelope. Once again we will start by copying and renaming our Minilab 2 work directory. If you were unable to complete Minilab 2, then you can download the solution from here **(include link with solution)**.

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
cp -r SPB_minilab_2 SPB_maxilab
cd SPB_maxilab
</p></div>

In both your <code>inlist_project</code> and <code>inlist_pgstar</code> files make sure that <code>mesh_delta_coeff = 1.0</code>, <code>time_delta_coeff = 1.0</code>, and that the associated <code>Profile_Panels1_file_prefix</code>, 

<code>filename_for_profile_when_terminate</code>, and <code>log_directory</code> parameters are changed accordingly.<br>

Now if you have a look at your <code>run_star_extras.f90</code> file inside <code>src</code> you should see that it is fairly empty

<div class="filetext-title"> src/run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
! ***********************************************************************
!
!   Copyright (C) 2010-2019  Bill Paxton & The MESA Team
!
!   this file is part of mesa.
!
!   mesa is free software; you can redistribute it and/or modify
!   it under the terms of the gnu general library public license as published
!   by the free software foundation; either version 2 of the license, or
!   (at your option) any later version.
!
!   mesa is distributed in the hope that it will be useful, 
!   but without any warranty; without even the implied warranty of
!   merchantability or fitness for a particular purpose.  see the
!   gnu library general public license for more details.
!
!   you should have received a copy of the gnu library general public license
!   along with this software; if not, write to the free software
!   foundation, inc., 59 temple place, suite 330, boston, ma 02111-1307 usa
!
! ***********************************************************************
 
      module run_star_extras

      use star_lib
      use star_def
      use const_def
      use math_lib
      
      implicit none
      
      ! these routines are called by the standard run_star check_model
      contains
      
      include 'standard_run_star_extras.inc'

      end module run_star_extras
</pre></p></div>

All it is really doing right now is reading the contents of the <code>standard_run_star_extras.inc</code> file located in the <code>$MESA_DIR/star/job</code> directory. When we want to make changes to the <code>run_star_extras.f90</code> setup, the first step is to copy the contents <code>standard_run_star_extras.inc</code> into our <code>run_star_extras.f90</code> file rather than modifying <code>standard_run_star_extras.inc</code>. <br>

<task><details>
<summary>Task 1</summary><p>
Replace the line <code>include 'standard_run_star_extras.inc'</code> in <code>run_star_extras.f90</code> with the contents of <code>$MESA_DIR/star/job/standard_run_star_extras.inc</code>. Then do a <code>./clean</code> and <code>./mk</code> in your working directory (not in the <code>src</code> directory) to check that everything is working as it should.
</p></details></task>

If in doubt, your new <code>run_star_extras.f90</code> should look like [this](https://www.dropbox.com/s/lqo86zd66sriziz/run_star_extras.f90?dl=0).<br>

Whenever we make changes to <code>run_star_extras.f90</code>, we have to use <code>./mk</code> to make sure that the new changes are included in our <code>MESA</code> runs. Doing this often will make it easier to identify the source of any errors associated with our changes to <code>run_star_extras.f90</code> that might pop up when we try to recompile our <code>MESA</code> work directory.

When we want to make changes to different physical or numerical aspects of <code>MESA</code>, the various <code>other hooks</code> located in <code>$MESA_DIR/star/other</code> directory makes it easy to do so inside <code>run_star_extras.f90</code> without having to directly make changes to the <code>MESA</code> source code. It also allows us to do so, without having to apply such changes to all future <code>MESA} projects that we do using our installed <code>MESA} version. Instructions on how to use these <code>other hooks} are given in the <code>$MESA_DIR/star/other/README} file. Here we will walk you through how to make changes to the internal diffusive mixing profile using the <code>other_d_mix.f90} hook. Lets start by having a look at what this file looks like.

<div class="filetext-title"> $MESA_DIR/star/other/other_d_mix.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
      module other_D_mix

      ! consult star/other/README for general usage instructions
      ! control name: use_other_D_mix = .true.
      ! procedure pointer: s% other_D_mix => my_routine


      use star_def

      implicit none
      
      contains
      
      
      subroutine null_other_D_mix(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         ierr = 0
      end subroutine null_other_D_mix


      end module other_D_mix
</pre></p></div>

As you can see, the <code>other_d_mix.f90} file itself contains some information on what we need to do to include the <code>other_d_mix} hook in our <code>MESA} runs, but it doesn't actually tell use which parameter we need to modify using the other hook to change the mixing profile. We will get back to this parameter later and focus now on including the <code>other_d_mix} hook.<br>

<task><details>
<summary>Task 2</summary><p>
Copy the subroutine <code>null_other_D_mix} from <code>other_d_mix.f90} and place it right after the line <code>end subroutine extras_controls} in your <code>run_star_extras.f90}. Rename the <code>null_other_D_mix} subroutine to <code>my_other_D_mix}. Do <code>./mk} to make sure you didn't make any mistakes.
</p></details></task>

Next we need to tell <code>MESA} to use our new subroutine <code>my_other_D_mix}.<br>

<task><details>
<summary>Task 3</summary><p>
In <code>inlist_project} add the line<br> <code>use_other_D_mix = .true.</code><br> under the <code>&controls} section. In <code>run_star_extras.f90} add the line<br> <code>s% other_D_mix => my_other_D_mix</code><br> at the end of the <code>extras_controls} subroutine. Then compile (<code>./mk}) and run (<code>./rn}) <code>MESA}. Does anything happen to your mixing <code>pgstar} window?
</p></details></task>

Currently, nothing new is actually happening to the mixing profile in <code>MESA} because we haven't asked <code>MESA} to change it yet. This makes it difficult to tell if <code>MESA} is actually calling our new subroutine <code>my_other_D_mix}. To check this, we can add a print statement to <code>my_other_D_mix}.<br> 

<task><details>
<summary>Task 4</summary><p>
Add the line<br> <code>print *, 'I am using my_other_D_mix'</code><br> to your <code>my_other_D_mix} subroutine inside <code>run_star_extras.f90}. Recompile and run <code>MESA}, then check the terminal output to see if the line <code>'I am using my_other_D_mix'} starts to show up.
</p></details></task>

Now that we know that <code>MESA} is actually calling our <code>my_other_D_mix} subroutine, we need to figure out which parameter we have to modify to change the mixing profile. Figuring this out is not always straightforward if we only go by the information available inside the <code>other hooks}, and may require some digging into the <code>MESA} setup. The name of the subroutine <code>null_other_D_mix} inside <code>other_d_mix.f90} does give us the hint that it might be called <code>D_mix}. Lets try to see if this is a parameter that actually exists in <code>MESA}.

<div class="terminal-title"> Terminal commands </div> 
<div class="terminal"><p>
cd $MESA_DIR
grep -rI D_mix star/private
</p></div>

When typing in these commands, you should eventually see the following output 

<div class="terminal-title"> Terminal output </div> 
<div class="terminal"><p></pre class=pre-terminal>
...
star/private/mix_info.f90:  s% D_mix(k) = 0d0
star/private/mix_info.f90:  s% D_mix(k) = s% conv_vel(k)*s% mixing_length_alpha*s% Hp_face(k)/3d0
star/private/mix_info.f90:  s% cdc(k) = cdc_factor(k)*s% D_mix(k)
star/private/mix_info.f90:  s% D_mix(k) = s% mlt_D(k)
star/private/mix_info.f90:  if (s% set_min_D_mix .and. s% ye(nz) >= s% min_center_Ye_for_min_D_mix) then
star/private/mix_info.f90:  if (s% D_mix(k) >= s% min_D_mix) cycle
star/private/mix_info.f90:  if (s% m(k) > s% mass_upper_limit_for_min_D_mix*Msun) cycle
star/private/mix_info.f90:  if (s% m(k) < s% mass_lower_limit_for_min_D_mix*Msun) cycle
star/private/mix_info.f90:  s% D_mix(k) = s% min_D_mix
...
</pre></p></div>

As seen in the output above, there is indeed a parameter in <code>MESA} called <code>D_mix} that we should be able to access using the <code>star_info} pointer <code>s%}. Lets try to use this in our <code>my_other_D_mix} subroutine and change the diffusive mixing coefficient to be some fixed value throughout the star. In order to do so, we first have to let our <code>my_other_D_mix} subroutine have access to the information in <code>star_info} and define an integer <code>k} for run a do loop over. In order for this to work, your <code>my_other_D_mix} subroutine should look something like this

<div class="filetext-title"> run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
      subroutine my_other_D_mix(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         integer :: k
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return

         print *, 'I am using my_other_D_mix'
         
         do k=1, s% nz
            s% D_mix(k) = 
         end do

      end subroutine my_other_D_mix
</pre></p></div>

Notice that we a running a <code>do} loop from the outermost cell (<code>k=1}) to the inner mesh grid point (<code>s% nz}) and changing the value of <code>D_mix} throughout the stellar model. <br>

<task><details>
<summary>Task 5</summary><p>
Implement the changes to your <code>my_other_D_mix} subroutine listed above and set the diffusive mixing coefficient <code>D_mix} to be $10^4$ throughout the star. Recompile and run <code>MESA}. What happens to your <code>pgstar} mixing window?
</p></details></task>

Currently, it looks like the diffusive mixing coefficient is only being changed inside the convective core and the overshooting region, and is now constant in both regions. Let's double check if anything is happening to the profile in the radiative envelope.<br>

<task><details>
<summary>Task 6</summary><p>
If you haven't done so already in bonus exercise 1 of Minilab 2, then copy <code>profile_columns.list} from <code>$MESA_DIR/star/defaults/} to your <code>SPB_maxilab} work directory. Make sure that <code>brunt_N2}, <br> <code>brunt_N2_structure_term}, <code>brunt_N2_composition_term}, and <code>log_D_mix} are included as output. Then add the following to <code>inlist_pgstar}:

<code>Profile_Panels1_win_flag = .true.</code><br> 
<code>Profile_Panels1_num_panels = 3</code><br> 
<code>Profile_Panels1_yaxis_name(1) = 'brunt_N2'</code><br>
<code>Profile_Panels1_other_yaxis_name(1) = ''</code><br>
<code>Profile_Panels1_yaxis_name(2) = 'brunt_N2_structure_term'</code><br> <code>Profile_Panels1_other_yaxis_name(2) = 'brunt_N2_composition_term'</code><br> 
<code>Profile_Panels1_yaxis_name(3) = 'log_D_mix</code><br> <code>Profile_Panels1_other_yaxis_name(3) = ''</code><br> <code>Profile_Panels1_file_flag = .true.</code><br> <code>Profile_Panels1_file_dir = 'png'</code><br>
<code>Profile_Panels1_file_prefix = 'profile_panels1_1.0mdc_1.0tdc_'</code><br>
<code>Profile_Panels1_file_width = 12</code><br>
<code>Profile_Panels1_file_aspect_ratio = 0.75</code>
</p></details></task>

When you now run <code>MESA}, you should see that although nothing seems to be happening in the envelope according to the <code>pgstar} mixing window, then the mixing profile is indeed constant throughout the star. In other words, <code>MESA} is doing what we are telling it to do. This is because our ``new'' mixing profile has not been assigned a mixing type. For an overview of what different types are available, have a look <code>$MESA_DIR/const/public/const_def.f90}.

<div class="filetext-title"> $MESA_DIR/const/public/const_def.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
...
! mixing types
! NOTE: some packages may depend on the order
integer, parameter :: crystallized = -1
integer, parameter :: no_mixing = 0
integer, parameter :: convective_mixing = 1
integer, parameter :: overshoot_mixing = 2
integer, parameter :: semiconvective_mixing = 3
integer, parameter :: thermohaline_mixing = 4
integer, parameter :: rotation_mixing = 5
integer, parameter :: rayleigh_taylor_mixing = 6
integer, parameter :: minimum_mixing = 7
integer, parameter :: anonymous_mixing = 8  ! AKA "WTF_mixing"
integer, parameter :: leftover_convective_mixing = 9  
...
</pre></p></div>

All of these integer values for the different mixing types are contained within the <code>s% mixing_type(:)} parameter. In other words, a region where <code>s% mixing_type(k) = 1} has convective mixing. For now, lets set the envelope mixing to correspond to the minimum mixing, i.e. <code>s% mixing_type(k) = 7}. To do so, we first have to activate the minimum mixing in <code>MESA}.<br>

<task><details>
<summary>Task 7</summary><p>
In <code>inlist_project} set the parameter <code>set_min_D_mix = .true.} and tell <code>MESA} to use 0.1 as the minimum diffusive mixing coefficient. Make sure that <code>mixing_type} is included as a profile output, and include it in <code>inlist_pgstar} as <code>Profile_Panels1_other_yaxis_name(3)}. Then run <code>MESA}.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
The parameter used to set the minimum mixing value is called <code>min_D_mix}.
</p></details></hint>

You should now see the envelope mixing, i.e. minimum mixing, appears as an orange line in your <code>pgstar} mixing window. 

So far we have been completely overwriting the mixing profile throughout the star to a constant value, even inside the convective regions. So even though we are telling <code>MESA} to do something silly, it is still running and trying to find a solution! What we want to do is only change the mixing profile in the radiative envelope, i.e. avoid regions where we have convective mixing and overshoot mixing.<br> 

<task><details>
<summary>Task 8</summary><p>
Modify your <code>my_other_D_mix} subroutine to only change the mixing profile when no convective or diffusive overshoot mixing is happening. You can do so using an <code>if} statement inside your <code>do} loop.
</p></details></task>

In Fortran, <code>if} statements are written in the format

<div class="filetext-title"> if statements </div> 
<div class="filetext"><p><pre class=pre-filetext>
if ((one condition) .and. (another condition)) then
    Do something
endif
</pre></p></div>

You can also use such <code>if} statements to exit a <code>do}-loop once a condition has been met

<div class="filetext-title"> if condition then do something and exit do-loop </div> 
<div class="filetext"><p><pre class=pre-filetext>
do k=1, s% nz
    if (a condition) then
        Do something
        exit
    endif
end do
</pre></p></div>

<code>Fortran} has three logical operators: <code>.and.}, <code>.or.}, and <code>.not.</code><br> 
Additional useful comparison operators are given in the table below

\begin{center}
\small
\begin{tabular}{|l|c|c|}
\hline
Condition  & <code>Fortran} text form  & <code>Fortran} symbol form
\hline
 equal to & <code>.eq.} & <code>==</code><br> [1ex]
 not equal to &  <code>.ne.} & <code>/=</code><br> [1ex]
 greater than &  <code>.gt.} & <code>></code><br> [1ex]
 less than &  <code>.lt.} & <code><</code><br> [1ex]
 greater or equal to &  <code>.ge.} & <code>>=</code><br> [1ex]
 less or equal to &  <code>.lt.} & <code><=</code><br> [1ex]
\hline
\end{tabular}
\end{center}

Knowing these will be useful in the following steps as well and whenever you want to add things to your <code>run_star_extras.f90} in general. 

Notice that right now there is a discontinuity in our mixing profile when we go from overshoot to minimum mixing. We want to get rid of this discontinuity by modifying our <code>my_other_D_mix} subroutine to automatically change the diffusive mixing coefficient to $10^4$ when the original diffusive mixing profile drops below this value. We will do so in a bit of a round-about way to prepare us for the actual envelope mixing profile that we want to adopt.<br>

<task><details>
<summary>Task 9</summary><p>
Declare a new integer parameter <code>k0} inside your <code>my_other_D_mix} subroutine. This parameter will define the first cell number where <code>D_mix < $10^4$} when going from the core to the surface. Add an additional <code>do}-loop before your first one and use an <code>if} statement to find the value of <code>k0}. Then modify your second <code>do}-loop to run to <code>k0} instead of <code>s% nz} and change the diffusive mixing coefficient to $10^4$ if the region is not convective. Likewise set the <code>mixing_type} to 7.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
Use the ``<code>if} condition then do something and exit <code>do}-loop'' example given above for the first <code>do}-loop and set <code>(a condition)} to <code>(s% D_mix(s% nz - k) .lt. 1d4)} and the <code>Do something} to <code>k0 = s% nz - k}. Then in the second <code>do}-loop change <code>do k=1, s% nz} to <code>do k=1, k0}.
</p></details></hint>

<task><details>
<summary>Task 10</summary><p>
As a bonus, look up what the inlist control parameter <code>x_ctrl} does. Use this to set $10^4$ value in the envelope inside your <code>inlist_project} instead of <code>run_star_extras.f90}. This will allow us to vary this parameter without having to change <code>run_star_extras.f90} every time.
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
You want to set <code>x_ctrl(1) = 1d4} inside <code>inlist_project} under <code>&controls} and then call it in <code>run_star_extras.f90} using <code>s% x_ctrl(1)}.
</p></details></hint>

Once you have made the above changes then run <code>MESA}. The current version of your <code>my_other_D_mix} subroutine should look something like this

<div class="filetext-title"> run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
subroutine my_other_D_mix(id, ierr)
    integer, intent(in) :: id
    integer, intent(out) :: ierr
    type (star_info), pointer :: s
    integer :: k, k0
    ierr = 0
    call star_ptr(id, s, ierr)
    if (ierr /= 0) return
         
    print *, 'I am using my_other_D_mix'
         
    ! Find k0
    do k=1, s% nz
      if (s% D_mix(s% nz - k) .lt. s% x_ctrl(1)) then
        k0 = s% nz - k
        exit
      end if
    end do
         
    ! Change mixing profile in the envelope, avoiding convective zones
    do k=1, k0
      if (s% mixing_type(k) .ne. 1) then
        s% D_mix(k) = s% x_ctrl(1)
        s% mixing_type(k) = 7
      endif
    end do
         
end subroutine my_other_D_mix
</pre></p></div>

With the current version of our <code>my_other_D_mix} subroutine we could achieve the exact same result by just varying the parameter <code>min_D_mix} inside <code>inlist_project}. Now as a final step, we are going to change the envelope mixing profile to be a function of the density profile using 

\begin{equation}
    D_{\rm env} (r) = D_{\rm env, 0} \left[\frac{\rho (r)}{\rho_{0}} \right]^{-n}.
    \label{Eq:D_env}
\end{equation}

In this equation $D_{\rm env, 0}$ corresponds to <code>x_ctrl(1)}. $n$ is another free parameter that we want to be able to set in our <code>inlist_project} file. $\rho (r)$ is the density and $\rho_{0}$ is the density at <code>k0}. <br>

<task><details>
<summary>Task 11</summary><p>
Set $n = \frac{1}{2}$ and $D_{\rm env, 0} = 100$, then implement Eq.~(\ref{Eq:D_env}) in your <code>my_other_D_mix} subroutine. Run both <code>MESA} and <code>GYRE}. How does this addition of envelope mixing change your period spacing pattern?
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
To figure out what parameter <code>MESA} is using for the density have a look at the file
<code>$MESA_DIR/star_data/public/star_data_step_work.inc}.
</p></details></hint>

<hint><details>
<summary> Hint </summary><p>
Use the parameter <code>x_ctrl(2)} to set $n$ in <code>inlist_project}.
</p></details></hint>

<hint><details>
<summary> Hint </summary><p>
While not required to implement the equation above, you can look up known <code>MESA} <code>Fortran} functions in <code>$MESA_DIR/math/public/math_lib_crmath.f90} which may be useful.
</p></details></hint>

Now that we have the internal mixing profile setup, the final step is making sure that we have all of the output that we need for comparisons. We already have our setup for computing the <code>GYRE} models from minilab 2 to look at the impact on the period spacing patterns. In addition to this, we want to look at the impact on the surface abundances of $^{4}$He, $^{12}$C, $^{14}$N, and $^{16}$O. More specifically, we want to look at how different they are from their values at the ZAMS. We could just do this by looking at our standard history output and modify our <code>history_columns_list} file, but we can make things a bit easier for ourselves by including these as extra history output in <code>run_star_extras.f90}. The values that we want to look at are of the format

\begin{equation}
    \text{current to ZAMS }^4\text{He} = \frac{\text{current surface}\ ^4\text{He}}{\text{surface}\ ^4\text{He at ZAMS}}.
\end{equation}

To do this, we are going to modify four separate parts of the <code>run_star_extras.f90} file: 

\begin{enumerate}%[\indent(1)]
    \item Add parameters at the very beginning of <code>run_star_extras.f90}
    \item Set these parameter values in the subroutine <code>extras_startup}
    \item Tell <code>MESA} the number of extra history output columns to include in the function <code>how_many_extra_history_columns}
    \item Name and assign the extra history output data in the subroutine <code>data_for_extra_history_columns}.
\end{enumerate}

Let's start by using $^4$He as an example. We want to save the initial ZAMS value of $^4$He at the surface of the star so it does not get overwritten at each time step when we run <code>MESA}. We will call this parameter <code>initial_surface_he4} and define it at the top of our <code>run_star_extras.f90} file right after the line <code>implicit none}. We want to declare this parameter as a real number with double precision.

<div class="filetext-title"> run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
...

module run_star_extras

use star_lib
use star_def
use const_def
use math_lib
      
      
implicit none

real(dp) :: initial_surface_he4
      
! these routines are called by the standard run_star check_model
contains

...
</pre></p></div>

In this way, <code>run_star_extras.f90} will recognise this parameter everywhere without us having to declare it again. Currently we haven't given this new parameter <code>initial_surface_he4} a value. To do so, we want to get the initial surface $^4$He value before <code>MESA} starts taking any time steps. We can do so in the subroutine <code>extras_startup}

<div class="filetext-title"> run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
subroutine extras_startup(id, restart, ierr)
    integer, intent(in) :: id
    logical, intent(in) :: restart
    integer, intent(out) :: ierr
    type (star_info), pointer :: s
    ierr = 0
    call star_ptr(id, s, ierr)
    if (ierr /= 0) return

    initial_surface_he4 = s% surface_he4
                  
end subroutine extras_startup
</pre></p></div>

Note that while the parameter for the surface $^4$He mass fraction is called <code>surface he4} in your <code>history_columns.list} file, it is called <code>surface_he4} internally in <code>MESA}.

Now that we have saved the initial surface $^4$He mass fraction, our next steps are to tell <code>MESA} how many extra history output columns we want to add to our <code>history.data} output file. We do so inside the function <code>how_many_extra_history_columns} by modifying the parameter by the same name.

<div class="filetext-title"> run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
integer function how_many_extra_history_columns(id)
    integer, intent(in) :: id
    integer :: ierr
    type (star_info), pointer :: s
    ierr = 0
    call star_ptr(id, s, ierr)
    if (ierr /= 0) return
    how_many_extra_history_columns = 1
end function how_many_extra_history_columns
</pre></p></div>

Note that if you compile and run <code>MESA} now before assigning the extra history column a name and value, then you will start to receive a warning in the terminal but it won't stop <code>MESA} from running. 

<div class="terminal-title"> Terminal output </div> 
<div class="terminal"><p>
Warning empty history name for extra_history_column            1
</p></div>

Now, to give the extra history column a name and a value we need to add the parameters <code>names(n)} and <code>vals(n)} to the subroutine <code>data_for_extra_history_columns}. Here <code>n} is the number of the added history column. So if you want to add two extra history columns you need to assign both <code>names(1)} and <code>vals(1)} as well as <code>names(2)} and <code>vals(2)}. To calculate the ratio between the current surface $^4$He mass fraction and the initial ZAMS value, we can now do so by using our two parameters <code>s% surface_he4} and <code>initial_surface_he4}. We will call this ratio <code>current_to_zams_surf_he4}.

<div class="filetext-title"> run_star_extras.f90 </div> 
<div class="filetext"><p><pre class=pre-filetext>
subroutine data_for_extra_history_columns(id, n, names, vals, ierr)
    integer, intent(in) :: id, n
    character (len=maxlen_history_column_name) :: names(n)
    real(dp) :: vals(n)
    integer, intent(out) :: ierr
    type (star_info), pointer :: s
    ierr = 0
    call star_ptr(id, s, ierr)
    if (ierr /= 0) return
         
    ! note: do NOT add the extras names to history_columns.list
    ! the history_columns.list is only for the built-in history column options.
    ! it must not include the new column names you are adding here.
         
    names(1) = 'current_to_zams_surf_he4'
    vals(1) = s% surface_he4 / initial_surface_he4
         
end subroutine data_for_extra_history_columns
</pre></p></div>

<task><details>
<summary>Task 12</summary><p>
Following the example above, modify your <code>run_star_extras.f90} to include the ratios of the current to initial ZAMS mass fraction of $^4$He, $^{12}$C, $^{14}$N, and $^{16}$O to your output <code>history.data} file. Compile and run <code>MESA} to make sure your modifications work.
</p></details></task>

Once you have updated your <code>run_star_extras.f90} you can also keep track of how these ratios change throughout the evolution of the star by including a [history panels <code>pgstar</code>](https://docs.mesastar.org/en/release-r23.05.1/reference/pgstar.html#history-panels) window.<br>

<task><details>
<summary>Task 13</summary><p>
Add the following to your <code>inlist_pgstar} file:<br>
<code>History_Panels1_win_flag = .true.</code><br> 
<code>History_Panels1_num_panels = 2</code><br> 
<code>History_Panels1_yaxis_name(1) = 'current_to_zams_surf_n14'</code><br> 
<code>History_Panels1_other_yaxis_name(1) = 'current_to_zams_surf_he4'</code><br> 
<code>History_Panels1_yaxis_name(2) = 'current_to_zams_surf_c12'</code><br> 
<code>History_Panels1_other_yaxis_name(2) = 'current_to_zams_surf_o16'}</code><br> 
</p></details></task>

Now we have our <code>MESA} setup done for the Maxilab and it is time to vary some parameters and investigate the effect of envelope mixing on both the period spacing patterns and the surface abundances.<br>

<task><details>
<summary>Task 14</summary><p>
In this final task of the Maxilab, there are four of your inlist parameters that you will have to change/vary. Those are: <code>filename_for_profile_when_terminate}, <code>log_directory}, <code>x_ctrl(1)}, and <code>x_ctrl(2)}. The steps you have to take are as follows:}


\begin{enumerate}
\color{teal}
    \item Go to the <a href="https://docs.google.com/spreadsheets/d/1KrAoaLLOtSo-p8H_E2XO77FEUni6PugNR7jKK6_I71c/edit#gid=1105905148">Google spreadsheet</a> and claim a $D_{\rm env,0}$ and $n$ value by putting your name down in the left most column.
    \item Change <code>log_directory} to be of the format <code>'LOGS/4Msun_0.01fov_\#Denv0_\#n'} and also change the parameter <code>filename_for_profile_when_terminate} accordingly.
    \item Set <code>overshoot_f(1) = 0.01}
    \item Set <code>x_ctrl(1)} and <code>x_ctrl(2)} to your chosen $D_{\rm env,0}$ and $n$.
    \item Run <code>MESA} then <code>GYRE}.
    \item Check your output <code>history.data} file and note down the last recorded value of <code>current_to_zams_surf_he4}, <code>current_to_zams_surf_c12}, <code>current_to_zams_surf_n14}, and <code>current_to_zams_surf_o16} in the corresponding columns <code>tams_to_zams_surface_he4}, <code>tams_to_zams_surface_c12}, <code>tams_to_zams_surface_n14}, and <code>tams_to_zams_surface_o16} in the Google spreadsheet.
    \item Have your TA plot the corresponding period spacing pattern.
\end{enumerate}
</p></details></task>

<hint><details>
<summary> Hint </summary><p>
Remember that you will also have you update your <code>gyre.in} file for the new LOGS directory names.
</p></details></hint>

As you are adding in your parameters in the Google spreadsheet, keep an eye on how the plots for the different mass fractions are changing. At what value of $D_{\rm env,0}$ do you start to see a change in the surface abundances? How does this depend on the choice of $n$?