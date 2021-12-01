# Forecast Targets in Zoltar

Targets are the fundamental data structure of a forecast. In Zoltar, a single forecast made by a model may give predictions for multiple targets. For example, a single forecast might include a forecast of 1- and 2-week-ahead values and a prediction of when the time series will reach its maximum in a given period of time. When a project is created, the project owner specifies which targets should be part of any submitted forecast. As we will see below, targets have specific properties, and there are several types of targets that determine which properties and features pertain to a particular target.


## Target types

*continuous*: A quantitative target whose range encapsulates a section of the real number line. 
> Examples: percentage of all doctors' office visits due to influenza like-illness, or disease incidence per 100,000 population.

*discrete*: A quantitative target whose range is a set of integer values. 
> Example: the number of incident cases in a time period.

*nominal*: A nominal, unordered categorical target. 
> Example: severity level in categories of "low", "moderate", and "high".

*binary*: A binary target, with a defined outcome that can be seen as a true/false. 
> Example: does the maximum value of a variable exceed some threshold C in a given period of time.

*date*: A target with a discrete set of calendar dates as possible outcomes. 
> Example: the calendar week in which peak incidence occurs (represented by the Sunday of that week.


## Target parameters

When created, all targets have a set of parameters that must be defined. Each type of target then has a set of additional, sometimes, optional parameters. These are all defined below.

### Summary of allowed, optional, and required parameters, by target type

Here is a table that summarizes which are allowed, optional, and required, by type. legend: 'x' = required, '(x)' = required if `is_step_ahead` is `true`, '-' = disallowed, '~' = optional.

target type | type | name | description | outcome_variable | is_step_ahead |  numeric_horizon  |  RDT  | range | cats 
----------- | ---- | ---- | ----------- | ---------------- | ------------- | ----------------- |  ---- | ----- | ---- 
continuous  |  x   |  x   |     x       |        x         |      x        |         (x)       |  (x)  |   ~   |  ~   
discrete    |  x   |  x   |     x       |        x         |      x        |         (x)       |  (x)  |   ~   |  ~   
nominal     |  x   |  x   |     x       |        x         |      x        |         (x)       |  (x)  |   -   |  x   
binary      |  x   |  x   |     x       |        x         |      x        |         (x)       |  (x)  |   -   |  -   
date        |  x   |  x   |     x       |        x         |      x        |         (x)       |  (x)  |   -   |  x   

### Required parameters for all targets

- *name*: A brief name for the target. (The number of characters is not limited, but brevity is helpful.)
- *description*: A verbose description of what the target is. (The number of characters is not limited.)
- *type*: One of the five target types named above, e.g., `continuous`.
- *is_step_ahead*: `true` if the target is one of a sequence of targets that predict values at different points in the future.
- *numeric_horizon*: An integer indicating the forecast horizon represented by this target. It is required if `is_step_ahead` is `true`. 
- *reference date type* (RDT): An integer that indicates how this target calculates `reference_date` and `target_end_date` from a timezero. It is required if `is_step_ahead` is `true`. The allowed values are hard-coded (see the [valid reference date types](Targets.md#valid-reference-date-types) table below) and will be used for an upcoming visualization feature (more documentation to come then).

### valid reference date types

Following are the allowed reference date types. `id` is the integer value that's actually stored in the database, `name` is the "official" unique name used by [project configuration files](FileFormats.md#project-creation-configuration-json), and `abbreviation` is used to calculate target group names.

id  | name                            | abbreviation 
--- | ------------------------------- | ------------ 
0   | DAY                             | day          
1   | MMWR_WEEK_LAST_TIMEZERO_MONDAY  | week         
2   | MMWR_WEEK_LAST_TIMEZERO_TUESDAY | week         
3   | BIWEEK                          | biweek       


### Parameters specific to continuous targets

- *range*: (Optional) a numeric vector of length 2 specifying a lower and upper bound of a range for the continuous target. The range is assumed to be inclusive on the lower bound and open on the upper bound, e.g. [a, b). If range is not specified than range is assumed to be (-infty, infty).
- *cats*: (Optional, but uploaded `Bin` prediction types will be rejected unless these are specified) an ordered set of numeric values indicating the inclusive lower-bounds for the bins of binned distributions. E.g. if `cats` is specified as [0, 1.1, 2.2] then the implied set of valid intervals would be [0,1.1), [1.1,2.2) and [2.2, \infty). Additionally, if `range` had been specified as [0, 100] in addition to the above `cats`, then the final bin would be [2.2, 100].
  <!-- NGR: is upper bound always specified as infinity?-->

If both `range` and `cats` are specified, then min(`cats`) must equal the lower bound and max(`cats`) must be less than the upper bound of `range`.

### Parameters  specific to discrete targets

- *range*: (Optional, but uploaded `Bin` prediction types will be rejected unless `range` is specified) an integer vector of length 2 specifying a lower and upper bound of a range for the continuous target. The range is assumed to be inclusive on both the lower and upper bounds, e.g. [a, b]. If range is not specified than range is assumed to be (-infty, infty).
- *cats*: (Optional, and can only be specified if `range` is also specified) an ordered set of integer values indicating the inclusive lower-bounds for the bins of binned distributions. E.g. if `cats` is specified as [0, 10, 20, 30, 40, 50] and `range` is specified as [0, 100] then the implied set of valid categories would be [0,10), [10, 20), [20, 30), [30, 40), [40, 50) and [50, 100].

If both `range` and `cats` are specified, then min(`cats`) must equal the lower bound and max(`cats`) must be less than the upper bound of `range`.

### Parameters  specific to nominal targets

- *cats*: (Required) a list of strings that name the categories for this target. Categories must not include the following strings: `""`, `"NA"`, or `"NULL"` (case does not matter).

### Parameters  specific to binary targets

None.

### Parameters  specific to date targets

- *cats*: (Required) a list of dates in `YYYY-MM-DD` format. These are the only dates that will be considered as valid input for the target. <!-- NGR: do we want to consider encoding the info about which dates are valid for particular ranges of timezeroes? I.e. embed the idea of "seasons" here? I say no, for starters?  -->

<!-- 
General notes on date targets
Date targets are represented by the `dates` data type in the database. On the one hand, original data, submitted with data_type="text" is retained. On the other hand, a transformed version of the data is also retained, as integer values. I order for this transformation to work, we must have a unique, well-defined method to transform the submitted text into integers. We rely on standard libraries for date transformations to ensure the transformations are valid and accurate. 

All input data into date targets must be unambiguously readable in "YYYY-MM-DD" or "YYYYMMDD" format. 

Every date target must have a set of dates (also in YYYYMMDD format) that are valid. For example, a "peak week" target might designate only a set of Sundays as valid dates. This would in essence force the dates/values to be a set of pre-specified dates. In the target description the project owner could specify that, external to Zoltar, the given set of dates would be translated into and represented as, say, MMWR weeks using the `MMWRweek` R package, or week-in-year as in `format(date, "%W")` (i.e., using strptime formatting rules).
 -->


## Valid prediction types by target type

| target type | data_type | point | bin | sample | named | quantile |
|-------------|-----------|-------|-----|--------|-------|----------|
| continuous  |   float   |   x   |  x  |   x    |  (1)  |    x     |
| discrete    |   int     |   x   |  x  |   x    |  (2)  |    x     |
| nominal     |   text    |   x   |  x  |   x    |   -   |    -     |
| binary      |  boolean  |   x   |  x  |   x    |   -   |    -     |
| date        |   date    |   x   |  x  |   x    |   -   |    x     |

Legend:
(1) = valid named distributions are `norm`, `lnorm`, `gamma`, `beta`
(2) = valid named distributions are `pois`, `nbinom`, `nbinom2`
