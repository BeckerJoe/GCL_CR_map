# GCL_CR_map
This program generates a hydrological map of a section of the Columbia River Basin, including the Grand Coulee Dam, Banks Lake, and USGS gauging stations. State labels are also included.

References
  
  Shapefiles:
  
    Lehner, B., Verdin, K., Jarvis, A. (2008): New global hydrography derived from spaceborne           elevation data. Eos, Transactions, 89(10): 93-94. Data available at         
      https://www.hydrosheds.org.
  
    US Census Bureau. (2021, October 8). Cartographic boundary files - shapefile. Census.gov. https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.2015.html#list-tab-1556094155 
    
    US Environmental Protection Agency, and US Geological Survey, 20150101, Gage Locations   
      (GageLoc.shp) indexed to the NHDPlus Version 2.1 stream network:  
      https://www.sciencebase.gov/catalog/item/577445bee4b07657d1a991b6
      
  Packages:
    
    H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York,
      2016.
    
    Pebesma, E., & Bivand, R. (2023). Spatial Data Science: With Applications in R. Chapman
      and Hall/CRC. https://doi.org/10.1201/9780429459016
    
    Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector Data.
      The R Journal 10 (1), 439-446, https://doi.org/10.32614/RJ-2018-009
      
    Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data
      Manipulation_. R package version 1.1.4, https://github.com/tidyverse/dplyr,
      <https://dplyr.tidyverse.org>.
      
  Dam locations:
    
    Dams of interest derived from: 
      https://www.nwd.usace.army.mil/CRWM/CR-Dams/ 
      https://nid.sec.usace.army.mil/
      https://www.bpa.gov/-/media/Aep/power/hydropower-data-studies/rmjoc-ll-report-part-ll.PDF 
    
    Coordinates derived using Google Earth and https://geohack.toolforge.org/