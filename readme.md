# Zoltar documentation site source

This repository holds documentation content for all aspects of [Zoltar](https://www.zoltardata.com/) such as the web
site user guide, help for researchers, API and client libraries, etc. The documentation source format is 
[Markdown](https://python-markdown.github.io/), which [Mkdocs](https://www.mkdocs.org/) uses to generate the static
site.


# Requirements (see Pipfile)
- [Python 3](http://install.python-guide.org)
- [pipenv](https://docs.pipenv.org/)
- [MkDocs](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)


## Installation
To install required packages:
```bash
$ cd <readme.md's dir>
$ pipenv --three
$ pipenv shell
$ pipenv install
```

Pipfile was created via:
```bash
pipenv install mkdocs
pipenv install mkdocs-material
```


## Workflow
- Edit content located in the `docs/` directory. Note: Only edit on the `master` branch, **not** the `gh-pages` one. 
  The latter is overwritten by the `mkdocs gh-deploy` command when deploying (see below).
- Preview the documentation locally. To run a local development server:
```bash
$ cd <readme.md's dir>
$ pipenv shell
$ mkdocs serve
```
- Commit and push your changes.
- Deploy to [GitHub Pages](https://pages.github.com/):
To deploy the site to Github pages:
```bash
$ cd <readme.md's dir>
$ pipenv shell
$ mkdocs gh-deploy
```


# todo: content
## ProjectDetailPage.md
- bring up to date, esp. configuration

## FileFormats.md
- Forecast data format: when done, remove from: utils/forecast.py
- Truth data format: when done, remove from: `load_truth_data()` in models/project.py
- Score download format: when done, remove from: `_write_csv_score_data_for_project()` in api_views.py
- rethink naming of `json_io_dict`
- Project creation configuration (JSON)
- Score download format (CSV)

## Api.md
- update endpoints

