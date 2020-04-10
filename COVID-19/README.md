# JLang
My J learning exercises and all things J-related.

## sars-cov-2-DSEIR.ijs

This J code is mostly based upon Tyler Limkemann's Blog posting on Modeling the COVID-19 Outbreak with J:

https://datakinds.github.io/2020/03/15/modeling-the-coronavirus-outbreak-with-j

and gui code from tangentstorm's J-talks repository:

https://github.com/tangentstorm/j-talks

It is a mashup of the two references and my own glue in order to better understand the J language. I am not an epidemiologist either, and I cannot vouch for the validity of the model.

### Running the code

After you have loaded the file into J and hit run, edit the line:

```
wd 'timer 0'
```

to 

```
  wd 'timer 800'
```

and the blank gui window should start showing a matrix of color changes with WHITE=susceptible, YELLOW=exposed, RED=infectious, GREEN=recovered and BLACK=dead.

To stop it without crashing your J session, change the wd_timer value = 0, and with the cursor at the end of this line, hit CTRL-R to run it, and the gui will stop updating. You can now exit the gui window and continue working in the editor and terminal windows.

I am still working out the kinks in the call:

```
infect_display^:144 starting_pop
```

...because the timer value restarts this 144 day simulation, and so it is graphing where ever it is at in the 144 day simulation in the gui loop.


There are 144 people in the 12x12 gui matrix that should run over 144 days, but it keeps going.
I would like to make it so the matrix is in person order, so I can track an individual going through the state changes akin to a GOL (Game Of Life) simulation.
