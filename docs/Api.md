# API

Zoltar's functionality is accessible via the following [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer) endpoints. All results are JSON. The API is browsable from the [root URI](https://www.zoltardata.com/api/) on the home page (look for `API` buttons on any page), and is a great starting point for developers. Note that all projects and users are listed on the home page, but private projects, their models, and their forecasts, can only be accessed by authorized accounts.

## Endpoints

The following endpoints are available. All are under the `<host>`, typically `https://www.zoltardata.com`.

- `api`: the API root (currently just an object with one key, `projects`, that's an array of all projects)
- `api/projects/`: an array of all projects

- `api/project/<project_id>/units/`: an array of the project's units
- `api/project/<project_id>/targets/`: "" targets
- `api/project/<project_id>/timezeros/`: "" timezeros
- `api/project/<project_id>/models/`: "" forecast models

- `api/project/<project_id>/`: project detail. an object with these keys: `id`, `url`, `owner`, `is_public`, `name`, `description`, `home_url`, `logo_url`, `core_data`, `time_interval_type`, `visualization_y_label`, `truth`, `model_owners`, `score_data`, `models`, `units`, `targets`, `timezeros`

- `api/project/<project_id>/truth/`: project truth detail. an object with these keys: `id`, `url`, `project`, `truth_csv_filename`, `truth_data`
- `api/project/<project_id>/truth_data/`: truth data as CSV. has these columns: `timezero`, `unit`, `target`, `value`
- `api/project/<project_id>/score_data/`: score data "". columns: `timezero`, `unit`, `target`, `value`

- `api/unit/<unit_id>/`: unit detail. an object with these keys: `id`, `url`, `name`
- `api/target/<target_id>/`: target detail. an object with these keys: `id`, `url`, `name`, `type`, `description`, `is_step_ahead`
- `api/timezero/<timezero_id>/`: timezero detail. an object with these keys: `id`, `url`, `timezero_date`, `data_version_date`, `is_season_start`

- `api/model/<model_id>/`: forecast model detail. an object with these keys: `id`, `url`, `project`, `owner`, `name`, `abbreviation`, `description`, `home_url`, `aux_data_url`, `forecasts`
- `api/model/<model_id>/forecasts/`: a list of a model's forecast URLs (see forecast detail below)

- `api/forecast/<forecast_id>/`: forecast detail. an object with these keys: `id`, `url`, `forecast_model`, `source`, `time_zero`, `created_at`, `forecast_data`
- `api/forecast/<forecast_id>/data/`: forecast data as JSON. (See [file formats](FileFormats.md) for details.)
