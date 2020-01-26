# Forecast Targets in Zoltar

Targets are the fundamental data structure of a forecast. In Zoltar, a single forecast made by a model may give
predictions for multiple targets. For example, a single forecast might include a forecast of 1- and 2-week-ahead
incidence and a prediction of when incidence will reach its maximum in a given period of time. When a project is
created, the project owner specifies which targets should be part of any submitted forecast. As we will see below,
targets have specific properties, and there are several different types of targets that determine which properties and
features pertain to a particular target.


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

*compositional*: A nominal, unordered categorical target where observations are percentages that add up to 1. 
> Example: the proportions of all sequenced flu strains within different clades.


## Target parameters

When created, all targets have a set of parameters that must be defined. Each type of target then has a set of
additional, sometimes, optional parameters. These are all defined below.

### Summary of allowed, optional, and required parameters, by target type

Here is a table that summarizes which are allowed, optional, and required, by type. legend: 'x' = required, '(x)' = required if `is_step_ahead` is `true`, '-' = disallowed, '~' = optional.

target type   | type | name | description | is_step_ahead |  step_ahead_increment | unit | range | cats 
------------- | ---- | ---- | ----------- | ------------- | ----------------------| ---- | ----- | ---- 
continuous    |  x   |  x   |     x       |      x        |          (x)          |  x   |   ~   |  ~   
discrete      |  x   |  x   |     x       |      x        |          (x)          |  x   |   ~   |  ~   
nominal       |  x   |  x   |     x       |      x        |          (x)          |  -   |   -   |  x   
binary        |  x   |  x   |     x       |      x        |          (x)          |  -   |   -   |  -   
date          |  x   |  x   |     x       |      x        |          (x)          |  x   |   -   |  x   
compositional |  x   |  x   |     x       |      x        |          (x)          |  -   |   -   |  x   

### Required parameters for all targets

- *name*: A brief name for the target. (The number of characters is not limited, but brevity is helpful.)
- *description*: A verbose description of what the target is. (The number of characters is not limited.)
- *type*: One of the five target types named above, e.g., `continuous`.
- *is_step_ahead*: `true` if the target is one of a sequence of targets that predict values at different points in the future.
- *step_ahead_increment*: An integer, indicating the forecast horizon represented by this target. It is required if `is_step_ahead` is `true`. 

### Parameters for continuous targets

- *unit*: (Required) E.g., "percent" or "week".
- *range*: (Optional) a numeric vector of length 2 specifying a lower and upper bound of a range for the continuous
  target. The range is assumed to be inclusive on the lower bound and open on the upper bound, e.g. [a, b). If range is
  not specified than range is assumed to be (-infty, infty).
- *cats*: (Optional, but uploaded `Bin` prediction types will be rejected unless these are specified) an ordered set of
  numeric values indicating the inclusive lower-bounds for the bins of binned distributions. E.g. if `cats` is specified
  as [0, 1.1, 2.2] then the implied set of valid intervals would be [0,1.1), [1.1,2.2) and [2.2, \infty). Additionally, if `range` had been specified as [0, 100] in addition to the above `cats`, then the final bin would be [2.2, 100].
  <!-- NGR: is upper bound always specified as infinity?-->

If both `range` and `cats` are specified, then the min(`cats`) must equal the lower bound and max(`cats`) must be less than the upper bound of `range`.

### Parameters for discrete targets

- *unit*: (Required) E.g., "cases".
- *range*: (Optional, but uploaded `Bin` prediction types will be rejected unless `range` is specified) 
  an integer vector of length 2 specifying a lower and upper bound of a range for the continuous
  target. The range is assumed to be inclusive on both the lower and upper bounds, e.g. [a, b]. If range is not
  specified than range is assumed to be (-infty, infty).
- *cats*: (Optional, and can only be specified if `range` is also specified) an ordered set of
  integer values indicating the inclusive lower-bounds for the bins of binned distributions. E.g. if `cats` is specified
  as [0, 10, 20, 30, 40, 50] and `range` is specified as [0, 100] then the implied set of valid categories would be [0,10),
  [10, 20), [20, 30), [30, 40), [40, 50) and [50, 100].

### Parameters for nominal targets

- *cats*: (Required) a list of strings that name the categories for this target. 

### Parameters for binary targets

None needed.

### Parameters for date targets

