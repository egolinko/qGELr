
#' Diagonal aspects
#' @name getD
#' @param i the index
#' @param d_ dataframe reference
#' @param dis_ diagonal reference
#' @export getD

getD <- function(i, d_, dis_){
  fbyEachClass(r_ = d_[dis_[[i]],],
               f_ = d_[dis_[[i]],],
               d_ = d_)
}
