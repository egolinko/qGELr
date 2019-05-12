#' Context for rows and columns

#' @name fbyEachClass
#' @param r_ the row
#' @param f_ the feature
#' @param d_ reference to the dataframe
#' @return a normed datarfame`
#' @export fbyEachClass

fbyEachClass <- function(r_, f_, d_){

  r_1 = rowMeans(r_)
  f_1 = colMeans(f_)

  r_0 = 1 - r_1
  f_0 = 1 - f_1

  f = data.frame(f_0, f_1)
  r = data.frame(r_0, r_1)

  Q <- as.matrix(f) %*% as.matrix(t(r))

  return(Q/max(Q))
}
