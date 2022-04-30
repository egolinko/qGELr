# qGELr

Install via ```devtools```

```{r}

install.packages('devtools')

devtools::install_github('egolinko/qGELr', subdir = 'qGEL')

```

# Minimal Example

```{r}

library(qgel)
library(dplyr)

data("iris")

supvsd <- qgel(source.data_ = iris, k = 2, class_var = 'Species', learning_method = 'supervised')
unnsupvsd <- qgel(source.data_ = iris %>% select(-Species), k = 2)

```

# By Hand example

```{r}
W <- rbind(c(0,0,1,0), 
           c(1,0,0,1), 
           c(0,1,1,0), 
           c(1,0,0,1), 
           c(0,1,0,0)
)

A <- rbind(c(.6,.6,.6, 0, 0),
           c(.6,.6,.6, 0, 0),
           c(.6,.6,.6, 0, 0),
           c(0, 0, 0, .4, .4),
           c(0, 0, 0, .4, .4)
)

r1 <- rbind(c(.75,.25), 
            c(.5,.5), 
            c(.5,.5)
)

r2 <- rbind(c(.5,.5), 
            c(0.75, .25)
)

f1 <- rbind(c(.67, .33), 
            c(.67,.33), 
            c(.33,.67), 
            c(.67,.33)
)

f2 <- rbind(c(.5,.5), 
            c(.5,.5), 
            c(1,0), 
            c(.5,.5)
)

f12 <- rbind(c(.6,.4), 
             c(.6,.4), 
             c(.6,.4), 
             c(.6,.4)
)   

q1 <- f1 %*% t(r1)
q2 <- f2 %*% t(r2)
q12 <- f12 %*% t(r2)
q21 <- f12 %*% t(r1)

Q <- rbind(cbind(q1, q12), 
           cbind(q21, q2))

S <- ((t(Q) %*% Q) * A) %*% W

s_hat <- svd(S)

f_hat <- W %*% s_hat$v[,1:2]
```
