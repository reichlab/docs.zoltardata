# Data model

This page documents the internal [Django model classes](https://docs.djangoproject.com/en/1.11/topics/db/models/) that
make up Zoltar. This page is a reference meant to help users understand how forecast data is modeled, and the actual
data structures that represent the different types of predictions.


## "Containers"

These are the classes that users see when working within Zoltar, and they structure where forecast data resides.

- **Project**: Defines the valid locations, targets, and timezeros for the project's forecasts, and contains its
  forecast models.
- **Forecast Model**: Contains forecasts, zero or one for each timezero in the model's project.
- **Forecast**: Contains the specific predictions for a particular timezero.
- **Timezero**: todo


## Forecasts and Predictions

Each forecast is for a particular timezero, and contains some number of _Predictions_. Each prediction is for a location
and target in the forecast's timezero. In other words, a Forecast now has one or more Predictions of various types. We
use Prediction class hierarchy with seven concrete subclasses:

- _Prediction_ (abstract):
    - (1) **NamedDistribution**: Represents named distributions like normal, log normal, gamma, etc.
    - (2) **PointPrediction**: Represents point predictions.
    - _EmpiricalDistribution_ (abstract):
        - (3)  **BinCatDistribution**: Represents binned distribution with a category for each bin.
        - (4)  **BinLwrDistribution**: Represents binned distribution defined by inclusive lower bounds for each bin.
        - (5)   **BinaryDistribution**: Represents binary distributions.
        - (6)   **SampleDistribution**: Represents numeric samples.
        - (7)   **SampleCatDistribution**: Represents character string samples from categories.
