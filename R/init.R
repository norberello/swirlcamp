#' @importFrom yaml yaml.load_file
initialize_options <- function(filename) {
  required_properties = c("user_id", "course", "lesson","from")
  properties = yaml.load_file(filename)
  if(!all(names(required_properties) %in% properties)) {
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