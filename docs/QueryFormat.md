# Querying a project's forecasts

In addition to the ability to download individual forecasts via both the [Web UI](Forecasts.md#download-a-single-forecast) and the [Zoltar libraries](ApiIntro.md), Zoltar supports downloading multiple forecasts at once, but currently only through the libraries.


## Querying workflow

Like [uploading a forecast](Forecasts.md#upload-a-forecast), querying a project's forecasts can be a long operation. For this reason, Zoltar _enqueues_ queries as jobs that are operated on separately from the web process. This means querying follows these steps:

1. Create and submit the [query](#query_format). This returns a job that you can use to a) track the status of the query, and b) download the query results (forecast data).
1. Poll the job until its status is **SUCCESS**. (You can use the Web UI to do this as well. See [Check an upload's status](Forecasts.md#check_an_uploads_status) for how.)
1. Download the data associated with the job.


## Query format

Zoltar supports a simple filtering feature that allows users to limit what data is downloaded.

To filter a project's forecast data, we support the following five types of filters. They are passed behind the scenes to the server as JSON.

> Note that *server IDs* are passed, not URLs or names, which makes queries unambiguous. Libraries may provide helper functions that hide details and make the feature more convenient. For example, instead of passing time zeros as IDs, the user would be able to use our standard `yyyy-mm-dd` format, which the library would convert to IDs.

Logically, the filters are treated as a list of "ANDs of ORs": Each of the five filter types are lists that are considered individually as ORs. For example, a list of model IDs means get data from *any* of them. The filters are combined by ANDs, meaning only data that matches *all* filters. (See the below example.) The types of filters are:

1) Filter by *model*: Pass zero or more model IDs in the `models` field. Example:
```json
{"models": [150, 237]}  # gets data only from either of these two models. 150 = "60-contact", 237 = "CovidIL_100"
```

2) Filter by *unit*: Pass zero or more unit IDs `units` field. Example:
```json
{"units": [335]}  # get data only for this unit. 335 = "US"
```

3) Filter by *target*: Pass zero or more target IDs in the `targets` field. Example:
```json
{"targets": [1894, 1897]}  # get data only for either of these two targets. 1894 = "0 day ahead cum death", 1897 = "1 day ahead cum death"
```

4) Filter by *timezero*: Pass zero or more timezero IDs in the `timezeros` field. Example:

```json
{"timezeros": [739, 738]}  # get data only for either of these two time zeros. 739 = "2020-05-14", 738 = "2020-05-09"
```

5) Filter by forecast *type*: Pass a list of string types in the `types` field. Choices are `bin`, `named`, `point`, `sample`, and `quantile`. Example:
```json
{"types": ["point", "quantile"]}  # get only point and quantile data
```

The lists in 1 through 5 operate as "OR" on their own but are combined in the final query as "AND"s. Here's an example:

```json
{"models": [150, 237],
 "units": [335],
 "targets": [1894, 1897],
 "timezeros": [739, 738],
 "types": ["point", "quantile"]
}
```

This results in data that is:

- (from either the `60-contact` OR `CovidIL_100` models) AND
- (the unit is `US`) AND
- (the target is either `0 day ahead cum death` or `1 day ahead cum death`) AND
- (the timezero is either `2020-05-14` OR `2020-05-09`) AND
- (the prediction type is either `point` OR `quantile`)

Note that not all types of filters are required to be specified. Any missing ones are treated by default as "all". In the previous example, if we omitted `types` then we'd get similar data except it would include all prediction types instead of just `point` or `quantile` ones.


## Data format

Data is returned in tabular CVS format with the following columns. Because we support five different prediction types in our [Data Model](DataModel.md), the format of each row must account for all possible values. For this reason, the CSV is 'sparse': not every row uses all columns; unused ones are empty (''). Note that the first six columns are always present for any prediction type.

- `model`: the model's abbreviation (if defined) or name 
- `timezero`: date the truth applies to, formatted as `yyyy-mm-dd`
- `season`: the season the `timezero` corresponds to. empty if no defined seasons in the project
- `unit`: the unit's name
- `target`: target name
- `class`: prediction type. one of `bin`, `named`, `point`, `sample`, and `quantile`
- `value`: used for `point` and `quantile` prediction types. empty otherwise
- `cat`: used for `bin` prediction types. empty otherwise
- `prob`: ""
- `sample`: used for `sample` prediction types. empty otherwise
- `quantile`: used for `quantile` prediction types. empty otherwise
- `family`: used for `named` prediction types. empty otherwise
- `param1`: ""
- `param2`: ""
- `param3`: ""


## Data limits

Because queries have the potential to return millions of rows, the number of resulting rows is capped. The query fails if it would exceed the limit.
