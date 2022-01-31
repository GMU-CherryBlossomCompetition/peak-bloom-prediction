# Cleaned data sets

The structure of the cleaned data files is as follows:

* _location_ location identifier (`string`)
* _lat_ (approximate) latitude of the observation (`double`).
* _long_ (approximate) longitude of the observation (`double`).
* _alt_ (approximate) altitude of the observation (`double`).
* _year_ year of the observation (`integer`).
* *bloom_date* date of peak bloom of the cherry trees (ISO 8601 date `string`). The "peak bloom date" may be defined differently for different locations.
* *bloom_doy* days since January 1st of the year until peak bloom (`integer`). January 1st is `1`.

## Data sources

### Washington, D.C. (USA)

The data in file *washingntondc.csv* has been obtained from https://www.epa.gov/climate-indicators/cherry-blossoms.
The latitude and longitude correspond to the location of the [Tidal Basin in Washington, DC](https://www.nps.gov/articles/dctidalbasin.htm) and the cherry trees are approximately at sea level (altitude 0).

The peak bloom date is defined as the day when **70%** of the Yoshino Cherry (Prunus x yedoensis) are in full bloom, as determined by the [National Park Service](https://www.nps.gov/subjects/cherryblossom/bloom-watch.htm).

###### Copyright notice

Sourced from EPA's Climate Change Indicators in the United States: https://www.epa.gov/climate-indicators/cherry-blossoms.
See the source for copyright details.

### Liestal-Weideli (Switzerland)

The data in the file *liestal.csv* is 
The cherry trees in Liestal-Weideli are of species _Prunus avium_ (wild cherry).

The peak bloom date is defined as the day when **25%** of the blossoms are in full bloom.
The date is determined by MeteoSwiss.

###### Copyright notice

Copyright by *Landwirtschaftliches Zentrum Ebenrain, Sissach and MeteoSwiss.*

- You may use this dataset for non-commercial purposes.
- You must provide the source ("Source: Landwirtschaftliches Zentrum Ebenrain, Sissach and MeteoSwiss")

### Kyoto (Japan)

The data has been obtained from http://atmenv.envi.osakafu-u.ac.jp/aono/kyophenotemp4/.
The geographical location (longitude, latitude, altitude) roughly corresponds to the Nakanoshima area of the Arashiyama Park in Kyoto, Japan.

The peak bloom date of the Prunus jamasakura is determined by a local news paper in Arashiyama (Kyoto, JP).
Data prior to 1888 is extracted from various descriptions or estimated.
See the source for details.

###### Copyright notice

Copyright holder Yasuyuki AONO (aono(at)envi.osakafu-u.ac.jp).
The data was obtained from http://atmenv.envi.osakafu-u.ac.jp/aono/kyophenotemp4/.

- Data from the 9th to the 14th centuries was acquired and analyzed by Aono and Saito (2010; International Journal of Biometeorology, 54, 211-219).
- Phenology for 15th to 21st centuries was acquired and analyzed by Aono and Kazui (2008; International Journal of Climatology, 28, 905-914).

## Additional data sets

We provide additional data sets for sites other than the main sites relevant for the competition.
You may use these time series in your modeling to help with spatial and temporal extrapolation.

### MeteoSwiss (other locations in Switzerland)

The data file *meteoswiss.csv* contains peak bloom dates for various sites across Switzerland, obtained from https://opendata.swiss/en/dataset/phanologische-beobachtungen.

###### Copyright notice

The data license is "Open use. Must provide the source."

- You may use this dataset for non-commercial purposes.
- You may use this dataset for commercial purposes.
- You must provide the source ("Source: MeteoSwiss")

### Japanese Meteorological Agency (other locations in Japan)

The data file *japan.csv* contains peak bloom dates for various sites across Japan.

The sample trees are located within a 5km radius of the location indicated in the data file.

###### Copyright notice

Source: Japan Meteorological Agency website (https://www.data.jma.go.jp/sakura/data/pdf/005.pdf).

### South Korea

The data file *south_korea.csv* contains **first flowering dates** for various sites across South Korea, curated by the Korean Meteorological Administration.

###### Copyright notice

Source: Korean Meteorological Administration.

### USA National Phenology Network

Additional data were provided by the USA National Phenology Network and the many participants who contribute to its *Nature’s Notebook* program.

###### Copyright notice

- *USA-NPN_individual_phenometrics_data.csv:*
USA National Phenology Network. 2022. Plant and Animal Phenology Data. Data type: Individual Phenometrics. 2009--2021. USA-NPN, Tucson, Arizona, USA. Data set accessed 2022-01-13 at http://doi.org/10.5066/F78S4N1V.
- *USA-NPN_status_intensity_data.csv:*
USA National Phenology Network. 2022. Plant and Animal Phenology Data. Data type: Status and Intensity. 2009--2021. USA-NPN, Tucson, Arizona, USA. Data set accessed 2022-01-13 at http://doi.org/10.5066/F78S4N1V.

