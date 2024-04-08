# File Formats

Zoltar uses a number of formats for representing truth data, forecast data, configurations, etc. This page documents those.

- [Project creation configuration (JSON)](#project-creation-configuration-json)
- [Truth data format (CSV)](#truth-data-format-csv)
- [Forecast data format (JSON)](#forecast-data-format-json)
- [Forecast data format (CSV)](#forecast-data-format-csv)


## Project creation configuration (JSON)

As documented in [Projects](Projects.md#to-create-a-project-via-a-configuration-file), as an alternative to manually creating a project via the web interface, projects can be created from a JSON configuration file. Here's the configuration file from the "Docs Example Project" demo project: [zoltar-project-config.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-project-config.json).

Project configuration files contain six metadata keys (`"name`, `"is_public"`, `"description"`, `"home_url"`, `"logo_url"`, `"core_data"`), plus three keys that are lists of objects (`"units"`, `"targets"`, and `"timezeros"`).


Here are the three list objects' formats:

**"units"**: a list of objects containing two fields:

- `name`: The name of the unit.
- `abbreviation`: The unit's abbreviation.


**"targets"**: a list of the project's targets. Please see the [Targets.md](Targets.md) file for a detailed description of target parameters and which are required. Here are all possible parameters that can be passed in a project configuration file:

- `name`: string
- `description`: string
- `type`: string - must be one of the following: `continuous`, `discrete`, `nominal`, `binary`, or `date`
- `outcome_variable`: string
- `is_step_ahead`: boolean
- `numeric_horizon`: integer - negative, zero, or positive
- `reference_date_type`: one of the names listed in [valid reference date types](Targets.md#valid-reference-date-types)
- `range`: an array (list) of two numbers
- `cats`: an array (list) of one or more numbers or strings (which depends on the target's type's data type)
- `dates`: an array (list) of one or more strings in the `YYYY-MM-DD` format


**"timezeros"**: a list of the projects time zeros. Each has these fields:

- `timezero_date`: The timezero's date in `YYYY-MM-DD` format
- `data_version_date` : Optional data version date in the same format. Pass `null` if the timezero does not have one
- `is_season_start`: `true` if this starts a season, and `false` otherwise
- `season_name`: Applicable when `is_season_start` is `true`, names the season, e.g., "2010-2011"


## Truth data format (CSV)

Every project in Zoltar can have ground truth values associated with targets. Users can access them as CSV as described in [Truth](Truth.md). An example truths file is [zoltar-ground-truth-example.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-ground-truth-example.csv). The file has four columns: `timezero`, `unit`, `target`, `value`:

- `timezero`: date the truth applies to, formatted as `yyyy-mm-dd`
- `unit`: the unit's abbreviation
- `target`: target name
- `value`: truth value, formatted according to the target's type. date values are formatted `yyyy-mm-dd` and booleans as `true` or `false`
 

## Forecast data format (JSON)

For prediction input and output we use a JSON file format. This format is strongly inspired by https://github.com/cdcepi/predx/blob/master/predx_classes.md . See [zoltar-predictions-examples.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-predictions-examples.json) for an example. The file contains a top-level object with two keys: `"meta"` and `"predictions"`. The `meta` section is unused for uploads, and for downloads contains various information about the forecast in the repository in the `"forecast"` field, plus lists of the project's `"units"` and `"targets"`.

The `"predictions"` list contains objects for each prediction, and each object contains the following four keys:

- `"unit"`: abbreviation of the Unit.
- `"target"`: name of the Target.
- `"class"`: the type of prediction this is. It is an abbreviation of the corresponding Prediction subclass - the names are : `bin`, `named`, `point`, and `sample`.
- `"prediction"`: a class-specific object containing the prediction data itself. The format varies according to class. Here is a summary (see [Data model](DataModel.md) for details and examples):

    - `"bin"`: Binned distribution with a category for each bin. It is a two-column table represented by two keys, one per column: `cat` and `prob`. They are paired, i.e., have the same number of rows.
    - `"named"`: A named distribution with four fields: `family` and `param1` through `param3`. `family` names must be one of : `norm`, `lnorm`, `gamma`, `beta`, `bern`, `binom`, `pois`, `nbinom`, and `nbinom2`.
    - `"point"`: A numeric point prediction with a single `value` key.
    - `"sample"`: Numeric samples represented as a table with one column that is found in the `sample` key.
    - `"quantile"`: A quantile distribution with two paired columns: `quantile` and `value`.
    - `"mean"`, `"median"`, and `"mode"`: A numeric prediction with a single value key, indicating the summary statistic indicated by the name, e.g. the mean.

To indicate a [Retracted prediction](ForecastVersions.md#retracted-predictions) in JSON files, by use `null` for the "prediction" value. For example:

```json
{
  "unit": "loc1",
  "target": "pct next week",
  "class": "point",
  "prediction": null
}
```


## Forecast data format (CSV)

Zoltar supports uploading and downloading forecast data in a CSV format with the following columns. It helps to think of this format as an "exploded" version of the prediction elements in the JSON format, where each element expands into one or more rows. `named`, `point`, `mean`, `median`, and `mode` types expand into single rows, and `bin`, `sample`, and `quantile` types expand into one or more rows depending on the particular data. You can read more about prediction types on tje [data model page](DataModel.md).

Note that because different prediction types have different contents, the CSV rows are "sparse" in that not every row uses all columns (the unused ones are empty, i.e., `""`). However, the `unit`, `target`, and `class` columns are always non-empty. For example, a `point` row only uses the `value` column whereas a `quantile` row uses only the `value` and `quantile` columns. To learn more you can examine the example file [zoltar-predictions-examples.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-predictions-examples.csv), which contains the same data as [zoltar-predictions-examples.json](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-predictions-examples.json), but in CSV format.

Here are the columns used in the format, in order. Note that there are three additional columns present when downloading forecast data: `model`, `timezero`, and `season`. They are positioned before the `unit` column. These three columns are not present when uploading forecast data.

- `unit`: the prediction's unit
- `target`: "" target
- `class`: "" prediction type. one of `bin`, `named`, `point`, `sample`, `quantile`, `mean`, `median`, and `mode`
- `value`: used for `point`, `quantile`, `mean`, `median`, and `mode` prediction types. empty otherwise
- `cat`: used for `bin` prediction types. empty otherwise
- `prob`: ""
- `sample`: used for `sample` prediction types. empty otherwise
- `quantile`: used for `quantile` prediction types. empty otherwise
- `family`: family name for `named` predictions. see [`Named` Prediction Elements](Validation.md#named-prediction-elements) for a list of them
- `param1`: parameter ""
- `param2`: parameter ""
- `param3`: parameter ""

To indicate a [Retracted prediction](ForecastVersions.md#retracted-predictions) in CSV files, put `NULL` (no quote marks) in the non-sparce cells. Taking the above example, a retracted `point` row would have `NULL` for its `value`, and a retracted `quantile` row would have `NULL` for both `value` and `quantile`. Note that only one `NULL` row of multi-row prediction types (`bin`, `sample`, and `quantile`) needs to be present to retract a prediction element. For example, here are three retracted rows:

```csv
unit,target,class,value,cat,prob,sample,quantile,family,param1,param2,param3
loc2,pct next week,point,"NULL",,,,,,,,
loc2,pct next week,bin,,"NULL","NULL",,,,,,
loc2,pct next week,quantile,"NULL",,,,"NULL",,,,
```
