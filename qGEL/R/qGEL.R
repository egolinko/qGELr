#' qgel
#' @name qgel
#' @param source.data_ the data to embed
#' @param k number of embedded features, default k = 10
#' @param class_var string, the name of class variable
#' @param learning_method string, 'supervised' otherwise will be unsupervised

#' @import dplyr
#' @import Matrix
#' @import caret
#' @export qgel

if(getRversion() >= "2.15.1")  utils::globalVariables(c("Class"))
if(getRversion() >= "3.1.0") utils::suppressForeignCheck("Class")

qgel <- function(source.data_, k = 10, class_var = NULL, learning_method = 'unsupervised'){

  if (learning_method == "supervised"){
    source.data_ <- dplyr::rename_(source.data_, Class = class_var)
    source.data_$Class <- factor(x = source.data_$Class,
                                 names(sort(table(source.data_$Class),
                                            decreasing = T)))

    source.data <- source.data_ %>% arrange(Class)

    W_ <- source.data

  }
  else{
    W_ <- source.data_
  }


  if (learning_method == "supervised"){

    class_combs <- as.data.frame.matrix(
      t(
        combn(x = unique(W_$Class), m = 2)))
    names(class_combs) <- c('c_i', 'c_j')


    if(n_distinct(W_$Class) == 2){
      diag_index_sets <- lapply(1:2, function(i)
        rownames(W_[which(W_$Class == unique(W_$Class)[i]),]))
    }
    else{
      diag_index_sets <- lapply(1:n_distinct(W_$Class), function(i)
        rownames(W_[which(W_$Class == unique(W_$Class)[i]),]))
    }

    D <- lapply(1:length(diag_index_sets), function(i)
      getD(i, d_ = W_ %>% select(-Class), dis_ = diag_index_sets))
    names(D) <- unique(W_$Class)

    b <- bdiag(D) %>% as.matrix()

    Sx <- b %*% as.matrix(W_ %>% select(-Class))

    S <- t(Sx) %*% Sx
  }

  else {
    u <- fbyEachClass(r_ = W_,
                      f_ = W_,
                      d_ = W_)

    Sx <- u %>% as.matrix() %*% as.matrix(W_)

    S <- t(Sx) %*% Sx

  }

  if(k == 'max' | k >= nrow(W_)){
    k <- nrow(W_)
  }
  else{
    k <- k
  }

  V <- svd(S/max(S), nv = k)$v

  ret <- list()
  ret$V <- V
  ret$W_ <- W_

  if (learning_method == "supervised"){
    ret$embed <- as.data.frame(W_ %>% select(-Class) %>% as.matrix() %*% V)
    ret$embed[class_var] <- source.data$Class
  }
  else{
    ret$embed <- as.data.frame(W_ %>% as.matrix() %*% V)
  }

  return(ret)

}
