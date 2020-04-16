# Forecast detail page

The forecast detail pages shows information about a particular forecast, and is divided into two vertical sections with **bold** headings, described next: __Details table__ and __Prediction information__. Here's an example forecast detail page: 

![Forecast detail page](img/forecast-detail-page.png "Forecast detail page")

## Forecast details table

At the top of the page is a table showing information related to the forecast:

- *Model*: A link to the owning [model](ModelDetailPage.md).
- *TimeZero*: The time zero in the owning project that this forecast is for. 
- *Data Source*: The name of the "source" of this forecast, which is typically a file name. 
- *Upload Date*: Date the forecast was uploaded to Zoltar.


## Predictions

The predictions section has a heading like **"Forecast has __ predictions"** (where __ is the actual number) and a summary of the counts of the five different prediction types that can be associated with a forecast: `bin`, `named`, `point`, `quantile`, and `sample`. See [Data Model](DataModel.md) for more information on how forecast data is modeled.