# File Formats

Zoltar uses a number of formats for representing truth data, forecasts, configurations, etc. This page documents those.

- [Project creation configuration (JSON)](#project-creation-configuration-json)
- [Truth data format (CSV)](#truth-data-format-csv)
- [Score download format (CSV)](#score-download-format-csv)
- [Forecast data format (JSON)](#forecast-data-format-json)
- [Quantile forecast format (CSV)](#quantile-forecast-format-csv)


## Project creation configuration (JSON)

As documented in [Projects](Projects.md#to-create-a-project-via-a-configuration-file), as an alternative to manually creating a project via the web interface, projects can be created from a JSON configuration file. Here's the configuration file from the "Docs Example Project" demo project: [zoltar-project-config.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-project-config.json).

Project configuration files contain eight metadata keys (`"name`, `"is_public"`, `"description"`, `"home_url"`, `"logo_url"`, `"core_data"`, `"time_interval_type"`, `"visualization_y_label"`), plus three keys that are lists of objects (`"units"`, `"targets"`, and `"timezeros"`). The metadata values' meanings are self-evident except for these two:

- `time_interval_type`: Used by the D3 component to label the X axis, is either `Week`, `Biweek`, or `Month`
- `visualization_y_label`: "" Y axis, can be any text


Here are the three list objects' formats:

**"units"**: a list of objects containing only one field:

- `name`: The name of the unit.


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

Every project in Zoltar can have ground truth values associated with targets. This information is required for Zoltar to do scoring. Users can access them as CSV as described in [Truth](Truth.md). An example truths file is [zoltar-ground-truth-example.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-ground-truth-example.csv). The file has four columns: `timezero`, `unit`, `target`, `value`:

- `timezero`: date the truth applies to, formatted as `yyyy-mm-dd`
- `unit`: the unit's name
- `target`: target name
- `value`: truth value, formatted according to the target's type. date values are formatted `yyyy-mm-dd` and booleans as `true` or `false`
 

## Score download format (CSV)

Zoltar calculates scores for all projects in the archive if they meet the requirements specified in [Scoring](Scoring.md#scoring-requirements). Users can download them as CSV through the web UI. The file has five fixed columns plus one column for each [implemented score](Scoring.md#current-scores). Score names are in the header. Here is an example header and a few rows:

    model,timezero,season,location,target,error,abs_error,log_single_bin,log_multi_bin,pit
    BMA,20171023,2017-2018,HHS Region 1,Season peak percentage,1.9,1.9,-5.34357208776754,-2.76546821334079,0.9777734401
    BMA,20171023,2017-2018,HHS Region 1,1 wk ahead,-0.2,0.2,-1.73188807219066,-0.0198524421369183,0.3452268498
    BMA,20171023,2017-2018,HHS Region 1,2 wk ahead,-0.0999999999999999,0.0999999999999999,-1.82712761306585,-0.0323377750120003,0.4673084875
    BMA,20171023,2017-2018,HHS Region 1,3 wk ahead,-0.1,0.1,-2.20819351679503,-0.14128307370904,0.393643899
    BMA,20171023,2017-2018,HHS Region 1,4 wk ahead,0.0,0.0,-2.21949472646195,-0.146689467362866,0.532728928
    BMA,20171023,2017-2018,HHS Region 2,Season peak percentage,6.2,6.2,-9.65891133061945,-7.26101605782108,0.998308013
    BMA,20171023,2017-2018,HHS Region 2,1 wk ahead,0.0,0.0,-6.21796372223555,-0.55145601008177,0.9919600412
    BMA,20171023,2017-2018,HHS Region 2,2 wk ahead,0.0,0.0,-2.45422343139561,-0.270984128983646,0.504271003
    BMA,20171023,2017-2018,HHS Region 2,3 wk ahead,0.4,0.4,-3.10357809725514,-0.598672167592193,0.8944900092
    BMA,20171023,2017-2018,HHS Region 2,4 wk ahead,0.4,0.4,-6.42663862873283,-0.156176129883708,0.9925874469


## Forecast data format (JSON)

For prediction input and output we use a JSON file format. This format is strongly inspired by https://github.com/cdcepi/predx/blob/master/predx_classes.md . See [zoltar-predictions-examples.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-predictions-examples.json) for an example. The file contains a top-level with two keys: `"meta"` and `"predictions"`. The `meta` section is unused for uploads, and for downloads contains various information about the forecast in the repository in the `"forecast"` field) plus lists of the project's `"units"` and `"targets"`.

The `"predictions"` list contains objects for each prediction, and each object contains the following four keys:

- `"location"`: name of the Location.
- `"target"`: name of the Target.
- `"class"`: the type of prediction this is. It is an abbreviation of the corresponding Prediction subclass - the names are : `bin`, `named`, `point`, and `sample`.
- `"prediction"`: a class-specific dict containing the prediction data itself. The format varies according to class. Here is a summary (see [Data model](DataModel.md) for details and examples):

    - `"bin"`: Binned distribution with a category for each bin. It is a two-column table represented by two keys, one per column: `cat` and `prob`. They are paired, i.e., have the same number of rows.
    - `"named"`: A named distribution with four fields: `family` and `param1` through `param3`. `family` names must be one of : `norm`, `lnorm`, `gamma`, `beta`, `bern`, `binom`, `pois`, `nbinom`, and `nbinom2`.
    - `"point`: A numeric point prediction with a single `value` key.
    - `"sample"`: Numeric samples represented as a table with one column that is found in the `sample` key.


## Quantile forecast format (CSV)

Zoltar libraries support importing quantile data (see [Validation.md](Validation.md) for more information) via the COVID-19 CSV format documented at [covid19-forecast-hub](https://github.com/reichlab/covid19-forecast-hub/blob/master/README.md#data-model). While this format is not supported by Zoltar itself (i.e., you cannot upload one directly - you must always upload JSON files in the [above format](#project-creation-configuration-json)), the libraries allow you to translate between the two.

Columns: The Zoltar libraries ignore all but the following, which are allowed to be in any order:

- `"target"`: a unique id for the target
- `"location"`: a unique id for the location (we have standardized to [FIPS codes](https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code)). It is translated to Zoltar's "unit" concept.
- `"type"`: one of either `"point"` or `"quantile"`
- `"quantile"`: a value between 0 and 1 (inclusive), stating which quantile is displayed in this row. if type=="point" then NA.
- `"value"`: a numeric value representing the value of the quantile function evaluated at the probability specified in quantile

See [quantile-predictions.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/quantile-predictions.csv) for an example.
