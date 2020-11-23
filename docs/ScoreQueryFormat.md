# Querying a project's scores

Currently scores can only be downloaded programmatically using the [Zoltar libraries](ApiIntro.md). The workflow is identical to downloading forecasts as described at [forecast query format](ForecastQueryFormat.md) page) except for the following. (Note: data limits are the same as querying forecasts.)


## Query format

The format is identical to querying forecasts except that there is a `scores`field instead the `types` one. All other fields (`models`, `units`, `targets`, and `timezeros`) are allowed, and function the same way. The `scores` field implements filtering by *score abbreviation*. Pass the abbreviations as a list of strings, e.g.,

```json
{"scores": ["log_single_bin", "interval_100"]}  # get data for only these two scores
```


Here's a full example:

```json
{"models": ["60-contact", "CovidIL_100"],
 "units": ["US"],
 "targets": ["0 day ahead cum death", "1 day ahead cum death"],
 "timezeros": ["2020-05-14", "2020-05-09"],
 "scores": ["log_single_bin", "interval_100"]
}
```


Here are the current score abbreviations:

- 'error'
- 'abs_error'
- 'log_single_bin'
- 'log_multi_bin'
- 'pit'
- 'interval_2'
- 'interval_5'
- 'interval_10'
- 'interval_20'
- 'interval_30'
- 'interval_40'
- 'interval_50'
- 'interval_60'
- 'interval_70'
- 'interval_80'
- 'interval_90'
- 'interval_100'


## Data format

The scores are returned in the CSV format documented at [Score data format (CSV)](FileFormats.md#score-data-format-csv).
