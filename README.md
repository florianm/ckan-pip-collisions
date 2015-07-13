# ckan-pip-collisions
An R Shiny application to identify dependency collisions between CKAN and CKAN extensions

CKAN and its over 100 extensions depend on third-party python packages. 
Commonly, these dependencies are a `pip freeze` snapshot of whichever versions work at development time.
Sometimes, these hard-coded versions collide. 

As it is tedious to manually compare all third party libraries from all extensions, 
this exercise aims to automate that process:
```
# Download the official list of CKAN extensions
wget https://raw.githubusercontent.com/ckan/extensions.ckan.org/gh-pages/data/extensions-gh.csv

# Extract github urls of all extensions
cat extensions-gh.csv | cut -d',' -f3 | grep github.com > github_urls.txt

# clone each github url
## curl https://api.github.com/repos/fprieur/ckanext-vdmauth
## clone ['clone_url']


# List and sort all third party dependencies
cat `find . -name '*requirements*'` | sort | uniq > sorted_deps.txt

# Identify colliding version numbers
# TODO regex magic

# For each dependency found with different version numbers, find all extensions using it
grep -rn "requests.=.\." .
```
