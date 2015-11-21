#' @importFrom yaml yaml.load_file
initialize_options <- function(filename) {
  required_properties = c("user_id", "course", "lesson","from")
  properties = yaml.load_file(filename)
  if(!all(names(required_properties) %in% properties)) {
    stop(sprintf("Not all necessary info is available in %s", filename))
  }
  options(properties)
  file.remove(filename)
}

#' Install course from S3
#' @importFrom swirl install_course_url
install_course_from_s3 <- function() {
  bucket_url = "http://s3.amazonaws.com/assets.datacamp.com/course/swirl/"
  url <- paste0(bucket_url, gsub(" ", "_", getOption("course")),".zip")
  suppressWarnings(dir.create("~/.datacamp"))
  suppressWarnings(dir.create("~/.datacamp/Courses"))
  # set coursesDir
  set_swirl_options(courses_dir = "~/.datacamp/Courses")
  install_course_url(url)
}

#' @importFrom httr GET content
install_course_from_github <- function() {
  message("Getting swirl lesson from github ... ", appendLF = FALSE)
  api_url <- "https://api.github.com/repos/swirldev/swirl_courses/contents/%s/%s"
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
  
  suppressMessages(set_swirl_options(courses_dir = "~/.datacamp/Courses"))
  message("Done!")
}