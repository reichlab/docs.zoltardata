# Forecast validation

Forecasts stored in Zoltar are validated upon upload based on the expected structure of each forecast. Below, we
document the checks and tests that are performed on all forecasts. We first list the test that is performed for every
prediction, and after that, tests are broken down by the class of prediction.

### Definitions

For clarity, we define specific terms that we will use below.

 - Forecast: a collection of data specific to a project > model > timezero.
 - Prediction: a group of a prediction elements(s) specific to a location and target.
 - Prediction Element: data that define a unique single prediction, specific to the class of prediction it is.
 - Prediction Class: data structures representing different types of predictions, e.g. "point" and "binLwr" (see 
   [Data Model](DataModel.md) for more detail)
 - Target Type: the classification for a specific forecast target, one of "continuous", "discrete", "nominal", "binary"
   or "date" (see [Targets](Targets.md) for more info)
 - Database Row: the entry(ies)/row(s) in the database that comprise a prediction element.

## Tests for all Prediction Elements

These tests are performed when a forecast is created or updated.

- Within a Prediction, there cannot be more than 1 Prediction Element of the same type.

## Tests for Prediction Elements by Prediction Class

These tests are performed when a forecast is created or updated.

### `BinCat` Prediction Elements

 - If a BinCat Prediction Element exists, it should have >=1 Database Rows.
 - |cat| = |prob|. The number of elements in the cat and prob vectors are identical.
 - `cat` (t): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`. No duplicate category names
   are allowed. Entries in cat must be a subset of `Target.cats` from the target definition.
 - `prob` (f): Entries in the database rows must be numbers in [0, 1]. For one prediction element, the values within prob
   must sum to 1.0 (values in [0.99, 1.01] are acceptable). 

NB: Bins where prob == 0 are not stored in the database.

### `BinLwr` Prediction Elements

 - If a BinLwr Prediction Element exists, it should have >=1 Database Rows.
 - `|lwr| = |prob|`. The number of elements in the `lwr` and `prob` vectors are identical.
 - `lwr` (f): Entries in the database rows in the `lwr` column cannot be `“”`, `“NA”` or `NULL`. Ascending order.
   Entries in `lwr` must be a subset of `Target.lwr` from the target definition.
 - `prob` (f): [0, 1]. Entries in the database rows must be numbers in [0, 1]. For one prediction element, the values
   within prob must sum to 1.0 (values in [0.99, 1.01] are acceptable). 
 - NB: Bins where prob == 0 are not stored in the database.

### `Binary` Prediction Elements

 - If a Binary Prediction Element exists, it should have exactly 1 Database Row.
 - `prob` (f): Entry must be a number in [0, 1]. Entries in this database row cannot be `“”`, `“NA”` or `NULL`.
 
### `Named` Prediction Elements

 - If a Named Prediction Element exists, it should have exactly 1 Database Row.
 - `family`: must be one of the below choices
 - `param1`, `param2`, `param3` (f): The number of param columns with non-NULL entries count must match family
   definition (see note below)

For reference, here is the mapping between the generic parameter names and the family-specific use of them (based on
https://github.com/cdcepi/predx/blob/master/predx_classes.md ):

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
 - `value` (i, f, t): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`. 
 - The data format of `value` should correspond or be translatable to the `target_type` as in the target definition.
 
### `Sample` Prediction Elements
 - If a Sample Prediction Element exists, it should have >=1 Database Rows.
 - `sample` (f): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`.

### `SampleCat` Prediction Elements
 - If a SampleCat Prediction Element exists, it should have >=1 Database Rows.
 - `|cat| = |sample|`. The number of elements in the `cat` and `sample` vectors are identical.
 - `cat` (t): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`. No duplicate category
   names are allowed. Entries in cat must be a subset of `Target.cats` from the target definition.
 - `sample` (t): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`.
 - All values in `sample` must be included in `cat` as in the target definition (but each `cat` does not necessarily
   need to be included in `sample`),


## Tests for Predictions by Target Type

These tests are performed when a forecast is created or updated. 

### "continuous"

 - Within one prediction, there must not be more than one of the following prediction elements for a single target: {`Named`, `BinLwr`}.
 
### "discrete"

 - Within one prediction, there must not be more than one of the following prediction elements for a single target: {`Named`, `Bin`}.

### "binary"

 - Within one prediction, there must not be more than one of the following prediction elements for a single target: {`Point`, `Named`}.
 

## Tests for Prediction Elements by Target Type

These tests are performed when a forecast is created or updated. For all target types, only
[valid Prediction Types](Targets.md#valid-prediction-types-by-target) are accepted.

### "continuous"

 - any values in Point or Sample Prediction Elements should be numeric
 - if `range` is specified, any values in Point or Sample Prediction Elements should be contained within `range`
 - if `range` is specified, any Named Prediction Element should have negligible probability density outside of the range
   (< specified tolerance)
 - for BinLwr Prediction Elements, the submitted set of `lwr` values must be a subset of the `lwr` defined by the target
 - for Named Prediction Elements, the distribution must be one of `norm`, `lnorm`, `gamma`, `beta`

### "discrete"

 - any values in `Point` or `SampleCat` Prediction Elements should be numeric
 - if `range` is specified, any values in `Point` or `SampleCat` Prediction Elements should be contained within `range`
 - if `range` is specified, any `Named` Prediction Element should have negligible probability density outside of the 
   range (< specified tolerance)
 - for `BinCat` Prediction Elements, the submitted set of `cats` must be a subset of the valid integers  defined by the 
   target range
 - for `Named` Prediction Elements, the distribution must be one of `pois`, `nbinom`, `nbinom2`.

### "nominal" 

 - any values in `Point` or `SampleCat` Prediction Elements should be contained within the valid set of `cats` defined 
   by the variable
 - for `BinCat` Prediction Elements, the submitted set of `cats` in the prediction must be a subset of the `cats` 
   defined by the target


### "binary"

 - any values in `Point` Prediction Elements should be a real number in [0,1]
 - any values in `SampleCat` Prediction Elements should be either 0 or 1.
 - for `BinCat` Prediction Elements, there should be two categories, labeled `0` and `1`.
 - for `Named` Prediction Elements, the family must be `bernoulli`.

### "date"

 - any values in `Point` or `SampleCat` Prediction Elements should be string that can be interpreted as a date in
   `YYYY-MM-DD` format, and these values should be contained within the set of valid reponses defined by
   `dates`.
 - for `BinCat` Prediction Elements, the submitted set of `cats` must be a subset of the valid outcomes defined by the
   target range.

### "compositional" 

 - for `BinCat` Prediction Elements, the submitted set of `cats` in the prediction must be a subset of the `cats` 
   defined by the target


## Tests for target definitions by Target Type

These tests are performed when a target is created or updated.

### "continuous"

 - if both `range` and `lwr` are specified, then the `min(lwr)` must equal the lower bound.
 - `range` lower bound must be numeric and smaller than upper bound. 
 - if `range` is specified, is assumed to be inclusive on the lower bound and open on the upper bound, e.g. [a, b).

### "discrete"

 - if `range` is specified, it must include two numbers.

### "nominal" and "compositional"

 - `categories` must be a character vector containing a set of unique labels of the categories for this target. The
   labels must not include `""`, `NA` or `null`.

### "binary"

 - none.

### "date"

 - the `unit` parameter is required to be one of `month`, `week`, `biweek`, or `day`
 - the `dates` parameter must contain a list of text elements in `YYYY-MM-DD` format that can be interpreted as dates.

