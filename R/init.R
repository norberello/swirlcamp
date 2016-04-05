#' @importFrom yaml yaml.load_file
initialize_options <- function(filename) {
  required_properties = c("user_id", "course", "lesson","from")
  properties = yaml.load_file(filename)
  if (!all(names(required_properties) %in% properties)) {
    stop(sprintf("Not all necessary info is available in %s", filename))
  }
  sc$initialize(properties)
  file.remove(filename)
}

#' @importFrom swirl install_course
install_course_from_swc <- function() {
  suppressMessages(options(swirl_courses_dir = "~/.datacamp/Courses"))
  message("Getting swirl course ... ", appendLF = FALSE)
  suppressMessages(install_course(sc$get("course")))
  message("Done!")
}

#' @importFrom httr GET content
install_course_from_github <- function() {
  message("Getting swirl lesson from github ... ", appendLF = FALSE)
  api_url <- "https://api.github.com/repos/datacamp/swirl_courses/contents/%s/%s"
  underscored_course <- gsub(" ", "_", getOption("course"))
  underscored_lesson <- gsub(" ", "_", getOption("lesson"))
  
  # Build the course folder structure
  suppressWarnings(dir.create("~/.datacamp"))
  suppressWarnings(dir.create("~/.datacamp/Courses"))
  suppressWarnings(dir.create(sprintf("~/.datacamp/Courses/%s", underscored_course)))
  suppressWarnings(dir.create(sprintf("~/.datacamp/Courses/%s/%s", underscored_course, underscored_lesson)))                 
  
  lesson_contents <- content(GET(sprintf(api_url, underscored_course, underscored_lesson)))
  lapply(lesson_contents, function(x) download.file(x$download_url, 
                                                    destfile = sprintf("~/.datacamp/Courses/%s/%s/%s", 
                                                                       underscored_course, underscored_lesson, basename(x$download_url)), 
                                                    quiet = TRUE))
  
  suppressMessages(options(swirl_courses_dir = "~/.datacamp/Courses"))
  message("Done!")
}