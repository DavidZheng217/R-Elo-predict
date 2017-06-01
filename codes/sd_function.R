Neil_SD <- function(number) {
  mean <- mean(number)
  total_sum <- sum((number - mean)^2)
  variance <- total_sum/(length(number) - 1)
  standard_deviation <- sqrt(variance)
  return(standard_deviation)
}