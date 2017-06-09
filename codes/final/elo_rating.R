elo_rating <- function(match_data,sorted = TRUE) {
  if(!require(devtools)){
    install.packages('devtools')
    library(devtools)
  }
  if (!require(rCharts)){
    require(devtools)
    install_github('ramnathv/rCharts')
    library(rCharts)
  }
  cat(nrow(match_data),'data read','\n')
  u_date <- unique(df$game_date)
  cat(length(u_date),'different dates in this data','\n')
  names <- unique(as.vector(rbind(as.character(df$teamname1),as.character(df$teamname2))))
  cat(length(names),'different conpetitors found in this data','\n')
  cat('Key in mark strategy','\n')
  cat('Point can get if win :')
  p_w <- scan(nmax = 1,quiet = T)
  cat('Point can get if draw :')
  p_d <- scan(nmax = 1,quiet = T)
  cat('Point can get if loose :')
  p_l <- scan(nmax = 1,quiet = T)
  df$team_1_mark <- ifelse(as.numeric(df$team_1_win) > as.numeric(df$team_2_win),p_w,ifelse(as.numeric(df$team_1_win) < as.numeric(df$team_2_win),p_l,p_d))
  df$team_2_mark <- ifelse(as.numeric(df$team_1_win) > as.numeric(df$team_2_win),p_l,ifelse(as.numeric(df$team_1_win) < as.numeric(df$team_2_win),p_w,p_d))
  #---check pass
  cat('Key in initial rating value for competitors','\n')
  initial_rating <- scan(nmax = 1,quiet = T)
  el_df <- data.frame(names,initial_rating)
  cat('Confirmed','\n')
  colnames(el_df) <- c('team_name','rating')
  #--- check pass
  cat('Analyzing now...','\n')
  el_df$rating <- initial_rating
  for (date in u_date){
    date_df <- df[which(df$game_date == date),]
    for (index in 1:nrow(date_df)) {
      data <- date_df[index,]
      name_A <- data$teamname1
      name_B <- data$teamname2
      k <- 16
      RA <- as.numeric(el_df[el_df$team_name == as.character(name_A),]['rating'])
      RB <- as.numeric(el_df[el_df$team_name == as.character(name_B),]['rating'])
      EA <- 1/(1 + 10 ^ ((RA - RB)/400))
      EB <- 1/(1 + 10 ^ ((RB - RA)/400))
      SA <- data$team_1_mark
      SB <- data$team_2_mark
      if (EA != SA){
        el_df[el_df$team_name == as.character(name_A),]['rating'] <- RA + k*(SA - EA)
      }
      if (EB != SB){
        el_df[el_df$team_name == as.character(name_B),]['rating'] <- RB + k*(SB - EB)
      }
      
    }
  }
  cat('Done','\n')
  
  cat('Plot the output ? [T/F] :','\n')
  Pl <- scan(nmax = 1, what = 'character', quiet = T)
  if (Pl == 'T'){
    print(rPlot(rating ~ team_name,data = el_df,type = 'point')) 
  }
  
  if (sorted == FALSE){
    return(el_df)
  }else{
    return(el_df[order(el_df$rating),])
  }
  #--- check pass
}
