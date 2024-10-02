batch.land.use.summarize.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/batch.land.use.summarize.R
# If given the location of a directory containing SURO, AGWO, and IFWO combined land use files,
# this function will combine the different files and land uses to create one file with all
# land use data.  This function should be run on the deq2 server.

batch_Qout_summarize.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/batch_Qout_summarize.R
# If given the location of a directory containing surface runoff flow files (0111), 
# this function will create a file containing the mean flows of all the river segments in this
# directory.  This function should be run on the deq2 server.

Download_Runit_and_Qout_Data.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/Download_Runit_and_Qout_Data.R
# Downloads Runit and Qout data from VA Hydro for each of the river segments investigated in
# this thesis.

flow_exceedance_comparison.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/flow_exceedance_comparison.R
# This is an example script to exhibit how to download data for the same river segment for a number
# of different VA Hydro scenarios, and to then create flow exceedance plots comparing these
# different scenarios.

gage_comparison_thesis.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/gage_comparison_thesis.R
# For the river segments analyzed in this thesis, this script will link river segments to their
# associated USGS gages, download data, and compare model fits.  Kable tables, compatible with
# Overleaf, will also be created.

land.use.timeseries.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/land.use.timeseries.R
# For the land uses cursorily investigated in this thesis research, this function will sum SURO,
# AGWO, and IFWO flows for each land use and create timeseries of these summed data.  This function
# should be run on the deq2 server.

land_use_radar_charts.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/land_use_radar_charts.R
# Following the creation of the pct.changes scenario data frames, this script will create radar
# charts showing the land use unit flows for each land use group.

mods.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/mods.R
# Using the GCM data now stored in GCM Precipitation Data and GCM Temperature Data directories, this
# script will determine which model is associated with the tenth, fiftieth, and ninetieth percentiles
# of precipitation and temperature for each land segment in the area of study.

prcp.evap.landuse.table.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/prcp.evap.landuse.table.R
# Creates pct.changes scenario dataframes.  Also, creates plots of evaporation against precipitation,
# precipitation/evaporation against land use, maps of evaporation/precipitation/land use/temperature change,
# and longitude/latitude against these changes.

precip_and_temp_latitude_by_model.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_latitude_by_model.R
# Creates plots of temperature/precipitation against latitude/longitude, with the used GCMs designated
# by color and described in the legends of the generated images.

precip_and_temp_mapper.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_mapper.R
# Creates monthly maps of temperature and precipitation

precip_and_temp_mapper_vahydro.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_mapper_vahydro.R
# Creates many versions of temperature and precipitation maps, some of which have a more presentable
# layout for use in reports and presentations.

precip_and_temp_model_frequency.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_model_frequency.R
# Calculates the frequency of GCMs appearing in the tenth, fiftieth, and ninetieth percentile of each
# model scenario, by land segment.

precip_and_temp_scenario_analysis.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_scenario_analysis.R
# Determines how GCMs are assigned to the climate change scenarios (conclusion: by land segment)

precip_and_temp_vs_Qout_plots_and_regressions.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_vs_Qout_plots_and_regressions.R
# Creates plots of changes between GCM temperature and precipitation inputs and resultant VA Hydro 
# model precipitation, evapotranspiration, and surface runoff (Qout) flows.

precip_and_temp_vs_Qout_tables.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_and_temp_vs_Qout_tables.R
# Creates output .csv files describing GCM precipitation and temperature as well as climate change 
# scenario precipitation, evapotranspiration, and flow quantity/change from baseline scenario.

precip_evap_landuse_PCA.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/precip_evap_landuse_PCA.R
# Creates principal component analysis plots describing correlations between precipitation/temperature
# and land use unit runoff values.

qunit_boxplot.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/qunit_boxplot.R
# Creates boxplots and kable tables (for Overleaf) describing flow per unit area for each of the 
# river segments and major basins described within this thesis.  Additionally, creates flow
# exceedance plots describing these climate change scenarios.  Also, calculates flow metrics of 
# choice and outputs kable tables of raw values and percent changes from baseline scenario.

rcp_plotter.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/rcp_plotter.R
# Using the RCP data stored in the Relative Concentration Pathway Data repository, a line graph of
# this data over time is created.

runit_all_scens.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/runit_all_scens.R
# Creates maps of unit runoff (Runit) flows and creates kable tables (for Overleaf) describing these
# raw runoff values and percent differences from the baseline scenario.

runoff_boxplots.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/runoff_boxplots.R
# Creates boxplots of unit runoff (Runit) values, previously downloaded using the 
# "Download_Runit_and_Qout_Data" script.  Additionally, calculates median and mean percent 
# changes and calculates quantiles of percent runoff changes.

runoff_regime.R
https://github.com/HARPgroup/cbp6/blob/master/daniel's%20thesis%20scripts/runoff_regime.R
# Downloads land use data from the deq2 server. Creates percent exceedance plots for some select
# land use runoff timeseries.