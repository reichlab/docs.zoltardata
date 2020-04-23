# Zoltar concepts

On this page we explain the fundamental ideas behind Zoltar's envisioning of representing forecasts in a challenge.

- _Projects_: As mentioned in [Manging Projects](Projects.md), _projects_ are the central organizing concept in Zoltar. They define the _units_, _targets_ and _time zeros_ that forecasts are relative to, and contain the _forecast models_ that teams use to represent a forecasting challenge.
- _Forecast models_: A _model_ is the representation of code that generates forecasts. It has zero or one _forecasts_ associated with the project's _time zeros_.
- _Forecasts_: A forecast consists of a set of predictions of the various types supported by Zoltar. [The data model page](DataModel.md) describes them in detail.
- _Units_: TBD
- _Targets_: Targets are the fundamental data structure of a forecast, and as such have a [separate page](Targets.md) documenting them.
- _Time zeros_: Because the forecasting field does not have standard terminology, we have settled on the following two concepts for this application. Note that some time zeros are tagged as starting a season, specifying the season's name, which helps to segment the time zeros. TBD
- _Truth_: Zoltar supports uploading ground truth data for each project that desires automatic scoring. Please see [this page](Truth.md) for details.