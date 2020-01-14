# Forecast validation

Forecasts stored in Zoltar are validated upon upload based on the expected structure of each forecast. Below, we document the checks and tests that are performed on all forecasts. We first list the test that is performed for every prediction, and after that, tests are broken down by the class of prediction.

### Definitions

For clarity, we define specific terms that we will use below.

 - Forecast: a collection of data specific to a project > model > timezero.
 - Prediction: a group of a prediction elements(s) specific to a location and target.
 - Prediction Element: data that define a unique single prediction, specific to the class of prediction it is.
 - Prediction Class: data structures representing different types of predictions, e.g. "Point" and "Bin" (see [Data Model](DataModel.md) for more detail)
 - Target Type: the classification for a specific forecast target, one of "continuous", "discrete", "nominal", "binary" or "date" (see [Targets](Targets.md) for more info)
 - Database Row: the entry(ies)/row(s) in the database that comprise a prediction element.


## Tests for all Prediction Elements

These tests are performed when a forecast is created or updated.

- Within a Prediction, there cannot be more than 1 Prediction Element of the same type.


## Tests for Prediction Elements by Prediction Class

These tests are performed when a forecast is created or updated.


### `Bin` Prediction Elements

 - If a Bin Prediction Element exists, it should have >=1 Database Rows.
 - `|cat| = |prob|`. The number of elements in the `cat` and `prob` vectors are identical.
 - `cat` (i, f, t, d): Entries in the database rows in the `cat` column cannot be `“”`, `“NA”` or `NULL`. Ascending order. Entries in `cat` must be a subset of `Target.cat` from the target definition.
 - `prob` (f): [0, 1]. Entries in the database rows must be numbers in [0, 1]. For one prediction element, the values within prob must sum to 1.0 (values in [0.99, 1.01] are acceptable). 
 - NB: Bins where prob == 0 are not stored in the database.

### `Named` Prediction Elements

 - If a Named Prediction Element exists, it should have exactly 1 Database Row.
 - `family`: must be one of the below choices
 - `param1`, `param2`, `param3` (f): The number of param columns with non-NULL entries count must match family definition (see note below)

