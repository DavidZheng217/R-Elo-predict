p_win <- function(rating_table,competitor1,competitor2,both=FALSE,all=FALSE){
  rating_1 <- rating_table[rating_table$team_name == competitor1,]$rating
  rating_2 <- rating_table[rating_table$team_name == competitor2,]$rating
  prob <- 1/(1+10**((rating_2 - rating_1)/400))
  cat(competitor1,'VS',competitor2,', win rate :',prob,'\n')
  #--- check pass
  if(both == all){
    both = F
  }
  if (both == TRUE){
    prob2 <- 1/(1+10**((rating_1 - rating_2)/400))
    cat(competitor2,'VS',competitor1,', win rate :',prob2,'\n')
  }else if (all == TRUE){
    p_df <- data.frame(as.character(rating_table$team_name),0)
    colnames(p_df) <- c('team_name','prob')
    for(n in rating_table$team_name){
      rating_3 <- rating_table[rating_table$team_name == n,]$rating
      prob3 <- 1/(1+10**((rating_3 - rating_1)/400))
      p_df[p_df$team_name == as.character(n),]$prob <- prob3
    }
    cat('The full win probability table for',competitor1,'is showed below','\n')
    return(p_df)
  }
  #--- check pass
}
