# Forecast validation

Forecasts stored in Zoltar are validated upon upload based on the expected structure of each forecast.
Below, we document the checks and tests that are performed on all forecasts. 
We first list the test that is performed for every prediction, and after that, tests are broken down by the class of prediction.

### Definitions

For clarity, we define specific terms that we will use below.

 - Forecast: a collection of data specific to a project > model > timezero.
 - Prediction: a group of a prediction elements(s) specific to a location and target.
 - Prediction Element: data that define a unique single prediction, specific to the “type” of prediction it is.
 - Database Row: the entry(ies)/row(s) in the database that comprise a prediction element.

## Tests applied to all forecasts

- Within a Prediction, there cannot be more than 1 Prediction Element of the same type.
- Field type formats: all elements must parse as correct type: int, float, text.

## Tests applied to `BinCat` Prediction Elements

 - If a BinCat Prediction Element exists, it should have >=1 Database Rows.
 - |cat| = |prob|. The number of elements in the cat and prob vectors are identical.
 - cat (t): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`. No duplicate category names are allowed. Entries in cat must be a subset of `Target.cats` from the target definition.
 - prob (f): Entries in the database rows must be numbers in [0, 1]. For one prediction element, the values within prob must sum to 1.0 (values in [0.99, 1.01] are acceptable). 

NB: Bins where prob == 0 are not stored in the database.

## Tests applied to `BinLwr` Prediction Elements

 - If a BinLwr Prediction Element exists, it should have >=1 Database Rows.
 - `|lwr| = |prob|`. The number of elements in the `lwr` and `prob` vectors are identical.
 - `lwr` (f): Entries in the database rows in the `lwr` column cannot be `“”`, `“NA”` or `NULL`. Ascending order. Entries in `lwr` must be a subset of `Target.lwrs` from the target definition.
 - `prob` (f): [0, 1]. Entries in the database rows must be numbers in [0, 1]. For one prediction element, the values within prob must sum to 1.0 (values in [0.99, 1.01] are acceptable). 
 - NB: Bins where prob == 0 are not stored in the database.

## Tests applied to `Binary` Prediction Elements

 - If a Binary Prediction Element exists, it should have exactly 1 Database Row.
 - `prob` (f): Entry must be a number in [0, 1]. Entries in this database row cannot be `“”`, `“NA”` or `NULL`.
 
## Tests applied to `Named` Prediction Elements

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

## Tests applied to `Point` Prediction Elements
 - If a Point Prediction Element exists, it should have exactly 1 Database Row.
 - `value` (i, f, t): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`. 
 - The data format of `value` should correspond or be translatable to the `target_type` as in the target definition.
 
## Tests applied to `Sample` Prediction Elements
 - If a Sample Prediction Element exists, it should have >=1 Database Rows.
 - `sample` (f): Entries in the database rows in the cat column cannot be `“”`, `“NA”` or `NULL`.

## Tests applied to `SampleCat` Prediction Elements
 - If a SampleCat Prediction Element exists, it should have >=1 Database Rows.
 - `|cat| = |sample|`. The number of elements in the `cat` and `sample` vectors are identical.
 - `cat` (t): Not `NA`. No duplications.
 - `sample` (t): Not `NA`.
 - All values in `sample` must be included in `cat` as in the target definition (but each `cat` does not necessarily need to be included in `sample`),



