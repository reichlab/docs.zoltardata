# Forecast validation

Forecasts stored in Zoltar are validated upon upload based on the expected structure of each forecast. Below, we document the checks and tests that are performed on all forecasts. We first list the test that is performed for every prediction, and after that, tests are broken down by the class of prediction.

## Definitions

For clarity, we define specific terms that we will use below.

 - Forecast: a collection of data specific to a project > model > timezero.
 - Prediction: a group of a prediction elements(s) specific to a unit and target.
 - Prediction Element: data that define a unique single prediction, specific to the class of prediction it is.
 - Prediction Class: data structures representing different types of predictions, e.g. "point" and "bin" (see [Data Model](DataModel.md) for more detail)
 - Target Type: the classification for a specific forecast target, one of "continuous", "discrete", "nominal", "binary" or "date" (see [Targets](Targets.md) for more info)
 - Database Row(s): the entry(ies)/row(s) in the database that comprise a prediction element.


## Tests for all prediction elements

These tests are performed when a forecast is created or updated.

- The prediction's class must be valid for its target's type (see [Valid prediction types by target type](Targets.md#Valid prediction types by target type).
- Within a prediction, there cannot be more than 1 prediction element of the same class.


## Tests for prediction elements by Prediction Class

These tests are performed when a forecast is created or updated.


### `bin` prediction elements

- If a bin prediction element exists, it should have >=1 database rows.
- `|cat| = |prob|`. The number of elements in the `cat` and `prob` vectors should be identical.
- `cat` (i, f, t, d, b): Entries in the database rows in the `cat` column cannot be `“”`, `“NA”` or `NULL` (case does not matter). Entries in `cat` must be a subset of `Target.cats` from the target definition.
- `prob` (f): [0, 1]. Entries in the database rows in the `prob` column must be numbers in [0, 1]. For one prediction element, the values within prob must sum to 1.0 (values within +/- 0.001 of 1 are acceptable).
- The data format of `cat` should correspond or be translatable to the `type` as in the target definition.

### `named` prediction elements

We note that `named` predictions currently only support fairly simple distributions. We currently support distributions with up to three parameters. Future versions of Zoltar could support distributions with larger numbers of parameters.

 - If a named prediction element exists, it should have exactly 1 Database Row.
 - `family`: must be one of the abbreviations shown in the table below.
 - `param1`, `param2`, `param3` (f): The number of param columns with non-NULL entries count must match family definition (see note below).
 - Parameters for each distribution must be within valid ranges, which, if constraints exist, are specified in the table below.

For reference, here is the mapping between the generic parameter names and the family-specific use of them (based on [predx_classes.md](https://github.com/cdcepi/predx/blob/master/predx_classes.md)):

Family      | abbreviation | param1    | param2   | param3 
----------- | ------------ | --------- | -------- | ------ 
Normal      | `norm`       | mean      | sd>=0    |    -   
LogNormal   | `lnorm`      | mean      | sd>=0    |    -   
Gamma       | `gamma`      | shape>0   | rate>0   |    -   
Beta        | `beta`       | a>0       | b>0      |    -   
Poisson     | `pois`       | rate>0    |  -       |    -   
Neg.Binom1  | `nbinom`     | r>0       | 0<=p<=1  |    -   
Neg.Binom2  | `nbinom2`    | mean>0    | disp>0   |    -   

<!-- These distributions are not supported for now.
Bernoulli   | 0<=p<=1   |    -      |    -      
Binomial    | 0<=p<=1   |   n>0     |    - 
-->

### `point`, `mean`, `median`, and `mode` prediction elements

 - If a `point`, `mean`, `median`, or `mode` prediction element exists, it should have exactly 1 Database Row for all targets.
 - `value` (i, f, t, d, b): Entries in the database rows in the `value` column cannot be `“”`, `“NA”` or `NULL` (case does not matter).
 - The data format of `value` should correspond or be translatable to the `type` as in the target definition.

### `sample` prediction elements

 - If a sample prediction element exists, it should have >=1 database rows.
 - `sample` (i, f, t, d, b): Entries in the database rows in the `sample` column cannot be `“”`, `“NA”` or `NULL` (case does not matter).
 - The data format of `sample` should correspond or be translatable to the `type` as in the target definition.


### `quantile` prediction elements

- If a quantile prediction element exists, it should have >=1 database rows.
- `|quantile| = |value|`. The number of elements in the `quantile` and `value` vectors should be identical.
- `quantile` (f): [0, 1]. Entries in the database rows in the `quantile` column must be numbers in [0, 1]. `quantile`s must be unique.
- `value` (i, f, d): Entries in `value` must be non-decreasing as quantiles increase. Entries in `value` must obey existing ranges for targets.
- The data format of `value` should correspond or be translatable to the `type` as in the target definition.


## Tests for predictions by target type

These tests are performed when a forecast is created or updated.


### "continuous"

 - Within one prediction, there can be at most one of the following prediction elements, but not both: {`named`, `bin`}.

### "discrete"

 - Within one prediction, there can be at most one of the following prediction elements, but not both: {`named`, `bin`}.


## Tests for prediction elements by target type

These tests are performed when a forecast is created or updated. For all target types, only [valid Prediction Types](Targets.md#valid-prediction-types-by-target) are accepted.

### "continuous"

 - any values in `point`, `mean`, `median`, `mode`, or `sample` prediction elements should be numeric
 - if `range` is specified, any values in `point` or `sample` prediction elements should be contained within `range`
 - if `range` is specified, any `named` Prediction Element should have negligible probability density (no more than 0.001 density) outside of the range.
 - for `bin` prediction elements, the submitted set of `cat` values must be a subset of the `cats` defined by the target
 - for `named` prediction elements, the distribution must be one of `norm`, `lnorm`, `gamma`, `beta`

### "discrete"

 - any values in `point`, `mean`, `median`, `mode`, or `sample` prediction elements should be integers
 - if `range` is specified, any values in `point` or `sample` prediction elements should be contained within `range`
 - if `range` is specified, any `named` Prediction Element should have negligible probability density (no more than 0.001 density) outside of the range
 - for `bin` prediction elements, the submitted set of `cat` values must be a subset of the `cats` defined by the target
 - for `named` prediction elements, the distribution must be one of `pois`, `nbinom`, `nbinom2`.

### "nominal"

 - any values in `point`, `mean`, `median`, `mode`, or `sample` prediction elements should be contained within the valid set of `cats` defined by the target
 - for `bin` prediction elements, the submitted set of `cat` values must be a subset of the `cats` defined by the target

### "binary"

 - any values in `point`, `mean`, `median`, `mode`, or `sample` prediction elements should be either `true` or `false`.
 - for `bin` prediction elements, there must be exactly two `cat` values labeled `true` and `false`. These are the two `cats` that are implied (but not allowed to be specified) by binary target types.

### "date"

 - any values in `point`, `mean`, `median`, `mode`, or `sample` prediction elements should be string that can be interpreted as a date in `YYYY-MM-DD` format, and these values should be contained within the set of valid responses defined by `cats` defined by the target.
 - for `bin` prediction elements, the submitted set of `cats` must be a subset of the valid outcomes defined by the target range.


## Tests for target definitions by target type

These tests are performed when a target is created or updated.

### "continuous"

 - if both `range` and `cats` are specified, then the `min(cats)` must equal the lower bound and `max(cats)` must be less than the upper bound.
 - if `range` is specified it must contain two numeric values
 - `range` lower bound must be smaller than the upper bound. 
 - if `range` is specified, is assumed to be inclusive on the lower bound and open on the upper bound, e.g. [a, b).

### "discrete"

 - if `range` is specified, it must include two integers.

### "nominal"

 - `cats` must be a character vector containing a set of unique labels of the categories for this target. The labels must not include `""`, `NA` or `NULL` (case does not matter).

### "binary"

 - none.

### "date"

 - the `unit` parameter is required to be one of `month`, `week`, `biweek`, or `day`
 - the `date` parameter must contain a list of text elements in `YYYY-MM-DD` format that can be interpreted as dates.


## Tests for ground truth data tables

Please see [zoltar-ground-truth-example.csv](https://github.com/reichlab/docs.zoltardata/blob/master/docs/zoltar-ground-truth-example.csv) for an example of a valid specification of ground-truth values.

### For all ground truth files

 - The columns are `timezero`, `unit`, `target`, and `value`.
 - For every unique `target`-`unit`-`timezero` combination, there should be either one or zero rows of truth data.
 - Every value of `timezero`, `target` and `unit` must be in the list of valid values defined by the project configuration file. (Note: not every combination needs to exist for the file to be valid.)
 - The `value` of the truth data cannot be `“”`, `“NA”` or `NULL` (case does not matter).
 - The `value` of the truth data should be interpretable as the corresponding `data_type` of the specified target. E.g., for a row corresponding to a `date` target, the entry must contain a valid ISO-formatted date string.

### Range-check for ground truth data

The following test can be applied to any target with a `range`. This will always apply to `binary`, `nominal`, and `date` targets, as these targets are required to have sets of valid values specified as part of the target definition. If the `range` parameter is specified for a `continuous` or `discrete` target, then the following test will be applied to that target as well.

For `binary` targets:
 - The entry in the `value` column for a specific `target`-`unit`-`timezero` combination must be either `true` or `false`.

For `discrete` and `continuous` targets (if `range` is specified):
 - The entry in the `value` column for a specific `target`-`unit`-`timezero` combination must be contained within the `range` of valid values for the target. If `cats` is specified but `range` is not, then there is an implicit range for the ground truth value, and that is between min(`cats`) and \infty.
 
For `nominal` and `date` target_types:
 - The entry in the `value` column for a specific `target`-`unit`-`timezero` combination must be contained within the set of valid `cats` for the target, as defined by the project config file.
