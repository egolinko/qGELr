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
