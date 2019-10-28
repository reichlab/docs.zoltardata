# API

Zoltar's functionality is accessible via the following [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer) 
endpoints. All results are JSON. The API is browsable from the [root URI](https://www.zoltardata.com/api/) on the home
page (look for `API` buttons on any page), and is a great starting point for developers. Note that all projects and 
users are listed on the home page, but private projects, their models, and their forecasts, can only be accessed by 
authorized accounts.

Endpoints:

    api/ # browsable API root
    api/projects/ # list of all projects
    api/project/[project_id]/ # project detail
    api/project/[project_id]/template/ # template detail
    api/project/[project_id]/template_data/ # template, formatted as JSON - see above
    api/project/[project_id]/truth/ # truth detail
    api/project/[project_id]/truth_data/ # truth data
    api/user/[user_id]/ # user detail
    api/model/[model_id]/ # model detail
    api/forecast/[forecast_id]/ # forecast detail
    api/forecast/[forecast_id]/data/ # forecast data as JSON - see above
