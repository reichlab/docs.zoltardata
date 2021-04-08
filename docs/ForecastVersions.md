# Forecast versions

Forecasts in Zoltar can be _versioned_. A version is identified by the combination of the forecast's _model_, _time zero_, and _issue date_. Multiple versions for the same model and time zero will have different issue dates. These can be identified by the gray version numbering shown in the **version** column on the [model detail page](ModelDetailPage.md)'s **Forecasts** list (e.g., "1 of 2"), and on the **Issue date** row of the [forecast detail page](ForecastDetailPage.md)'s information table at the top (e.g., "(Version 3 of 3)").


## Forecast version rules

Zoltar enforces these rules about forecast versions:

1. Cannot load empty data.
2. Cannot load 100% duplicate data.
3. New forecast versions cannot imply any retracted prediction elements in existing versions, i.e., you cannot load data that's a subset of the previous forecast's data.
4. New forecast versions cannot change order dependencies, i.e., you cannot position a new forecast before any existing versions.
5. Editing a version's issue_date cannot reposition it before any existing forecasts.
6. Deleted forecasts cannot change order dependencies, i.e., you cannot delete a forecast that has any newer versions.

This means we require forecasts to be uploaded in `issue_date` order. If you need to "backfill" older versions, you'll first have to delete forecasts with newer `issue_date`s before uploading older ones.


# Retracted predictions

Zoltar supports _retracting_ individual prediction elements. A retracted element comes into play when executing a [forecast query](ForecastQueryFormat.md) and passing the `as_of` parameter. If you pass an `as_of` that's earlier than the retracted forecast's `issue_date`, then the previous (non-retracted) value is returned. However, if you pass an `as_of` that's newer than that `issue_date` then **no value** will be returned for that prediction element. 

Retracted predictions are identified in [JSON forecast data format](FileFormats.md#forecast-data-format-json) files by passing `NULL` for the "prediction" value. 

> Note: Retractions are indicated in quantile CSV files by `NULL` point and quantile values. The libraries take care of converting these into the JSON below. See [Quantile forecast format (CSV)](FileFormats.md#quantile-forecast-format-csv) for quantile retraction format details.

For example, if we have two versions for a time zero, and the first forecast contains this prediction:

```json
{
  "unit": "location1",
  "target": "pct next week",
  "class": "point",
  "prediction": {
    "value": 2.1
  }
}
```

Then we could retract that prediction element in the second forecast by passing this replacement:

```json
{
  "unit": "location1",
  "target": "pct next week",
  "class": "point",
  "prediction": null
}
```

Translating this JSON representation to/from CSV files is handled by the [Zoltar libraries](ApiIntro.md).


# Duplicate data

When Zoltar loads a forecast's prediction elements, it skips those that are identical to any in previous versions. This saves on storage space, and is transparent to users.