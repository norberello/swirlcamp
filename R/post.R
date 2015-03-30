#' Post information after initialization
#' @param e swirl environment
#' @export
post_init.datacamp <- function(e) {
  packet <- list(type = "init",
                 content = list(current_row = e$row,
                                total_rows = nrow(e$les)))
  post(packet)
}

#' Post exercise information to DataCamp
#' @param e swirl environment
#' @param current.row The current.row in the swirl lesson
#' @export
#' @importFrom stringr str_trim
post_exercise.datacamp <- function(e, current.row) {
  if(is(e$current.row, "mult_question")) {
    choices <- strsplit(current.row[,"AnswerChoices"],";")
    choices <- str_trim(choices[[1]])
    content <- list(assignment = html(e$current.row[, "Output"]),
                    choices = html(paste0(seq_along(choices), ". ", choices, collapse = "\n")), 
                    ex_type = "mult_question")
  } else {
    content <- list(assignment = html(current.row[, "Output"]), 
                    ex_type = class(current.row)[1])
  }
  packet <- list(type = "exercise", content = content)
  post(packet)
}

#' Post MCQ to DataCamp - choices were already given in post_exercise
#' @param e swirl environment
#' @param choices the options in the Multiple Choice Question
#' @export
post_mult_question.datacamp <- function(e, choices) {
  suppressWarnings(res <- as.numeric(base::readline("Selection: ")))
  if(is.na(res)) res <- 0
  while (res < 1L || res > length(choices)) {
    res <- as.numeric(base::readline("Selection: "))
  }
  return(choices[as.numeric(res)])
}

#' Post progress information to DataCamp
#' @param e swirl environment
#' @export
post_progress.datacamp <- function(e) {
  # NOT NEEDED ANYMORE
  #packet <- list(type = "progress", 
  #               content = list(progress = e$pbar_seq[e$row]))
  #post(packet)
}

#' Post the result of a testable exercise to DataCamp
#' @param e swirl environment
#' @param passed logical value indicating whether or not the corresponding exercise passed
#' @param feedback feedback message for student's answer on corresponding exercise
#' @param hint the hint swirl provides, can be NULL
#' @export
post_result.datacamp <- function(e, passed, feedback, hint) {
  if(!passed && !is.null(hint)) {
    feedback <- paste(feedback, hint)
  }
  if(is(e$current.row, "mult_question") || 
       is(e$current.row, "text_many_question") || 
       is(e$current.row, "text_order_question") ||
       is(e$current.row, "text_question")) {
    submission <- e$val
  } else {
    submission <- as.character(as.expression(e$expr))
  }
  packet <- list(type = "result", content = list(result = passed, 
                                                 submission = submission, 
                                                 row = e$row,
                                                 next_row = if(passed) e$row + 1 else e$row,
                                                 feedback = html(feedback),
                                                 skipped = if(exists("skipped", e)) e$skipped else FALSE))
  post(packet)
  if(passed) {
    # wait for user to read the feedback
    readline("...")
  }
}

#' Indicate to DataCamp that a lesson is finished
#' @param e swirl environment (only used for determining the implementation)
#' @export
post_finished.datacamp <- function(e) {
  packet <- list(type = "finished", content = list())
  post(packet)
}

#' Generic function that posts a packet of information to the DataCamp pusher.
#' @importFrom httr POST add_headers
#' @importFrom RJSONIO toJSON
post <- function(packet) {
  # print(packet)
  url <- "http://pusher.datacamp.com/exercises"
  json <- RJSONIO::toJSON(c(packet, user_id = getOption("user_id")))
  result <- try(POST(url = url, 
                     body = json, 
                     add_headers(c(`Content-Type` = "application/json", 
                                   `Expect` = "")))) 
  if(inherits(result, "try-error")) {
    stop("Something went wrong when posting to DataCamp.")
  }
  invisible()
}