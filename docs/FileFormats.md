# Project creation configuration (JSON)
As an alternative to manually creating a project via the web interface, projects can be created from a JSON
configuration file. You can find an example at
[cdc-project.json](https://github.com/reichlab/forecast-repository/blob/master/forecast_app/tests/projects/cdc-project.json).


# Score download format (CSV)
There is one column per ScoreValue BUT: all Scores are on one line. Thus, the row `key` is the (fixed) first five 
columns:

        `ForecastModel.abbreviation | ForecastModel.name , TimeZero.timezero_date, season, Location.name, Target.name`

    Followed on the same line by a variable number of ScoreValue.value columns, one for each Score. Score names are in
    the header. An example header and first few rows:

        model,           timezero,  season,    location,  target,          constant score,  Absolute Error
        gam_lag1_tops3,  20170423,  2017-2018  TH01,      1_biweek_ahead,  1                <blank>
        gam_lag1_tops3,  20170423,  2017-2018  TH01,      1_biweek_ahead,  <blank>          2
        gam_lag1_tops3,  20170423,  2017-2018  TH01,      2_biweek_ahead,  <blank>          1
        gam_lag1_tops3,  20170423,  2017-2018  TH01,      3_biweek_ahead,  <blank>          9
        gam_lag1_tops3,  20170423,  2017-2018  TH01,      4_biweek_ahead,  <blank>          6
        gam_lag1_tops3,  20170423,  2017-2018  TH01,      5_biweek_ahead,  <blank>          8
        gam_lag1_tops3,  20170423,  2017-2018  TH02,      1_biweek_ahead,  <blank>          6
        gam_lag1_tops3,  20170423,  2017-2018  TH02,      2_biweek_ahead,  <blank>          6
        gam_lag1_tops3,  20170423,  2017-2018  TH02,      3_biweek_ahead,  <blank>          37
        gam_lag1_tops3,  20170423,  2017-2018  TH02,      4_biweek_ahead,  <blank>          25
        gam_lag1_tops3,  20170423,  2017-2018  TH02,      5_biweek_ahead,  <blank>          62

    Notes:
    - `season` is each TimeZero`s containing season_name, similar to Project.timezeros_in_season().
    -  for the model column we use the model`s abbreviation if it`s not empty, otherwise we use its name
    - NB: we were using get_valid_filename() to ensure values are CSV-compliant, i.e., no commas, returns, tabs, etc.
      (a function that was as good as any), but we removed it to help performance in the loop
    - we use groupby to group row `keys` so that all score values are together


# Truth data format (CSV)
- CSV format
- A header must be included
- One csv file/project, which includes timezeros across all seasons
- columns: `timezero`, `location`, `target`, `value`
- timezeros are formatted `yyyymmdd`
- For date-based onset or peak targets, values must be dates in the same format as timezeros, rather than
  project-specific time intervals such as an epidemic week.
- Validation:
    - Every timezero in the csv file must have a matching one in the project. Note that the inverse is not necessarily
      true, such as in the case above of missing timezeros.
    - Every location in the csv file must a matching one in the Project.
    - Ditto for every target.


# Forecast data format (JSON)
For prediction input and output we use a dictionary structure suitable for JSON I/O. The dict is called a"JSON IO dict"
in code documentation. See predictions-example.json for an example. Functions that accept a `json_io_dict` include:
- `load_predictions_from_json_io_dict()`.

Functions that return a `json_io_dict` include:
- `json_io_dict_from_forecast()` and
- `json_io_dict_from_cdc_csv_file()`.

This format is strongly inspired by https://github.com/cdcepi/predx/blob/master/predx_classes.md .

Briefly, the dict has four top level keys:
- `forecast`: a metadata dict about the file`s forecast. has these keys: `id`, `forecast_model_id`, `source`,
  `created_at`, and `time_zero`. Some or all of these keys might be ignored by functions that accept a JSON IO dict.
- `locations`: a list of "location dicts", each of which has just a `name` key whose value is the name of a location in
  the below `predictions` section.
- `targets`: a list of "target dicts", each of which has the following fields. The fields are: `name`, `description`,
  `unit`, `is_date`, `is_step_ahead`, and `step_ahead_increment`.
- `predictions`: a list of "prediction dicts" that contains the prediction data. Each dict has these fields:
  = `location`: name of the Location
  = `target`: "" the Target
  = `class`: the type of prediction this is. It is an abbreviation of the corresponding Prediction subclass - the names
    are from `PREDICTION_CLASS_TO_JSON_IO_DICT_CLASS`: `BinCat`, `BinLwr`, `Binary`, `Named`, `Point`, `Sample`, and 
    `SampleCat`.
  = `prediction`: a class-specific dict containing the prediction data itself. the format varies according to class. See
    https://github.com/cdcepi/predx/blob/master/predx_classes.md for details. Here is a summary:
    + `BinCat`: Binned distribution with a category for each bin. is a two-column table represented by two keys, one per
      column: `cat` and `prob`. They are paired, i.e., have the same number of rows
    + `BinLwr`: Binned distribution defined by inclusive lower bounds for each bin. Similar to `BinCat`, but has these
      two keys: `lwr` and `prob`.
    + `Binary`: Binary distribution with a single `prob` key.
    + `Named`: A named distribution with four fields: `family` and `param1` through `param3`. `family` names must be
      one of those in `FAMILY_CHOICE_TO_ABBREVIATION`: `norm`, `lnorm`, `gamma`, `beta`, `bern`, `binom`, `pois`,
      `nbinom`, and `nbinom2`.
    + `Point`: A numeric point prediction with a single `value` key.
    + `Sample`: Numeric samples represented as a table with one column that is found in the `sample` key.
    + `SampleCat`: Character string samples from categories. Similar to `BinCat`, but has these two keys: `cat` and 
      `sample`.
