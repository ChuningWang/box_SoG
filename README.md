# box_SoG

Box Model for volume transport in the Georgia-Haro-JdF system.

The box model divides the system into 6 boxes (2 layers for each basin) and calculate the volume and salt flux based on a parametrization of salinity. Details in:

Wang, C., 2015. Oxygen budgets and productivity estimates in the Strait of Georgia from a continuous ferry-based monitoring system. Master¡¯s thesis, The University of British Columbia.

Li, M., Gargett, A. E. & Denman, K. L. 1999 Seasonal and interannual variability of estuarine circulation in a box model of the Strait of Georgia and Juan de Fuca Strait. Atmosphere-Ocean 37, 1-19

--------------------------------

Key scripts used in the box model:

odefunc_salt_v2.m -- Governing Equations of the box model.

odefunc_salt_v2_init.m -- same, for calculation of initial condition (trashed in the new version, combined with odefunc_salt_v2.m).

get_river.m, readenglishman.m, readfraser.m -- read river discharge and get the total discharge with regression.

get_sp.m -- calculate Sp based on along shore wind speed.

rk_solver.m -- 4th order Runge_Kutta Method to solve linear/nonlinear ODEs.

box_const.m -- (almost) all constants used in the box model.

box_initial.m -- calculate initial condition with climatology set-up for the real-time run.

box_rt.m -- real-time run with river discharge from get_river.m and pacific salinity from get_sp.m.


Some other useful functions and tools in tools/:

box_sep_depth.m -- discussion separation depth and its influence on the results.

box-coef.m -- get Cg*beta*rho0 (eq 1.6) using CTD measurements.

strCTD -- read STRATOGEM and JEMS CTD profiles and average weighted by hypsography.

box_plot.m -- make all the plots for the manuscript/thesis (trashed in the new version).

*** Version 1.1 ***

A tracer model is added to calculate conservative tracer flux in the system. The tracer model uses the same ODEs, and it is driven by the outputs of the salt budget model. That is, it run the tracer model, you need to run the salt budget model first and make sure it covers the time range of your tracer model. Why not integrate the tracer model into the salt budget model? Well, first, it is written long after the original scripts, it is easier just to separate them from the code 2 years ago. Second, it takes extra steps to calculate the tracer flux, may just slow down the calculation if the tracer flux is not desired.

New scripts for tracer flux:

odefunc_tracer.m -- Governing Equations of the tracer model.

box_tracer_init.m -- Similar to box_init.m, calculate initial condition with climatology set-up. For tracers, it is not necessary to run climatology first; this script mostly serves as a test case.

box_tracer.m -- Similar to box_rt.m, real-time run. Keep in mind that for tracers, it is not necessary to run climatology first. 

--------------------------------

Data as external forcing:

Fraser River discharge -- data/fraserHistorical/*.txt
Downloaded from https://wateroffice.ec.gc.ca/report/report_e.html?type=realTime&stn=08MF005
So far data from Jan 1980 to Oct 2014 are archived.
Renew the dataset from the website above to get recent data.

Englishman River discharge -- data/englishmanHistorical/*.txt
Downloaded from https://wateroffice.ec.gc.ca/report/report_e.html?type=realTime&stn=08MF005
So far data from Jan 1980 to Oct 2014 are archived.
Renew the dataset from the website above to get recent data.

Wind direction and speed from La Perouse Bank buoy station -- data/windLaperouse/c46206.csv
Downloaded from http://www.meds-sdmm.dfo-mpo.gc.ca/isdm-gdsi/waves-vagues/search-recherche/list-liste/data-donnees-eng.asp?medsid=C46206
So far data from Jan 1980 to Oct 2014 are archived.
Renew the dataset from the website above to get recent data.

--------------------------------

Run the model with following steps:

(1) Run 'box_initial.m' to determine initial condition. Get mat file 'init_cond.mat'.

(2) Run 'box_rt.m' to carry out the model with real-time boundary conditions. It requires function 'get_river.m', 'readenglishman.m', 'readfraser.m' and 'get_sp.m'. The outputs are in mat file 'salinity_flux3.mat'.

For tracer model - 

(3) Run ¡®box_tracer.m¡¯ or ¡®box_tracer_init.m¡¯ depends on you case.

*** Make sure data of forcing is renewed if the model time is after Oct 2014.

--------------------------------

Other functions are some other tries and are not polished. Attempt to calculate heat flux can be find in

/ocean/cnwang/courses/eosc511/project/code

but was discarded due to lack of essential information.

================================
Chuning Wang
2014/07/09
================================
Revision
Add section 'Data used as boundary condition' and 'Run the model with following steps'.
2015/02/12
Version 1.1
2017/08/20
================================


