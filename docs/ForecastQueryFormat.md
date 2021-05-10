# Querying a project's forecasts

In addition to the ability to download individual forecasts via both the [web UI](Forecasts.md#download-a-single-forecast) and the [Zoltar libraries](ApiIntro.md), Zoltar supports downloading multiple forecasts at once, but currently only through the libraries.


## Querying workflow

Like [uploading a forecast](Forecasts.md#upload-a-forecast), querying a project's forecasts can be a long operation. For this reason, Zoltar _enqueues_ queries as jobs that are operated on separately from the web process. This means querying follows these steps:

1. Create and submit the [query](#query-format). This returns a job that you can use to a) track the status of the query, and b) download the query results (forecast data).
1. Poll the job until its status is **SUCCESS**. (You can use the web UI to do this as well. See [Check an upload's status](Forecasts.md#check-an-uploads-status) for how.)
1. Download the data associated with the job.


## Query format

Zoltar supports a simple filtering feature that allows users to limit what data is downloaded.

To filter a project's forecast data, we support the following six types of filters. They are passed behind the scenes to the server as JSON.

Logically, the filters are treated as a list of "ANDs of ORs": Each of the five filter types are lists that are considered individually as ORs. For example, a list of models means get data from *any* of them. The filters are combined by ANDs, meaning only data that matches *all* filters. (See the below example.) The types of filters are:

1) Filter by *model*: Pass zero or more model **abbreviations** in the `models` field. Example:
```json
{"models": ["60-contact", "CovidIL_100"]}  # gets data only from either of these two models
```

2) Filter by *unit*: Pass zero or more unit **names** in the `units` field. Example:
```json
{"units": ["US"]}  # get data only for this unit
```

3) Filter by *target*: Pass zero or more target **names** in the `targets` field. Example:
```json
{"targets": ["0 day ahead cum death", "1 day ahead cum death"]}  # get data only for either of these two targets
```

4) Filter by *timezero*: Pass zero or more timezero **dates** in `yyyy-mm-dd` format in the `timezeros` field. Example:

```json
{"timezeros": ["2020-05-14", "2020-05-09"]}  # get data only for either of these two time zeros
```

5) Filter by forecast *type*: Pass a list of string types in the `types` field. Choices are `bin`, `named`, `point`, `sample`, and `quantile`. Example:
```json
{"types": ["point", "quantile"]}  # get only point and quantile data
```

6) Filter by forecast *version*: Passing a datetime string in the optional `as_of` field causes the query to return only those forecast versions whose `issued_at` is <= the `as_of` datetime (AKA timestamp). If no `as_of` is passed then the query returns the most recent forecasts. (See [Forecast Versions](ForecastVersions.md) for more about versions.) The `as_of` field format must be a datetime as parsed by the [dateutil python library](https://dateutil.readthedocs.io/en/stable/index.html), which accepts a variety of styles. You can find example [here](https://dateutil.readthedocs.io/en/stable/examples.html#parse-examples). Importantly, the datetime must include timezone information for disambiguation, without which the query will fail. (Note that Zoltar displays all datetimes using the UTC timezone.) Here's an example:
```json
{"as_of": "2021-05-10 12:00 UTC "}  # get forecasts whose issued_at is <= this date
```


The lists in 1 through 5 operate as "OR" on their own but are combined in the final query as "AND"s. Here's an example:

```json
{"models": ["60-contact", "CovidIL_100"],
 "units": ["US"],
 "targets": ["0 day ahead cum death", "1 day ahead cum death"],
 "timezeros": ["2020-05-14", "2020-05-09"],
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

The forecasts are returned in the CSV format documented at [Forecast data format (CSV)](FileFormats.md#forecast-data-format-csv).


## Data limits

Because queries have the potential to return millions of rows, the number of resulting rows is capped. The query fails if it would exceed the limit.
