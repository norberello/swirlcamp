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

install_course_from_s3 <- function() {
  bucket_url = "http://s3.amazonaws.com/assets.datacamp.com/course/swirl_zip/"
  url <- paste0(bucket_url, gsub(" ", "_", sc$get("course")), ".zip")
  suppressWarnings(dir.create("~/.datacamp"))
  suppressWarnings(dir.create("~/.datacamp/Courses"))
  suppressMessages(options(swirl_courses_dir = "~/.datacamp/Courses"))
  install_course_url(url)
}

#' @importFrom httr GET content
install_course_from_github <- function() {
  message("Just a moment... ", appendLF = FALSE)
  api_url <- "https://api.github.com/repos/datacamp/swirl_courses/contents/%s/%s"
  underscored_course <- gsub(" ", "_", sc$get("course"))
  underscored_lesson <- gsub(" ", "_", sc$get("lesson"))
  
  # Build the course folder structure
  suppressWarnings(dir.create("~/.datacamp"))
  suppressWarnings(dir.create("~/.datacamp/Courses"))
  suppressWarnings(dir.create(sprintf("~/.datacamp/Courses/%s", underscored_course)))
  suppressWarnings(dir.create(sprintf("~/.datacamp/Courses/%s/%s", underscored_course, underscored_lesson)))                 
  
  lesson_contents <- content(GET(sprintf(api_url, underscored_course, underscored_lesson)))
  lapply(lesson_contents, function(x) {
    library(httr)
    GET(x$download_url, write_disk(sprintf("~/.datacamp/Courses/%s/%s/%s", 
                                underscored_course, underscored_lesson, basename(x$download_url)), overwrite = TRUE))
  })
  
  suppressMessages(options(swirl_courses_dir = "~/.datacamp/Courses"))
  message("All set!")
}