For reference, here is the mapping between the generic parameter names and the family-specific use of them (based on https://github.com/cdcepi/predx/blob/master/predx_classes.md ):

Family      | param1    | param2    | param3 
----------- | --------- | --------- | --------- 
Normal      |    mean   |  sd       |  -        
LogNormal   |    mean   |  sd       |  -        
Gamma       |    shape  |  rate     |    -      
Beta        |    a      |    b      |    -    
Bernoulli   |    p      |    -      |    -      
Binomial    |    p      |  n        |  -        
Poisson     |    mean   |  -        |    -      
Neg.Binom1  |    r      |    p      |    -    
Neg.Binom2  |    mean   |  disp     |    -      

### `Point` Prediction Elements
 - If a Point Prediction Element exists, it should have exactly 1 Database Row.
 <!-- NGR: This won't be true for compositional targets. -->
 - `value` (i, f, t, d): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`. 
 - The data format of `value` should correspond or be translatable to the `type` as in the target definition.
 
### `Sample` Prediction Elements
 - If a Sample Prediction Element exists, it should have >=1 Database Rows.
 - `sample` (i, f, t, d): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`.


## Tests for Predictions by Target Type

These tests are performed when a forecast is created or updated. 

### "continuous"

 - Within one prediction, there must not be more than one of the following prediction elements for a single target: {`Named`, `Bin`}.
 
### "discrete"

 - Within one prediction, there must not be more than one of the following prediction elements for a single target: {`Named`, `Bin`}.

### "binary"

 - Within one prediction, there must not be more than one of the following prediction elements for a single target: {`Point`, `Named`}.
 

## Tests for Prediction Elements by Target Type

These tests are performed when a forecast is created or updated. For all target types, only [valid Prediction Types](Targets.md#valid-prediction-types-by-target) are accepted.

### "continuous"

 - any values in Point or Sample Prediction Elements should be numeric
 - if `range` is specified, any values in Point or Sample Prediction Elements should be contained within `range`
 - if `range` is specified, any Named Prediction Element should have negligible probability density outside of the range (< specified tolerance)
 - for `Bin` Prediction Elements, the submitted set of `cat` values must be a subset of the `cat` defined by the target
 - for `Named` Prediction Elements, the distribution must be one of `norm`, `lnorm`, `gamma`, `beta`

### "discrete"

 - any values in `Point` or `Sample` Prediction Elements should be numeric
 - if `range` is specified, any values in `Point` or `Sample` Prediction Elements should be contained within `range`
 - if `range` is specified, any `Named` Prediction Element should have negligible probability density outside of the range (< specified tolerance)
 - for `Bin` Prediction Elements, the submitted set of `cat` must be a subset of the valid integers  defined by the target range
 - for `Named` Prediction Elements, the distribution must be one of `pois`, `nbinom`, `nbinom2`.

### "nominal" 

 - any values in `Point` or `Sample` Prediction Elements should be contained within the valid set of `cat` defined by the variable
 - for `Bin` Prediction Elements, the submitted set of `cat` in the prediction must be a subset of the `cat` defined by the target


### "binary"

 - any values in `Point` Prediction Elements should be a real number in [0,1]
 - any values in `Sample` Prediction Elements should be either 0 or 1.
 - for `Named` Prediction Elements, the family must be `bernoulli`.

### "date"

 - any values in `Point` or `Sample` Prediction Elements should be string that can be interpreted as a date in `YYYY-MM-DD` format, and these values should be contained within the set of valid responses defined by `date`.
 - for `Bin` Prediction Elements, the submitted set of `cat` must be a subset of the valid outcomes defined by the target range.

### "compositional" 

 - for `Bin` Prediction Elements, the submitted set of `cat` in the prediction must be a subset of the `cat` defined by the target


## Tests for target definitions by Target Type

These tests are performed when a target is created or updated.

### "continuous"

 - if both `range` and `cat` are specified, then the `min(cat)` must equal the lower bound.
 - `range` lower bound must be numeric and smaller than upper bound. 
 - if `range` is specified, is assumed to be inclusive on the lower bound and open on the upper bound, e.g. [a, b).

### "discrete"

 - if `range` is specified, it must include two numbers.

### "nominal" and "compositional"

 - `cat` must be a character vector containing a set of unique labels of the categories for this target. The labels must not include `""`, `NA` or `null`.

### "binary"

 - none.

### "date"

 - the `unit` parameter is required to be one of `month`, `week`, `biweek`, or `day`
 - the `date` parameter must contain a list of text elements in `YYYY-MM-DD` format that can be interpreted as dates.


## Tests for ground truth data tables

Please see [this file](../zoltar-ground-truth-example.csv) for an example of a valid specification of ground-truth values.

### For all ground truth files

 - Every value of `timezero`, `target` and `location` must be in the list of valid values defined by the project configuration file. (Note: not every combination needs to exist for the file to be valid.)
 - Each ground truth file should have a `cat` column (readable as text) and a `value` column (readable as a float). 

### For all target_types except `compositional`

 - For every unique `target`-`location`-`timezero` combination, there should be either one or zero rows of truth data.
 - For each row, there should be no more than 1 of the `cat` and `value` columns should contain data.
 - The `cat` column should have `NULL` values for all rows corresponding to `continuous`, `binary` and `discrete` targets.
 - The `value` column should have `NULL` values for all rows corresponding to `nominal` and `date` targets.
 - The value of the truth data (in whichever column it exists) should be interpretable as the corresponding data_type of the specified target. E.g., for a row corresponding to a `date` target, the entry must contain a valid ISO-formatted date string. 

### For `compositional` type

 - For every unique `target`-`location`-`timezero` combination with a `compositional` target type, there should be between 0 and C rows of truth data, where C is the total number of categories defined in the project config file for this target.
 - The entries in the `value` column for a single `target`-`location`-`timezero` combination should sum to 1.

### Range-check for ground truth data

The following test can be applied to any target with a range. This will always apply to `binary`, `nominal`, `compositional`, and `date` targets, as these targets are required to have sets of valid values specified as part of the target definition. If the `range` parameter is specified for a `continuous` or `discrete` target, then the following test will be applied to that target as well.

For `binary`, `compositional`, and (if `range` is specified) for `discrete and `continuous` targets:
 - The entry in the `value` column (or entries, for compositional targets) for a specific `target`-`location`-`timezero` combination must be contained within the range of valid values for the target. For `binary` and `compositional` targets, the values must be in the range of [0,1].
 
For `nominal`, `compositional` and `date` target_types:
 - The entry in the `cat` column (or entries, for compositional targets) for a specific `target`-`location`-`timezero` combination must be contained within the set of valid values for the target, as defined by the project config file.
