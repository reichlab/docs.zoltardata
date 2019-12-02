# Forecast Targets in Zoltar

Targets are the fundamental data structure of a forecast. In Zoltar, a single forecast made by a model may give
predictions for multiple targets. For example, a single forecast might include a forecast of 1- and 2-week-ahead
incidence and a prediction of when incidence will reach its maximum in a given period of time. When a project is
created, the project owner specifies which targets should be part of any submitted forecast. As we will see below,
targets have specific properties, and there are several different types of targets that determine which properties and
features pertain to a particular target.

## Target types

*Continuous*: A quantitative target whose range encapsulates a section of the real number line. 
> Examples: percentage of all doctors' office visits due to influenza like-illness, or disease incidence per 100,000 population.

*Discrete*: A quantitative target whose range is a set of integer values. 
> Example: the number of incident cases in a time period.

*Nominal*: A nominal, unordered categorical target. 
> Example: severity level in categories of "low", "moderate", and "high".

*Binary*: A binary target, with a defined outcome that can be seen as a 0/1 or TRUE/FALSE. 
> Example: does the maximum value of a variable exceed some threshold C in a given period of time.

*Date*: A special case of a discrete target, where the possible outcomes are distinct units of time. 
> Example: the week in which the peak incidence occurs.

## Target parameters

When defined, all targets have a set of parameters that must be defined. Each type of target then has a set of
additional, sometimes, optional parameters. These are all defined below.

### Required parameters for all targets

- *Name*: A brief name for the target (limit XX characters?).
- *Description*: A verbose description of what the target is. (limit XX characters?)
- *Target Type*: One of the five target types named above.
- *Unit*: E.g., "percent" or "week". The unit label has a superficial purpose used when previewing data and when
  downloading it. For date targets, the unit is required and must be one of the following: "month", "biweek", "week",
  or "day". (See below for more details on how the unit is incorporated into scoring and validation.)
  <!-- NR: [not sure what "previewing data" means] -->
- *Point Value Type*: todo <!-- NGR: [not sure what this is] -->
- *Step Ahead?*: Shows two pieces of information: 1) Whether the target is a "step ahead" one, and (if so) 2) what the
  "step ahead increment" is. (Step ahead targets are used to predict values in the future, and are used by some analysis
  tools.)

### Parameter for continuous targets

- *Range*: (Optional) a numeric vector of length 2 specifying a lower and upper bound of a range for the continuous
  target. The range is assumed to be inclusive on the lower bound and open on the upper bound, e.g. [a, b). If range is
  not specified than range is assumed to be (-infty, infty).
- *BinLwrs*: (Optional, but uploaded `BinLwr` prediction types will be rejected unless these are specified) a set of
  inclusive lower-bounds for the bins of binned distributions. <!-- NGR: is upper bound always specified as infinity?-->

If both Range and BinLwrs are specified, then the min(BinLwrs) must equal the lower bound.

### Parameter for discrete targets

- *Range*: (Optional) an integer vector of length 2 specifying a lower and upper bound of a range for the continuous
  target. The range is assumed to be inclusive on both the lower and upper bounds, e.g. [a, b]. If range is not
  specified than range is assumed to be (-infty, infty).

### Parameter for nominal targets

- *Categories*: (Required) a character vector containing the names of the categories for this target. 

### Parameter for binary targets

None needed.

### Parameters for date targets

- *Unit*: (Required) The unit parameter from the set of parameters required for all targets has a special meaning and
  use for date targets. It is required to be one of "month", "week", "biweek", or "day". This parameter specifies the
  units of the date target and how certain calculations are performed for dates. All inputs for date targets are
  required to be in an unambiguous `%Y-%m-%d` or `%Y%m%d` date format that can be read by a call to `strptime`. This
  parameter determines the units on which scores are calculated. I.e., for the residual error, the calculation for a
  forecast where the point prediction is `forecasted_date` and the unit is "week", the score would be calculated as
  `week(truth_date) - week(forecasted_date)`. Therefore, for the purposes of forecast input for months, weeks, and
  biweeks, the actual day of the month/week/biweek specified in the forecast does not matter, as this level of
  granularity will be ignored by Zoltar. Note: to map dates to biweeks, we use the definitions as presented in Reich et
  al (2017).
- *Bin format*: (Required) a character string defining a `strptime` format for dates used as the labels for categories
  for bincat and samplecat prediction types. E.g., "%Y-%W" for representing, say "2019-12-03" as "2019-48".
- *Bin range*: (Required) a matrix <!--NGR: or some other representation--> with two columns and at least 1 row, where
  every cell has an unambiguous date. The first column represents the lower bounds of the series of dates that are
  valid. The second column represents the upper bounds of the series of dates that are valid. As an example, for a
  weekly target with *Bin format* of "%Y-%W", the following matrix passed as a Bin range

 lb         | ub     
----------- | --------- 
 2011-10-02 | 2012-05-13 
 2012-09-30 | 2013-05-12 
 2013-09-29 | 2014-05-11 
 2014-09-28 | 2015-05-17 
 
would result in valid series of week bins where the first in each series would be from the `lb` column below and the
last in each series would be from the `ub` column below:

 lb      | ub     
-------- | --------- 
 2011-40 | 2012-20 
 2012-40 | 2013-20
 2013-40 | 2014-20
 2014-40 | 2015-20


## Valid prediction types by target type

target type | point     | binary    | named     | binlwr    | sample    | bincat    | samplecat 
----------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- 
continuous  |    x      |    -      |    *      |    x      |    x      |    -      |    -      
discrete    |    x      |    -      |    **     |    -      |    -      |    x      |    x      
nominal     |    x      |    -      |    -      |    -      |    -      |    x      |    x      
binary      |    x      |    x      |    ***    |    -      |    -      |    x      |    x      
date        |    x      |    -      |    -      |    -      |    -      |    x      |    x      

Legend:
* = valid named distributions are `norm`, `lnorm`, `gamma`, `beta`
** = valid named distributions are `pois`, `nbinom`, `nbinom2`
*** = valid named distributions are `bernoulli`

## Available scores by target type

target type | error     | abs error | log score | CRPS      | brier score | PIT 
----------- | --------- | --------- | --------- | --------- | ----------- | ---------  
continuous  |    x      |    x      |    x      |    x      |    -?       |    x      
discrete    |    x      |    x      |    x      |    x      |    -?       |    x      
nominal     |    -      |    -      |    x      |    -?     |    x        |    -      
binary      |    x      |    x      |    x      |    -?     |    x        |    -      
date        |    x      |    x      |    x      |    x      |    -?       |    x      


