#' Start the DataCamp version of Swirl
#' 
#' @param init_filename yaml file containing initialization information. If not specified, defulats to .init.yaml
#' @param install logical value, whether or not to install course before starting swirl. Defaults to TRUE
#' 
#' @export
swirl <- function(init_filename = ".init.yaml", install = TRUE) {
  if (!file.exists(init_filename)) {
    message("You can only use the swirl() command at the start of this exercise.")
  } else {
    initialize_options(init_filename)
    if (install) install_course_from_s3()
    swirl::swirl("datacamp")  
  }
}

#' @export
bye <- function() { message(sprintf(override_msg, "bye")) }


#' @export
info <- function() { message(sprintf(override_msg, "info")) }
