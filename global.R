library(bitops)
library(httr)
library(plyr)
library(reshape)
library(RCurl)

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

#' Return a list of lists describing files matching "requirements".
#'
#' Because of rate limiting to github api calls, a normal user can only send
#' 60 requests per hour. https://developer.github.com/v3/#rate-limiting
#' At 271 extensions, this might take a while.
#'
#' Also, this returns only the first match and ignores the rest.
#'
#' Currently returns a list of lists, needs to access the content of all found
#' files and return each line (plus extension name) in a data.frame
get_requirements <- function(url){
  reponame <- strsplit(url, "github.com/")[[1]][2]
  get_url <- paste0("https://api.github.com/search/code?",
                    "q=requirements+in:filename+extension:txt+repo:", reponame)
  hdr =  add_headers(Accept = "application/vnd.github.v3.text-match+json")
  res <- httr::GET(get_url, hdr)
  stop_for_status(res)
  cont <- content(res)
  cont
}


#' Git clone a given url
#'
#' Clones a Git repository to a local subfolder, fails if folder exists.
#'
#' @param url The url to clone
#' @return None
git_clone <- function(url){
  system(paste("git clone", url))
}

#' Remove local copies of extensions
wipe_em_all <- function(){
  lapply(dir(pattern="^ckanext*"), unlink, recursive=T, force=T)
}

#' Refresh local extension repositories
#'
#' Removes all subdirectories beginning with "ckanext",
#' then git clones a list of repo urls.
#'
#' @param urls A vector of urls
#'
#' git clone or pull a list of urls
git_em_all <- function(urls){
  wipe_em_all()
  lapply(urls, git_clone)
}


#' Updates local extensions to their current latest status
#'
#' Uses get_extensions() to fetch the latest list of registered CKAN extensions,
#' removes all local copies of extensions, downloads all registered extensions.
#' This function runs for a while (>60 sec), mind browser timeouts.
refresh_local_extensions <- function(){
  update_all_extensions(get_extensions()$url)
}

#' Return a list of pip requirements file names (local copies)
#'
#' Requires refresh_local_extensions() to have run.
#'
#' @return a list of file names
get_requirement_file_names <- function(){
  list.files(pattern='*requirements*\\.txt', recursive=TRUE)
}

#' Returns a data.frame (library, extension name) from a requirements file
#'
#' @param
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
  d <- ldply(get_requirement_file_names(),
             parse_one_requirements_file)
  d
}

cache_dependencies <- function(){
  write.csv(collate_dependencies(), file="dependencies.txt", row.names = F)
}

dependencies <- function(){read.csv("dependencies.txt")}
