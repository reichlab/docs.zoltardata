# Querying a project's truth

Truth can be downloaded from the web UI as described in [Download truth](Truth.md#download-truth) or through the API. The workflow is identical to downloading forecasts as described at [forecast query format](ForecastQueryFormat.md) page) except for the following. (Note: data limits are the same as querying forecasts.)


## Query format

The format is identical to querying forecasts except that only the four fields `units`, `targets`, `timezeros`, and `as_of` are allowed, which function identically.

Here's a full example:

```json
{"units": ["US"],
 "targets": ["0 day ahead cum death", "1 day ahead cum death"],
 "timezeros": ["2020-05-14", "2020-05-09"],
  "as_of": "2021-05-10 12:00 UTC "
}
```


## Data format

The truth is returned in the CSV format documented at [Truth data format (CSV)](FileFormats.md#truth-data-format-csv).
