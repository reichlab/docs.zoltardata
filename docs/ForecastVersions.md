# Forecast versions

Forecasts in Zoltar can be _versioned_. A version is identified by the combination of the forecast's _model_, _time zero_, and _issued_at_ fields. Multiple versions for the same model and time zero will have different issued_at values. These can be identified by the gray version numbering shown in the **version** column on the [model detail page](ModelDetailPage.md)'s **Forecasts** list (e.g., "1 of 2"), and on the **Issued at** row of the [forecast detail page](ForecastDetailPage.md)'s information table at the top (e.g., "(Version 3 of 3)").


## Forecast version rules

Zoltar enforces these rules about forecast versions:

1. No uploaded forecast can have no rows of data.
2. No uploaded forecast can load 100% duplicate data of a previous version.
3. New forecast versions cannot imply any retracted prediction elements in existing versions, i.e., you cannot load data that's a subset of the previous forecast's data.
4. New forecast versions cannot be positioned before any existing versions.
5. Editing a version's issued_at cannot reposition it before any existing forecasts.
6. Deleted forecasts cannot be positioned before any newer versions.

Notes:
- Rule 3 applies only to non-oracle forecasts, i.e., truth forecasts are allowed to be partial because we assume truth retractions are not allowed.
- This means we require forecasts to be uploaded in `issued_at` order. If you need to "backfill" older versions, you'll first have to delete forecasts with newer `issued_at` datetimes before uploading older ones.


## Retracted predictions

Zoltar supports _retracting_ individual prediction elements. A retracted element marks a particular combination of unit, target, and prediction type to be ignored when executing a [forecast query](ForecastQueryFormat.md) if the user passes an `as_of` value that's on or later than the retraction `issued_at`. In that case there will be no value returned for the retracted prediction element. However, an `as_of` that's earlier than the forecast's `issued_at` **will** result in the element's pre-retraction value being returned. Users who want to return the forecast's original data including retractions, should use the API or web UI as documented in [download a single forecast](Forecasts.md#download-a-single-forecast). In this case Zoltar will include retractions as they were uploaded - with `null` "prediction" value in the JSON (see below). 

Retracted predictions are identified in [JSON forecast data format](FileFormats.md#forecast-data-format-json) files by passing `null` for the "prediction" value, and by passing `NULL` in [CSV forecast data format](#forecast-data-format-csv).


## Duplicate data

When Zoltar loads a forecast's prediction elements, it skips those that are identical to any in previous versions. This saves on storage space, and is transparent to users (downloading forecast data via queries or single forecasts will reassemble the original data).
