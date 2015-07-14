# CKAN dependency explorer
An R Shiny application to identify dependency collisions between CKAN and CKAN extensions.

CKAN and its over 100 extensions depend on third-party python packages.
Commonly, these dependencies are a `pip freeze` snapshot of whichever versions 
worked at development time. This is a sane thing to do, as it locks in a version
which provides the required functionality (contrary to earlier versions), but 
does not break it (contrary to possibly breaking future changes).
Sometimes, these hard-coded versions collide between packages. 

As it is tedious to manually compare all third party libraries from CKAN and all 
of its extensions, this application aims to automate that process.

Over at tab "Deps" lives a sortable, filterable list of extensions and their dependencies.

## Process
The list of dependencies was collected as follows:

* The official [list](https://raw.githubusercontent.com/ckan/extensions.ckan.org/gh-pages/data/extensions-gh.csv) of CKAN extensions is downloaded from the official extensions repo.
* Each extension's url is parsed from the list and cloned locally. This process takes
a few minutes to complete.
* The content of all files partially matching "requirements" is concatenated together
with the extension names and stored locally.
* The R Shiny app renders this locally cached spreadsheet using DatatablesJS.

## Refreshing the dependency list
The value of this app is less to render a spreadsheet, but the automation of 
the updating process.

Currently, this is done by the application maintainer. In the future, a front-end
button could be added, but we all know what [happened](https://www.reddit.com/r/thebutton) 
the last time a button was put online for everyone to press. A cron job might be 
more appropriate.

To update the list, `git clone https://github.com/florianm/ckan-pip-collisions.git` 
and run in R:
```
source("global.R")
refresh_local_extensions()
```

The list is under version control, the extensions are not.

## Hosting the app on shinyapps.io
Before uploading the app to shinyapp.io, it is recommended to remove the local
repositories with `wipe_local_extensions()`. Otherwise, shinyapps will try to 
upload them all and crash with a timeout.
