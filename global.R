library(RCurl)
library(bitops)
library(plyr)
library(reshape)

#' Returns a data.frame of CKAN extensions
#'
#' The data.frame has variables:
#' name, title, url, and more.
get_extensions <- function(){
  require(RCurl)
  url <- paste0("https://raw.githubusercontent.com/ckan/extensions.ckan.org/",
                "gh-pages/data/extensions-gh.csv")
  ext <- read.csv(text = RCurl::getURL(url), stringsAsFactors=F)
  ext
}


#' git pulls in a given folder
#'
#' @param path A relative or absolute folder path
git_pull <- function(path){
  wd <- getwd()
  setwd(path)
  system(paste("git pull"))
  setwd(wd)
}


#' git clone or pull a given url
git_clone_or_pull <- function(url){
  folder <- strsplit(u,"/")[[1]][5]
  if(file.exists(folder)) {
    git_pull(folder)
  } else {
    system(paste("git clone", url))
  }
}

#' git pull all extensions
pull_all_extensions <- function(){
  lapply(dir(pattern="^ckanext*"), git_pull)
}

#' git clone or pull a list of urls
git_clone_or_pull_all_extensions <- function(urls){
  lapply(urls, git_clone_or_pull)
}

#' Clone all registered extensions to local folders
refresh_local_extensions <- function(){
  git_clone_or_pull_all_extensions(get_extensions()$url)
}

#' Return a list of pip requirements file names
get_requirement_file_names <- function(){
  list.files(pattern='*requirements*\\.txt', recursive=TRUE)
}

parse_one_requirements_file <- function(fname){
  try(lines <- readLines(fname))
  if(!exists("lines")) lines <- "extensions not readable"
  ename <- strsplit(fname,"/")[[1]][1]
  x <- data.frame(cbind(library = lines, extension = ename),
                  stringsAsFactors = F)
  x
}



#' List all requirements sorted alphabetically
collate_dependencies <- function(){
  fn <- get_requirement_file_names()
  d <- ldply(fn, parse_one_requirements_file)
  d
}

cache_dependencies <- function(){
  write.csv(collate_dependencies(), file="dependencies.txt", row.names = F)
}

dependencies <- function(){read.csv("dependencies.txt")}
