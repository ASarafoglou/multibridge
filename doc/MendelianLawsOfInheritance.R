## -----------------------------------------------------------------------------
library(multibridge)
data(peas)
peas

## -----------------------------------------------------------------------------
categories <- peas$peas
x          <- peas$counts

# Prior specification 
# We assign a uniform Dirichlet distribution, that is, we set all concentration parameters to 1
a <- c(1, 1, 1, 1)

# Test the following restricted Hypothesis:
# Hr: roundYellow > wrinkledYellow = roundGreen > wrinkledGreen
Hr   <- c('roundYellow > wrinkledYellow = roundGreen > wrinkledGreen')

## -----------------------------------------------------------------------------
sum_table <- summary(results)

## -----------------------------------------------------------------------------
bayes_list <- bayes_factor(results)
bayes_list$error_measures
bayes_list$bf_table
# Bayes factors in favor for informed hypothesis
bfre <- bayes_list$bf_table[bayes_list$bf_table$bf_type=='BFre', ]

