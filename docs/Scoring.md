# Scoring in Zoltar

Zoltar automatically computes a fixed set of scores (more are in development) for all projects and forecasts. They are updated in the background on a per-forecast basis by a scheduler that currently runs Daily at [5:30 AM UTC](http://www.timebie.com/std/utc.php?q=5.5). The update is performed only on models that have changed, i.e., those that have added or removed forecasts since the last update. Following are details about scoring.


## Scoring requirements

For Zoltar to calculate a forecast's scores, the following must be true:

- [Ground truth](Truth.md) has been uploaded, and contains truth values for each unit/target combination in the forecast.
- Data is available in the prediction elements shown in the table [Available scores by target type and prediction element](Targets.md#available-scores-by-target-type-and-prediction-element).
<!-- todo more requirements? -->


## Current scores

At the time of writing Zoltar implements these scores:

- **Error**: The the truth value minus the model's point estimate. 
- **Absolute Error**: The absolute value of the truth value minus the model's point estimate. Lower is better.
- **Log score (single bin)**: Natural log of probability assigned to the true bin. Higher is " "better." More detail is [here](https://github.com/reichlab/flusight/wiki/Scoring#2-log-score-single-bin).
- **Log score (multi bin)**: This is calculated by finding the natural log of probability " "assigned to the true and a few neighbouring bins. Higher is better. See [this page](https://github.com/reichlab/flusight/wiki/Scoring#3-log-score-multi-bin) for how it works.
- **Probability Integral Transform (PIT)**: The probability integral transform (PIT) is a metric commonly " "used to evaluate the calibration of probabilistic forecasts. 
- **Interval**: This score is a proper score used to assess calibration and sharpness of quantile forecasts. Lower is better. The supported intervals alpha values are: 0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, and 1.0. 

In addition, aggregate score values are calculated (see below).


## Downloading scores

> Note: Downloading scores is currently available only to users with Zoltar accounts.
>
> Note: As mentioned at [Jobs](Jobs.md), downloading scores is done in a separate worker process because it may take more than a handful of seconds to run. Thus the workflow is based on that (see [Job workflow](Jobs.md#workflow) for details).

Scores are downloaded by executing a [scores query](ScoreQueryFormat.md) by either a) [Zoltar API](Api.md) using the [Zoltar libraries](ApiIntro.md), or b) via a simple web UI form (shown below). In both cases you need to follow these steps:
 
 1. Decide the data of interest (i.e., `models`, `units`, `targets`, `timezeros`, and `scores`).
 1. Submit the query to get a Job ID.
 1. Poll the resulting Job until it succeeds (see [Check a job's status](Jobs.md#check-a-jobs-status)).
 1. Download the job's data (see [Download a job's data](Jobs.md#download-a-jobs-data)). The format is described at [Score data format (CSV)](FileFormats.md#score-data-format-csv).
 
 
## Download scores via the web UI
 
 To download score data via the web UI:
 
 1. Go to the [project detail page](ProjectDetailPage.md) whose models contain the forecasts. 
 1. Click the "Download" button to the right of "Scores" in the Features section at the page's top.
 1. On the "Edit Scores Query" page that shows, enter your query and then click "Submit" (see the screen shot below).
 1. Poll the resulting Job until it succeeds (see [Check a job's status](Jobs.md#check-a-jobs-status)).
 1. Download the job's data (see [Download a job's data](Jobs.md#download-a-jobs-data)).
