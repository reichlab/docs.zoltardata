# Welcome to Zoltar 4.1

Zoltar version 4.1 upgrades Zoltar's forecast versioning to support datetime versions rather than date ones. This allows multiple versions for a particular date, as requested by users. 


## Forecast versioning

Recall that the version of Zoltar prior to this new one added support for storing forecast versions. From the new [Forecast Versions](ForecastVersions.md) page:

> Forecasts in Zoltar can be _versioned_. A version is identified by the combination of the forecast's _model_, _time zero_, and _issued_at_ fields. Multiple versions for the same model and time zero will have different issued_at values. These can be identified by the gray version numbering shown in the **version** column on the [model detail page](ModelDetailPage.md)'s **Forecasts** list (e.g., "1 of 2"), and on the **Issued at** row of the [forecast detail page](ForecastDetailPage.md)'s information table at the top (e.g., "(Version 3 of 3)").


## Data migration

This upgrade required migrating existing forecasts' `issue_date` dates to `issued_at` timezone-aware datetimes. We arbitrarily chose 12 noon UTC as the time of day.
