load 'viewmat'
coinsert'jgl2'

wd 'pc Covid-19-Sim closeok'        NB. parent control (window) named 'w0'
wd 'minwh 500 500; cc g0 isidraw;'  NB. add an 'isidraw' child control named 'g0'
wd 'pshow; pmove 40 510 0 0'        NB. show the window at the given coordinates.
wd 'sm focus term'                  NB. session manager: bring terminal to front
wd 'psel Covid-19-Sim; ptop'        NB. bring our window to front

vmcc =: viewmatcc_jviewmat_   NB. viewmat to a child control

step =: render @ update       NB. each step, we'll call those two in sequence

RGB=: (#:i.8) { 0 255

DSEIR =: (0 7 6 4 2 { RGB)

update =: verb define
  im =: 12 12 $ infect^:144 starting_pop
)

render =: verb define
  DSEIR vmcc im;'g0'
  glpaint''
)

sys_timer_z_ =: step_base_
wd 'timer 0'
ppl =: 144 NB. How many people are in our simulation?

Beta  =: 0.106271    NB. The rate at which susceptible people become exposed. RPH - dependent on R0 = 2.2 3/25/2020
Sigma =: 0.066967    NB. The rate at which exposed people become infectious. RPH - (1-sigma)^10=0.5, 10 is incubation period.
Gamma =: 0.056126    NB. The rate at which infectious people recover. RPH - adjusted to 12 days, so (1-Gamma)^12=0.5.
Xi    =: 0.02284     NB. The rate at which recovered people lose immunity and become susceptible. RPH - 30 days
		     																NB. is partially based upon man on Diamond Princess who presented symptoms around 30 days otherwise made up.
R     =: 5.7         NB. How many people will 1 person infect? RPH - based on latest CDC estimate: https://wwwnc.cdc.gov/eid/article/26/7/20-0282_article 
CFR   =: 0.015       NB. Case Fatality Rate - RPH based upon 50-59 year olds and this ref.: https://www.cebm.net/covid-19/global-covid-19-case-fatality-rates/
D     =: 0.0011619   NB. Death rate per day while symptomatic - RPH 1-CFR = (1 - D)^13 - based upon 13 days to death as seen and per CDC.

NB. 1 - (1%R) equals percent of immune through vaccine or prior infection for "herd immunity"

ClosenessStdDev =: 5 % 3
ClosenessMean =: 1

rand_norm =: 3 : '(2&o. 2p1 * ? y) * %: _2 * ^. ? y'
closeness =: 4 %~ 2 %~ (+ |:) ClosenessMean + ClosenessStdDev * rand_norm (ppl,ppl) $ 0
risk =: closeness - closeness * =i.ppl 
NB. risk =: (ppl,ppl)$0

NB. 0 = Dead
NB. 1 = Susceptible
NB. 2 = Exposed
NB. 3 = Infectious
NB. 4 = Recovered
starting_pop =: 2 , (ppl - 1) $ 1

infect =: 3 : 0
 can_spread =. (1&< *. 4&>) y
 susceptible =. y = 1
 exposed     =. y = 2
 infectious  =. y = 3
 recovered   =. y = 4

 infectiousness =. can_spread ,./ . * risk

 susceptible_to_exposed =. (Beta * susceptible) * (+/ can_spread) %~ +/ |: susceptible * infectiousness
 exposed_to_infectious =. Sigma * exposed
 infectious_to_recovered =. Gamma * infectious
 infectious_to_dead =. D * infectious
 recovered_to_susceptible =. Xi * recovered
 
 1 (I.recovered_to_susceptible>?ppl$0)} 4 (I.infectious_to_recovered>?ppl$0)} 0 (I.infectious_to_dead>?ppl$0)} 3 (I.exposed_to_infectious>?ppl$0)} 2 (I.susceptible_to_exposed>?ppl$0)} y
)

infect_display =: 3 : 0
 out =. infect y
 smoutput out
 smoutput ('Susceptible';'Exposed';'Infectious';'Recovered';'Dead'),:(+/1=out);(+/2=out);(+/3=out);(+/4=out);(+/0=out)
 out
)