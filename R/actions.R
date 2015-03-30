
#' @export
do_nxt.datacamp <- function(e){
  message(sprintf(override_msg, "nxt"))
  return(TRUE)
}

#' @export
do_play.datacamp <- function(e){ 
  message(sprintf(override_msg, "play"))
  return(TRUE)
}

#' @export
do_main.datacamp <- function(e){
  message(sprintf(override_msg, "main"))
  return(TRUE)
}

#' @export
do_restart.datacamp <- function(e) { 
  message("Restarting the lesson for you...")
  # Remove the current lesson. Progress has been saved already.
  if(exists("les", e, inherits=FALSE)){
    rm("les", envir=e, inherits=FALSE)
  }
  e$test_from <- 1
}