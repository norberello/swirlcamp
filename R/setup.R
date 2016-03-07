#' @export
args_specification.datacamp <- function(e, ...) {
  if(is.null(sc$get("course")) || is.null(sc$get("lesson"))) {
    stop("Must specify 'course' and 'lesson' in the options!")
  }
  e$course <- sc$get("course")
  e$lesson <- sc$get("lesson")
  if(is.null(sc$get("from"))) {
    e$test_from <- 1
  } else {
    e$test_from <- sc$get("from")
  }
  e$test_to <- 999
}

#' @export
welcome.datacamp <- function(e, ...){
  "datacamp"
}

#' @export
housekeeping.datacamp <- function(e){}

#' @export
inProgressMenu.datacamp <- function(e, choices) {
  ""
}

#' @export
courseMenu.datacamp <- function(e, choices) {
  e$course
}

#' @export
lessonMenu.datacamp <- function(e, choices) {
  e$lesson
}

#' @export
courseDir.datacamp <- function(e) {
  file.path("~",".datacamp", "Courses")
}

#' @export
progressDir.datacamp <- function(e) {
  file.path("~",".datacamp", "user_data")
}

