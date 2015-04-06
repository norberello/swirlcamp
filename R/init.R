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