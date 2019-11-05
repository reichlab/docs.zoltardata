# Zoltar documentation site source

This repository holds documentation content for all aspects of [Zoltar](https://www.zoltardata.com/) such as the web
site user guide, help for researchers, API and client libraries, etc. The documentation source format is 
[Markdown](https://python-markdown.github.io/). We use [Mkdocs](https://www.mkdocs.org/) uses to generate the static
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
- Deploy to the [GitHub Pages](https://pages.github.com/) [docs.zoltardata site](http://reichlab.io/docs.zoltardata/)
```bash
$ cd <readme.md's dir>
$ pipenv shell
$ mkdocs gh-deploy
```
- This should also update the custom domain site [docs.zoltardata.com](https://docs.zoltardata.com/), which is currently
  hosted at [Netlify](https://app.netlify.com/sites/docs-zoltardata-staging/overview).
  

## Hosts and servers
Here are the moving parts that implement the documentation site:
- a GitHub repo [docs.zoltardata](https://github.com/reichlab/docs.zoltardata/) to store doc source in 
  [Mkdocs flavored Markdown](https://python-markdown.github.io/) format
- the [Mkdocs](https://www.mkdocs.org/) static site generator to build the site HTML from doc source
- a [Netlify](https://www.netlify.com/) host to serve the built docs:
  [docs-zoltardata-staging.netlify.com](https://docs-zoltardata-staging.netlify.com/)
- a [docs.zoltardata.com](https://docs.zoltardata.com/) subdomain configured on our [DNSimple](https://dnsimple.com/)
  namespace server that points to the Netlify location. The dnsimple records are 
  [here](https://dnsimple.com/a/91354/domains/zoltardata.com/records) and the Netlify domain configuration is
  [here](https://app.netlify.com/sites/docs-zoltardata-staging/settings/domain).

