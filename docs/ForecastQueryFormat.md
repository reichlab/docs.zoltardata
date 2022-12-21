# Querying a project's forecasts

In addition to the ability to download individual forecasts via both the [web UI](Forecasts.md#download-a-single-forecast) and the [Zoltar libraries](ApiIntro.md), Zoltar supports downloading data from multiple forecasts via a simple query specification. You can download from the web UI as described in [Download forecasts via the web UI](Forecasts.md#download-forecasts-via-the-web-ui) or through the API.


## Querying workflow

Like [uploading a forecast](Forecasts.md#upload-a-forecast), querying a project's forecasts can be a long operation. For this reason, Zoltar _enqueues_ queries as jobs that are operated on separately from the web process. This means querying follows these steps:

1. Create and submit the [query](#query-format). This returns a job that you can use to a) track the status of the query, and b) download the query results (forecast data).
1. Poll the job until its status is **SUCCESS**. (You can use the web UI to do this as well. See [Check an upload's status](Forecasts.md#check-an-uploads-status) for how.)
1. Download the data associated with the job.


## Query format

Zoltar supports a simple filtering feature that allows users to limit what data is downloaded.

To filter a project's forecast data, we support the following six types of filters. They are passed behind the scenes to the server as a JSON object with keys and values.

Logically, the filters are treated as a list of "ANDs of ORs": Each of the five filter types are lists that are considered individually as ORs. For example, a list of models means get data from *any* of them. The filters are combined by ANDs, meaning only data that matches *all* filters. (See the below example.) The types of filters are:

1) Filter by *model*: Pass zero or more model **abbreviations** in the `models` field. Example:
```json
{"models": ["60-contact", "CovidIL_100"]}  # gets data only from either of these two models
```

2) Filter by *unit*: Pass zero or more unit **abbreviations** in the `units` field. Example:
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


### Query options

Some features (currently only automatic prediction type conversion) require additional information to run. This is specified via the `options` field, which is an object that acts like a flat dot-namespaced registry ala Firefox's Configuration Editor (its `about:config` page). Keys are period-delimited strings and values are option-specific values. Here's the above query with some options:

```json
{"models": ["60-contact", "CovidIL_100"],
 "units": ["US"],
 "targets": ["0 day ahead cum death", "1 day ahead cum death"],
 "timezeros": ["2020-05-14", "2020-05-09"],
 "types": ["point", "quantile"],
 "options": {"convert.bin": true,
             "convert.point": "mean", 
             "convert.quantile": [0.025, 0.25, 0.5, 0.75, 0.975],
             "convert.sample": 100}
}
```


### Automatic prediction type conversion

Zoltar supports converting automatically from some prediction types to desired ones that have not actually been uploaded.

> Note: Conversion is currently limited, with support coming for additional prediction types and target types.
> Also note that the auto-conversion feature results in slower queries than when it is not requested. 

Auto-conversion is activated via two query parameters:

1. Specify the forecast *types* (#5 above) that you want the program to convert TO (the default, if unspecified is all types).
2. Include query *options* for the conversions you want. Including an option does two things: a) it tells Zoltar that it should convert TO that type (i.e., that conversion is activated), and b) possible details about how to do the conversion.


Here are all the conversions that we hope to support (TO on the arrow left and FROM on the right):

```
`bin`      <- `named`, `sample`  # can convert named or samples to bin. options: none
`named`    <-  n/a               # no conversion to named is possible
`point`    <- `named`, `sample`  # can convert named or samples to point. options: 'mean' or 'median'
`quantile` <- `named`, `sample`  # "" samples. options: list of quantiles
`sample`   <- `named`            # can convert named to samples. options: number of samples
```

Here are the corresponding query options (see the example query above):

- `convert.bin`: a *boolean* indicating conversion to bin is desired
- `convert.point`: a *string* indicating conversion to points is desired: either 'mean' or 'median'
- `convert.quantile`: a *list* indicating conversion to quantiles is desired: a list of unique numbers in [0, 1]
- `convert.sample`: an *integer* indicating conversion to samples is desired: an int >0


Converting takes into account each prediction element's target's [type](Targets.md#target-types):

- *continuous*: OK (mean, median)
- *discrete*: OK (mean, median)
- *nominal*: TBD (mode: which value, TRUE or FALSE, is more present in the samples)
- *binary*: TBD (mode: which value, TRUE or FALSE, is more present in the samples
- *date*: TBD (don’t support for now)


Currently, only these combinations are implemented:

- target types: continuous, discrete
- conversions: `point` <- `sample` (uses either [statistics.mean()](https://docs.python.org/3/library/statistics.html#statistics.mean) or [statistics.median()](https://docs.python.org/3/library/statistics.html#statistics.median) depending on the `convert.point` option)
- conversions: `quantile` <- `sample` (uses [numpy.quantile()](https://numpy.org/devdocs/reference/generated/numpy.quantile.html))


## Data format

The forecasts are returned in the CSV format documented at [Forecast data format (CSV)](FileFormats.md#forecast-data-format-csv).


## Data limits

Because queries have the potential to return millions of rows, the number of resulting rows is capped. The query fails if it would exceed the limit.
