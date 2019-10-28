# Zoltar - The Forecast Archive

Welcome to the documentation site for [Zoltar](https://www.zoltardata.com/), a system developed by
[the Reich Lab](reichlab.io) in the [Department of Biostatistics and
Epidemiology](http://www.umass.edu/sphhs/biostatistics) at the [University of Massachusetts Amherst](https://www.umass.edu/)
to store timeseries forecasts along with tools to browse, analyze, visualize, and score them.


## Introduction

Zoltar is a web application to develop ideas for a repository of model forecast results. Until now, predictions made by
models have been stored in differing formats and locations. This complicates tracking, comparing, and revisiting
forecasts. Zoltar supports storing, retrieving, comparing, and analyzing time series forecasts for prediction challenges
of interest to the modeling community.


## Assumptions/Limitations

The scope of this first iteration is limited in these ways:

- *Process-agnostic*: By storing only core datasets, we make no assumptions about ML processes behind a model’s
  forecast, such as how it’s fit.
- *Enforceability*: There is currently not a method in place to test whether the models were fit on the right data
  subsets (this is something that the below ForecastFramework integration could help with).
- *Unrevised vs. revised data*: A Project’s core dataset may or may not include data revisions, such as those used to
  model or forecast reporting delays. Each project should give specific instructions on what type of data (revised vs.
        unrevised) is used in the training and testing phases of the forecasting.
- *Model instances*: The system stores only model metadata, rather than computable representations of models (internals)
  that could be used to reconstruct and re-run them.
- *Reports*: Some projects generate automated narrative reports from forecast data. This system does not support storing
  reports with their models.
- *Training/testing data*: The only information about what subsets of the core data were used for different ML stages
  (e.g. training vs testing) will be stored in narrative format in the project description.
- *Reproducibility*: Since this system stores data involved in forecasts and not source code, information about how to
  re-run models is only captured in narrative form in the model's description, and is linked to by the model's url field.
- *Metrics*: This version does not capture metric information. If metrics change, then a new project should be created.


## Funding

This work has been supported by the National Institutes of General Medical Sciences (R35GM119582). The content is solely
the responsibility of the authors and does not necessarily represent the official views of NIGMS, or the National
Institutes of Health.



## Contact

If you have questions about this site or want an account, please contact Professor Nicholas Reich
(nick@schoolph.umass.edu), director of the <a href="http://reichlab.io/">Reich Lab</a>.

