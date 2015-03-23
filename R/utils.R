#' Helper function to convert character string to html code.
#' @importFrom markdown markdownToHTML
html <- function(mes_vec) {
  html_vec <- sapply(mes_vec, function(m) markdownToHTML(text = m, fragment.only = TRUE))
  return(paste(html_vec, collapse = ""))
}
