# Zoltar concepts

On this page we explain the fundamental ideas behind Zoltar's envisioning of representing forecasts in a challenge.

- _Projects_: As mentioned in [Manging Projects](Projects.md), _projects_ are the central organizing concept in Zoltar. They define the _units_, _targets_ and _time zeros_ that forecasts are relative to, and contain the _forecast models_ that teams use to represent a forecasting challenge.
- _Forecast models_: A _model_ is the representation of code that generates forecasts. It has zero or one _forecasts_ associated with the project's _time zeros_. A model is identified by its `abbrevation` field, which is unique within a project.
- _Forecasts_: A forecast consists of a set of predictions of the various types supported by Zoltar. Forecast _versioning_ is supported via each forecast having an `issued_at` field, which defaults to when the forecast was uploaded to Zoltar. (Users with advanced permission can change that field.) See the [Data Model](DataModel.md) and [Forecast Versions](ForecastVersions.md) pages for details.
- _Units_: Units represent distinct entities for which predictions are made, for example, if forecasts are made for multiple different locations, the locations are the units. A unit is identified by its `abbrevation` field, which is unique within a project.
- _Targets_: Targets are the fundamental data structure of a forecast, and as such have a [separate page](Targets.md) documenting them.
- _Time zeros_: Because the forecasting field does not have standard terminology, we have settled on the following two concepts for this application. Note that some time zeros are tagged as starting a season, specifying the season's name, which helps to segment the time zeros.
    - **Time zero**: The date from which a forecast originates and to which targets are relative (i.e. a "2-week-ahead forecast" is two weeks ahead of the time-zero). Every forecast is for a time zero.
    - **Data version date**: (Optional) The latest date at which any data source used for the forecasts should be considered. Can be used externally to recreate model results by "rolling back" the core data to a particular state.
- _Truth_: Zoltar supports uploading ground truth data for projects. Please see [this page](Truth.md) for details.
