# File Formats
Zoltar uses a number of formats for representing truth data, forecasts, configurations, etc. This page documents those.


## Project creation configuration (JSON)
As an alternative to manually creating a project via the web interface, projects can be created from a JSON configuration file. You can find an example at [cdc-project.json](https://github.com/reichlab/forecast-repository/blob/master/forecast_app/tests/projects/cdc-project.json). The file contains eight metadata keys (`name`, `is_public`, `description`, `home_url`, `logo_url`, `core_data`, `time_interval_type`, `visualization_y_label`), plus three keys that are lists of objects (`locations`, `targets`, and `timezeros`). The metadata values' meanings are self-evident except for these two:

- `time_interval_type`: Either `Week`, `Biweek`, or `Month`.
- `visualization_y_label`: Used by the D3 component to label the Y axis.

Here are the three list object keys:


### `locations`
- `name`: The name of the location.


### `targets`
Please see the [Targets.md](Targets.md) file for a detailed description of target parameters and which are required. Here are all possible parameters that can be passed in a project configuration file:

- `name`: string
- `description`: string
- `type`: string - must be one of the following: "continuous", "discrete", "nominal", "binary", or "date"
- `is_step_ahead`: boolean
- `step_ahead_increment`: integer - negative, zero, or positive
- `unit`: string
- `range`: an array (list) of two numbers
- `cats`: an array (list) of one or more numbers or strings (which depends on the target's type's data type)
- `dates`: an array (list) of one or more strings in the `YYYY-MM-DD` format specified in the above file


### `timezeros`
- `timezero_date`: The timezero's date in `yyyymmdd` format.
- `data_version_date` : Optional data version date in the same format. Pass `null` if the timezero does not have one. 
- `is_season_start`: `true` if this starts a season, and `false` otherwise.
- `season_name`: Applicable when `is_season_start` is `true`, names the season, e.g., "2010-2011".


## Score download format (CSV)
Zoltar calculates scores for all projects in the archive. Users can access them as CSV through the web UI or the programmer API. The file has five columns that are always present independent of the scores available, plus one row for each specific score. Score names are in the header. Here is an example header and the first few rows:

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


## Truth data format (CSV)
Every project in Zoltar can have ground truth values associated with targets. This information is required for Zoltar to do scoring. Users can access them as CSV through the web UI or the programmer API. The data has four columns: `timezero`, `location`, `target`, `value`:

- `timezero`: date the truth applies to, formatted as `yyyy-mm-dd`
- `location`: the location's name
- `target`: target name
- `value`: truth value, formatted according to the target's type. date values are formatted `yyyy-mm-dd`. <!-- todo boolean value format? -->
 
Here's an example:

    timezero,unit,target,value
    2017-04-23,TH01,1_biweek_ahead,2
    2017-04-23,TH01,2_biweek_ahead,0
    2017-04-23,TH01,3_biweek_ahead,11
    2017-04-23,TH01,4_biweek_ahead,8
    2017-04-23,TH01,5_biweek_ahead,11


## Quantile forecast format (CSV)
Zoltar libraries support importing quantile data via the CSV format documented at 
[covid19-death-forecasts](https://github.com/reichlab/covid19-death-forecasts/blob/master/README.md#data-model). Summary:

- `target`: a unique id for the target
- `location`: a unique id for the location (we have standardized to FIPS codes)
- `location_name`: (optional) if desired to have a human-readable name for the location, this column may be specified. Note that the `location` column will be considered to be authoritative and for programmatic reading and importing of data, this column will be ignored.
- `type`: one of either `point` or `quantile`
- `quantile`: a value between 0 and 1 (inclusive), representing the quantile displayed in this row. if `type=="point"` then `NULL`.
- `value`: a numeric value representing the value of the cumulative distribution function evaluated at the specified `quantile`

Please see [Validation.md](Validation.md) for details about quantile and value data. An example is at [quantile-predictions.csv](quantile-predictions.csv).


## Forecast data format (JSON)
For prediction input and output we use a dictionary structure suitable for JSON I/O. The dict is called a`JSON IO dict` in code documentation. See [zoltar-predictions-examples.json](zoltar-predictions-examples.json) for an example.

This format is strongly inspired by https://github.com/cdcepi/predx/blob/master/predx_classes.md .

Briefly, the dict has four top level keys:

- `forecast`: a metadata dict about the file's forecast. has these keys: `id`, `forecast_model_id`, `source`, `created_at`, and `time_zero`. Some or all of these keys might be ignored by functions that accept a JSON IO dict.
- `locations`: a list of `location dicts`, each of which has just a `name` key whose value is the name of a location in the below `predictions` section.
- `targets`: a list of `target dicts`, each of which has the following fields. The fields are: `name`, `description`, `unit`, `is_date`, `is_step_ahead`, and `step_ahead_increment`.
- `predictions`: a list of `prediction dicts` that contains the prediction data. Each dict has these fields:

  - `location`: name of the Location.
  - `target`: name of the Target.
  - `class`: the type of prediction this is. It is an abbreviation of the corresponding Prediction subclass - the names are : `bin`, `named`, `point`, and `sample`.
  - `prediction`: a class-specific dict containing the prediction data itself. The format varies according to class. Here is a summary:
    - `bin`: Binned distribution with a category for each bin. It is a two-column table represented by two keys, one per column: `cat` and `prob`. They are paired, i.e., have the same number of rows.
    - `named`: A named distribution with four fields: `family` and `param1` through `param3`. `family` names must be one of : `norm`, `lnorm`, `gamma`, `beta`, `bern`, `binom`, `pois`, `nbinom`, and `nbinom2`.
    - `point`: A numeric point prediction with a single `value` key.
    - `sample`: Numeric samples represented as a table with one column that is found in the `sample` key.
