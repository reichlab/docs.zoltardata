# Welcome to Zoltar 4!

Zoltar version 4 is a major upgrade to Zoltar's fundamental forecast data representation, enabling new forecast versioning features. Read on for details.


## Forecast versioning

Recall that the version of Zoltar prior to this new one added support for storing forecast versions. From the new [Forecast Versions](ForecastVersions.md) page:

> Forecasts in Zoltar can be _versioned_. A version is identified by the combination of the forecast's _model_, _time zero_, and _issue date_. Multiple versions for the same model and time zero will have different issue dates. These can be identified by the gray version numbering shown in the **version** column on the [model detail page](ModelDetailPage.md)'s **Forecasts** list (e.g., "1 of 2"), and on the **Issue date** row of the [forecast detail page](ForecastDetailPage.md)'s information table at the top (e.g., "(Version 3 of 3)").


## Data migration

This upgrade required migrating existing data, which we've done, but which resulted in a few forecasts that needed modifying. We've notified individual modelers of any problematic ones.


## Forecast version rules

We now enforce these [version rules](ForecastVersions.md#forecast-version-rules):

1. No uploaded forecast can have no rows of data.
2. No uploaded forecast can load 100% duplicate data of a previous version.
3. New forecast versions cannot imply any retracted prediction elements in existing versions, i.e., you cannot load data that's a subset of the previous forecast's data.
4. New forecast versions cannot be positioned before any existing versions.
5. Editing a version's issue_date cannot reposition it before any existing forecasts.
6. Deleted forecasts cannot be positioned before any newer versions.

Bullet three means we require forecasts to be uploaded in `issue_date` order. If you need to back-fill older versions, you'll first have to delete forecasts with newer issue_dates before uploading older ones.


## Skipping of duplicate forecast data

Zoltar now implements a space optimization where duplicate data between forecast versions is not saved on disk. The forecast query feature hides this from users by reassembling the data as needed.


## Forecast retractions

Zoltar now supports the notion of "retracting" forecasts. Such retractions mark individual prediction elements so that the `as_of` forecast query parameter hides those predictions. The retracted data is not deleted, and earlier `as_of` values will still return that data when passing an `as_of` value that is prior to the retraction.

From the [Retracted predictions](ForecastVersions.md#retracted-predictions) page:

> Zoltar supports _retracting_ individual prediction elements. A retracted element marks a particular combination of unit, target, and prediction type to be ignored when executing a [forecast query](ForecastQueryFormat.md) if the user passes an `as_of` value that's on or later than the retraction `issue_date`. In that case there will be no value returned for the retracted prediction element. However, an `as_of` that's earlier than the forecast's `issue_date` **will** result in the element's pre-retraction value being returned. Users who want to return the forecast's original data including retractions, should use the API or web UI as documented in [download a single forecast](Forecasts.md#download-a-single-forecast). In this case Zoltar will include retractions as they were uploaded - with `null` "prediction" value in the JSON (see below).

For users of the quantile forecast CSV format:

> Retractions are indicated in quantile CSV files by `NULL` point and quantile values. The libraries take care of converting these into the JSON below. See [Quantile forecast format (CSV)](FileFormats.md#retracted-predictions) for quantile retraction format details.
