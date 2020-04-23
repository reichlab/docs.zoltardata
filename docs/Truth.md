# Truth

Zoltar supports uploading ground truth data for each project that desires automatic scoring. This data is specified as a CSV file as documented in [Truth data format](http://127.0.0.1:8000/FileFormats/#truth-data-format-csv), and each project is responsible for generating the CSV file for their particular set of [time zeros](Concepts.md), [units](Concepts.md) and [targets](Concepts.md). You can tell whether truth has been uploaded to a project by looking at the **Truth Data** row in the [Project details table](http://127.0.0.1:8000/ProjectDetailPage/#project-details-table) section of the [project detail page](ProjectDetailPage.md). It will either be a link with the truth data file name (which means truth is present) and the number of rows in parentheses, or a "Browse..." button next to a green "Upload" button with the text _(No truth data)_ to its right otherwise. Clicking on the link takes you to the Truth detail page documented in [Truth detail page](#view-truth-details) below.

Here's a screen shot showing a project where truth has been uploaded (circled in red):

![Truth uploaded](img/project-detail-page-truth-uploaded.png "Truth uploaded")


And here's just the truth row when no data has been uploaded:

![Truth not uploaded](img/project-detail-page-truth-not-uploaded.png "Truth not uploaded")


Following operations on truth data that you can do from within Zoltar. 


## View truth details

Clicking on the truth link above takes you to the truth details page:

![Truth detail page](img/truth-detail-page.png "Truth detail page")

Here you see a small information table at the top showing the project and truth data filename, followed by a preview of the truth data. At the bottom is a "Download CSV" button that you can click to get the data back as a CSV file.


## Upload truth

Follow these steps to upload a truth CSV file:

1. Go to the [project detail page](ProjectDetailPage.md) of the project of interest.
1. Click the "Browse..." button in the [Project details table](http://127.0.0.1:8000/ProjectDetailPage/#project-details-table)'s **Truth Data** row.
1. In the dialog that appears, select a truth data CSV file in Zoltar's [Truth data format](http://127.0.0.1:8000/FileFormats/#truth-data-format-csv).
1. Click the green upload button.
1. If the file is OK then you will be taken to an upload file job detail page that shows the status of your upload, with the message "Queued the truth file __ for uploading.", where __ is your file's name. See [Check an upload's status](#check_an_uploads_status) below for this page's details.
1. Once the upload is successful (you can refresh the upload file job page to check) then you will the file name as a link as described above.
1. If there was a problem uploading then you will see the upload's status as **FAILED**. The **Failure** section will provide some information to help debug the problem.


## Download truth

Here are the steps to download a project's truth data as a CSV file in Zoltar's [Truth data format](http://127.0.0.1:8000/FileFormats/#truth-data-format-csv):

1. Go to the [project detail page](ProjectDetailPage.md) of the project of interest.
1. Click the truth link above go to the [Truth detail page](#view-truth-details) page.
1. Click the 1. Click the "Download CSV" button and save the file.


## Delete truth

To delete a project's truth data:

1. Go to the [project detail page](ProjectDetailPage.md) of the project of interest.
1. Click the truth link above go to the [Truth detail page](#view-truth-details) page.
1. Click the red trash can button at the top of the page.
1. Click "Delete" in the confirmation dialog that appears. **Note that this cannot be undone!**