- *unit*: (Required) The unit parameter from the set of parameters required for all targets has a special meaning and use for date targets. It is required to be one of "month", "week", "biweek", or "day". This parameter specifies the units of the date target and how certain calculations are performed for dates. All inputs for date targets are required to be in the standard ISO `YYYY-MM-DD` date format. This parameter determines the units on which scores are calculated. I.e., for the residual error, the calculation for a forecast where the point prediction is `forecasted_date` and the unit is "week", the score would be calculated heuristically as `week(truth_date) - week(forecasted_date)`. Note: to map dates to biweeks, we use the definitions as presented in [Reich et al (2017)](https://doi.org/10.1371/journal.pntd.0004761.s001).
- *cats*: (Required) a list of dates in `YYYY-MM-DD` format. These are the only dates that will be considered as valid input for the target. <!-- NGR: do we want to consider encoding the info about which dates are valid for particular ranges of timezeroes? I.e. embed the idea of "seasons" here? I say no, for starters?  -->

<!-- 
General notes on date targets
Date targets are represented by the `dates` data type in the database. On the one hand, original data, submitted with data_type="text" is retained. On the other hand, a transformed version of the data is also retained, as integer values. I order for this transformation to work, we must have a unique, well-defined method to transform the submitted text into integers. We rely on standard libraries for date transformations to ensure the transformations are valid and accurate. 

All input data into date targets must be unambiguously readable in "YYYY-MM-DD" or "YYYYMMDD" format. 

Every date target must have a set of dates (also in YYYYMMDD format) that are valid. For example, a "peak week" target might designate only a set of Sundays as valid dates. This would in essence force the dates/values to be a set of pre-specified dates. In the target description the project owner could specify that, external to Zoltar, the given set of dates would be translated into and represented as, say, MMWR weeks using the `MMWRweek` R package, or week-in-year as in `format(date, "%W")` (i.e., using strptime formatting rules).

Based off of the unit in the target definition, every date would use a fixed unit conversion for point forecast scoring. For example, if `unit=="week"` then point forecast scores would be represented by "week" units. So, the truth for a given timezero-datetarget might be truth="2019-12-15" and a point forecast might be pred="2020-01-05" (both values chosen deliberately to be Sundays). Then we could operate on these numbers as "weeks" and determine the best, standardized way to produce that the difference = truth - pred = 3. 
 -->

### Parameters for compositional targets

- *cats*: (Required) a list of strings that name the categories for this target. 


## Valid prediction types by target type

target type   | data_type | point     |    bin    | sample    |  named     
------------- | --------- | --------- | --------- | --------- | --------- 
continuous    |   float   |    x      |    x      |    x      |   (1)      
discrete      |   int     |    x      |    x      |    x      |   (2)      
binary        |  boolean  |    x      |    x      |    x      |    -      
date          |   date    |    x      |    x      |    x      |    -      
nominal       |   text    |    x      |    x      |    x      |    -      
compositional |   text    |    -      |    x      |    -      |    -      

Legend:
(1) = valid named distributions are `norm`, `lnorm`, `gamma`, `beta`
(2) = valid named distributions are `pois`, `nbinom`, `nbinom2`


## Available scores by target type and prediction element

| target type   | prediction element | error       | abs error | log score           | CRPS | brier | PIT | EMD |
|---------------|--------------------|-------------|-----------|---------------------|------|-------|-----|-----|
| *continuous* | point              | x           | x         | -                   | x(a) | -     | -   | -   |
|               | bin                | -           | -         | x                   | x    | x     | x   | -   |
|               | named              | -           | -         | x                   | x    | -     | x   | -   |
|               | sample             | -           | -         | x(b)                | x    | -     | x   | -   |
| *discrete*    | point              | x           | x         | -                   | x(a) | -     | -   | -   |
|               | bin                | -           | -         | x                   | x    | x     | x   | -   |
|               | named              | -           | -         | x                   | x    | -     | x   | -   |
|               | sample             | -           | -         | x(b)                | x    | -     | x   | -   |
| *nominal*     | point              | -           | -         | -                   | -    | -     | -   | -   |
|               | bin                | -           | -         | x                   | -    | x     | -   | -   |
|               | sample             | -           | -         | x                   | -    | x     | -   | -   |
| *binary*      | point              | x           | x         | -                   | x(a) | -     | -   | -   |
|               | bin                | -           | -         | x                   | x    | x     | -   | -   |
|               | sample             | -           | -         | x(b)                | x    | x     | -   | -   |
| *date*        | point              | x           | x         | -                   | x(a) | -     | -   | -   |
|               | bin                | -           | -         | x                   | x    | x     | x   | -   |
|               | sample             | -           | -         | x(b)                | x    | -     | x   | -   |
|*compositional*| bin                | -           | -         | -                   | -    | -     | -   | x   |

* x(a) = CRPS is equivalent to abs error for point forecasts.
* x(b) = log score is required to be computed by approximation
* EMD = earth mover's distance, PIT = probability integral transform, CRPS = continuous ranked probability score

