# Model detail page

A _model_ is the representation of code that generates forecasts. Clicking on a model link takes you to its detail page.
The detail page is divided into two vertical sections, described next: Details table and forecasts list. Here's an
example model detail page:

![Model detail page](img/model-detail-page.png "Model detail page")


## Model details table

At the top of the page is a table showing information related to the model:

- *Name*: The model's name.
- *Abbreviation*: A short name for the model. It's used as the column name in downloaded scores.
- *Owner*: The model's owner. The owner is the user that created the model (which is done on the home page), and she can
  edit or delete the model, and upload or delete its forecasts.
- *Project*: A link to the project the model belongs to.
- *Team name*: The name of the team that developed the model. This is not used directly by Zoltar.
- *Description*: Prose provided by model owner. It should include information on reproducing the model's results.
- *Home*: A link to the model home page.
- *Auxiliary data*: An optional link to model-specific data files that were used by the model beyond the project's core
  data. Not used directly by Zoltar.


## Forecasts

The **Forecasts** section lists the model's forecasts, with links to forecast detail pages (see [forecast detail
page](ForecastDetailPage.md) for more information). Each forecast is data associated with a particular time zero in the
project. The data is loaded from a file with a specific format (see [file formats](FileFormats.md) for details). There
is one line per time zero, specifying the time zero date (but not the data version date), the original forecast data
_source_ that was uploaded (usually a file name), and an **Action** button, either a green upload one if there is no 
data associated with the time zero or a red delete button otherwise. Clicking on the filename link takes you to a
[forecast detail page](ForecastDetailPage.md) that includes a data preview plus a **Download** button.
