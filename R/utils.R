#' Helper function to convert character string to html code.
#' @importFrom markdown markdownToHTML
html <- function(mes_vec) {
  html_vec <- sapply(mes_vec, function(m) markdownToHTML(text = m, fragment.only = TRUE))
  return(paste(html_vec, collapse = ""))
}

html_list <- function(mes_list) {
  lapply(mes_list, function(m) markdownToHTML(text = m, fragment.only = TRUE))
}

override_msg <- "You can not use swirl's %s() function in the DataCamp interface."

sc_accessors <- function() {
  sc_data <- list()
  
  get = function(name) {
    if(missing(name)) {
      sc_data
    } else {
      sc_data[[name]]
    }
  }
  
  initialize = function(data) {
    sc_data <<- data
    invisible(NULL)
  }
  
  merge = function(values) merge_list(sc_data, values)
  list(initialize = initialize, get = get)
}

merge_list <- function(x, y) {
  x[names(y)] = y
  x
}

sc <- sc_accessors()



# file.copy("init.yaml", ".init.yaml")