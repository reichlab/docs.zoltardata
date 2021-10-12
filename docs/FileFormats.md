# File Formats

Zoltar uses a number of formats for representing truth data, forecast data, configurations, etc. This page documents those.

- [Project creation configuration (JSON)](#project-creation-configuration-json)
- [Truth data format (CSV)](#truth-data-format-csv)
- [Forecast data format (JSON)](#forecast-data-format-json)
- [Forecast data format (CSV)](#forecast-data-format-csv)
- [Quantile forecast format (CSV)](#quantile-forecast-format-csv)


## Project creation configuration (JSON)

As documented in [Projects](Projects.md#to-create-a-project-via-a-configuration-file), as an alternative to manually creating a project via the web interface, projects can be created from a JSON configuration file. Here's the configuration file from the "Docs Example Project" demo project: [zoltar-project-config.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-project-config.json).

Project configuration files contain eight metadata keys (`"name`, `"is_public"`, `"description"`, `"home_url"`, `"logo_url"`, `"core_data"`, `"time_interval_type"`, `"visualization_y_label"`), plus three keys that are lists of objects (`"units"`, `"targets"`, and `"timezeros"`). The metadata values' meanings are self-evident except for these two:

- `time_interval_type`: Used by the D3 component to label the X axis, is either `Week`, `Biweek`, or `Month`
- `visualization_y_label`: "" Y axis, can be any text


Here are the three list objects' formats:

**"units"**: a list of objects containing two fields:

- `name`: The name of the unit.
- `abbreviation`: The unit's abbreviation.


**"targets"**: a list of the project's targets. Please see the [Targets.md](Targets.md) file for a detailed description of target parameters and which are required. Here are all possible parameters that can be passed in a project configuration file:

- `name`: string
- `description`: string
- `type`: string - must be one of the following: `continuous`, `discrete`, `nominal`, `binary`, or `date`
- `is_step_ahead`: boolean
- `step_ahead_increment`: integer - negative, zero, or positive
- `unit`: string
- `range`: an array (list) of two numbers
- `cats`: an array (list) of one or more numbers or strings (which depends on the target's type's data type)
- `dates`: an array (list) of one or more strings in the `YYYY-MM-DD` format


**"timezeros"**: a list of the projects time zeros. Each has these fields:

- `timezero_date`: The timezero's date in `yyyymmdd` format
- `data_version_date` : Optional data version date in the same format. Pass `null` if the timezero does not have one
- `is_season_start`: `true` if this starts a season, and `false` otherwise
- `season_name`: Applicable when `is_season_start` is `true`, names the season, e.g., "2010-2011"


## Truth data format (CSV)

Every project in Zoltar can have ground truth values associated with targets. Users can access them as CSV as described in [Truth](Truth.md). An example truths file is [zoltar-ground-truth-example.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-ground-truth-example.csv). The file has four columns: `timezero`, `unit`, `target`, `value`:

- `timezero`: date the truth applies to, formatted as `yyyy-mm-dd`
- `unit`: the unit's name
- `target`: target name
- `value`: truth value, formatted according to the target's type. date values are formatted `yyyy-mm-dd` and booleans as `true` or `false`
 

## Forecast data format (JSON)

For prediction input and output we use a JSON file format. This format is strongly inspired by https://github.com/cdcepi/predx/blob/master/predx_classes.md . See [zoltar-predictions-examples.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-predictions-examples.json) for an example. The file contains a top-level object with two keys: `"meta"` and `"predictions"`. The `meta` section is unused for uploads, and for downloads contains various information about the forecast in the repository in the `"forecast"` field) plus lists of the project's `"units"` and `"targets"`.

The `"predictions"` list contains objects for each prediction, and each object contains the following four keys:

- `"unit"`: name of the Unit.
- `"target"`: name of the Target.
- `"class"`: the type of prediction this is. It is an abbreviation of the corresponding Prediction subclass - the names are : `bin`, `named`, `point`, and `sample`.
- `"prediction"`: a class-specific object containing the prediction data itself. The format varies according to class. Here is a summary (see [Data model](DataModel.md) for details and examples):

    - `"bin"`: Binned distribution with a category for each bin. It is a two-column table represented by two keys, one per column: `cat` and `prob`. They are paired, i.e., have the same number of rows.
    - `"named"`: A named distribution with four fields: `family` and `param1` through `param3`. `family` names must be one of : `norm`, `lnorm`, `gamma`, `beta`, `bern`, `binom`, `pois`, `nbinom`, and `nbinom2`.
    - `"point`: A numeric point prediction with a single `value` key.
    - `"sample"`: Numeric samples represented as a table with one column that is found in the `sample` key.
    - `"quantile"`: A quantile distribution with two paired columns: `quantile` and `value`.


## Forecast data format (CSV)

Because the native Zoltar JSON format can be inconvenient to work with, the [Zoltar libraries](ApiIntro.md) provide functions to convert from JSON to a Zoltar-specific CSV format with the following columns. Each row represents a prediction of a particular type as described on [the data model page](DataModel.md). Note that because different prediction types have different contents, the frame is 'sparse': not every row uses all columns, and unused ones are empty (`""`). However, the first three columns (`unit`, `target`, and `class`) are always non-empty.

- `unit`: the prediction's unit
- `target`: "" target
- `class`: "" prediction type. one of `bin`, `named`, `point`, `sample`, and `quantile`
- `value`: used for `point` and `quantile` prediction types. empty otherwise
- `cat`: used for `bin` prediction types. empty otherwise
- `prob`: ""
- `sample`: used for `sample` prediction types. empty otherwise
- `quantile`: used for `quantile` prediction types. empty otherwise
- `family`: family name for `named` predictions. see [`Named` Prediction Elements](Validation.md#named-prediction-elements) for a list of them
- `param1`: parameter ""
- `param2`: parameter ""
- `param3`: parameter ""


## Quantile forecast format (CSV)

Zoltar libraries support importing quantile data (see [Validation.md](Validation.md) for more information) via the COVID-19 CSV format documented at [covid19-forecast-hub](https://github.com/reichlab/covid19-forecast-hub/blob/master/README.md#data-model). While this format is not a native Zoltar data format, the libraries translate between the formats. This allows users to provide CSVs that can be translated into JSON and uploaded into Zoltar.

Columns: The Zoltar libraries ignore all but the following, which are allowed to be in any order:

- `"target"`: a unique id for the target
- `"location"`: a unique id for the location (we have standardized to [FIPS codes](https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code)). It is translated to Zoltar's "unit" concept.
- `"type"`: one of either `"point"` or `"quantile"`
- `"quantile"`: a value between 0 and 1 (inclusive), stating which quantile is displayed in this row. if type=="point" then NA.
- `"value"`: a numeric value representing the value of the quantile function evaluated at the probability specified in quantile

See [quantile-predictions.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/quantile-predictions.csv) for an example.


### Retracted predictions

As mentioned in [Retracted predictions](ForecastVersions.md#retracted-predictions), Zoltar supports _retracting_ individual prediction elements (`timezero/unit/target` combinations). These are indicated in quantile CSV files by `NULL` point and quantile values (no quote marks):

- To retract a point prediction, use `NULL` for the point value.
- To retract a quantile prediction, use `NULL` for all values. All quantiles [must still be valid](Validation.md#quantile-prediction-elements), and **all** values must be `NULL`. That is, no partial `NULL`s are allowed. The quantiles themselves must still be valid.
- You can mix retractions and updated/add prediction elements in a single file.

Here's a partial example from [COVID-19 Forecast Hub](https://github.com/reichlab/covid19-forecast-hub) that contains two prediction elements - a non-retracted point and a retracted quantile:
```csv
forecast_date,target,target_end_date,location,type,quantile,value
2020-07-04,1 day ahead inc hosp,2020-07-05,US,point,NA,3020
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.01,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.025,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.05,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.1,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.15,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.2,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.25,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.3,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.35,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.4,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.45,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.5,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.55,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.6,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.65,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.7,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.75,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.8,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.85,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.9,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.95,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.975,NULL
2020-07-04,1 day ahead inc hosp,2020-07-05,US,quantile,0.99,NULL
```
