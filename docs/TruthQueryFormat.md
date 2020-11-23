# Querying a project's truth

Currently truth can only be downloaded programmatically using the [Zoltar libraries](ApiIntro.md). The workflow is identical to downloading forecasts as described at [forecast query format](ForecastQueryFormat.md) page) except for the following. (Note: data limits are the same as querying forecasts.)


## Query format

The format is identical to querying forecasts except that only the three fields `models`, `units`, `targets`, and `timezeros` are allowed, and function the same way.

Here's a full example:

```json
{"units": ["US"],
 "targets": ["0 day ahead cum death", "1 day ahead cum death"],
 "timezeros": ["2020-05-14", "2020-05-09"]
}
```


## Data format

The truth is returned in the CSV format documented at [Truth data format (CSV)](FileFormats.md#truth-data-format-csv).
