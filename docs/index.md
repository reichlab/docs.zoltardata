# Zoltar - The Forecast Archive

Welcome to the documentation site for [Zoltar](https://www.zoltardata.com/), a system developed by [the Reich Lab](http://reichlab.io/) in the [Department of Biostatistics and Epidemiology](http://www.umass.edu/sphhs/biostatistics) at the [University of Massachusetts Amherst](https://www.umass.edu/) to store time series forecasts along with tools to browse, analyze, visualize, and score them.


## Introduction

Zoltar is a web application to that hosts a repository of model forecast results. For many existing forecasting projects, predictions made by models have been stored in differing formats and locations or in sets of unstructured data files. This complicates tracking, comparing, visualizing and scoring forecasts. Zoltar supports storing, retrieving, comparing, and analyzing time series forecasts for prediction challenges of interest to many different modeling communities.


## Getting started

Use the navigation links in the sidebar to get started [touring the web site](WebTourIntro.md), [reading the user guide](UserIntro.md), or learning about our [python](Zoltpy.md) and [R](Zoltr.md) packages for interacting with the Zoltar API from your programming language.  


## Assumptions/Limitations

The scope of this first iteration is limited in these ways:

- _Process-agnostic_: By storing only core datasets, we make no assumptions about ML processes behind a model’s forecast, such as how it’s fit.
- _Enforceability_: There is currently not a method in place to test whether the models were fit on the right data subsets (this is something that pipeline-focused software such as [mlr3](https://mlr3.mlr-org.com/), among others, could assist with).
- _Unrevised vs. revised data_: A Project’s core dataset may or may not include data revisions, such as those used to model or forecast reporting delays. Each project should give specific instructions on what type of data (revised vs. unrevised) is used in the training and testing phases of the forecasting.
- _Model instances_: The system stores only model metadata, rather than computable representations of models (internals) that could be used to reconstruct and re-run them.
- _Reports_: Some projects generate automated narrative reports from forecast data. This system does not support storing reports with their models.
- _Training/testing data_: The only information about what subsets of the core data were used for different ML stages (e.g. training vs testing) will be stored in narrative format in the project description.
- _Reproducibility_: Since this system stores data involved in forecasts and not source code, information about how to re-run models is only captured in narrative form in the model's description, and is linked to by the model's url field.

## Funding

This work has been supported by the National Institutes of General Medical Sciences (R35GM119582). The content is solely the responsibility of the authors and does not necessarily represent the official views of NIGMS, or the National Institutes of Health.


## Contact

If you have questions about this site, please contact us at [zoltar@reichlab.io](mailto:zoltar@reichlab.io). For account requests, please fill out the [Zoltardata.com user request form](https://docs.google.com/forms/d/1C7IEFbBEJ1JibG-svM5XbnnKkgwvH0770LYILDjBxUc/viewform?edit_requested=true) to be added to our beta-tester invitation queue.
