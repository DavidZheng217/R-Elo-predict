
df <- read.csv("L_Match_joined.csv", header = TRUE, sep = ",", dec=".")
head(df)

df$winner <- ifelse(df$team_1_win > df$team_2_win,as.character(df$teamname1),ifelse(df$team_1_win == df$team_2_win,'draw',as.character(df$teamname2)))

head(df)

df[which(df$game_date == '2015-02-27'),]

unique(df$game_date)

names <- as.vector(rbind(as.character(df$teamname1),as.character(df$teamname2)))

u_name <- unique(names)

u_name

length(u_name)

df$team_1_mark <- ifelse(df$team_1_win > df$team_2_win,1,ifelse(df$team_1_win < df$team_2_win,0,0.5))
df$team_2_mark <- ifelse(df$team_1_win > df$team_2_win,0,ifelse(df$team_1_win < df$team_2_win,1,0.5))

head(df)

el_df <- data.frame(u_name,1000)

head(el_df)

colnames(el_df) <- c('team_name','rating')

#rownames(el_df) <- c(u_name)

#el_df$team_name <- NULL

head(el_df)

el_df$rating <- 1000

test_df <- df[which(df$game_date == '2013-02-16'),]
test_df <- test_df[order(test_df$winner),]
test_df

for (index in 1:nrow(test_df)) {
    name_A <- test_df[index,]$teamname1
    name_B <- test_df[index,]$teamname2
    k <- 16
    RA <- as.numeric(el_df[el_df$team_name == as.character(name_A),]['rating'])
    RB <- as.numeric(el_df[el_df$team_name == as.character(name_B),]['rating'])
    EA <- 1/(1 + 10 ** ((RA - RB)/400))
    EB <- 1/(1 + 10 ** ((RB - RA)/400))
    SA <- test_df[index,]$team_1_mark
    SB <- test_df[index,]$team_2_mark
    if (EA != SA){
        RA1 <- RA + k*(SA - EA)
        el_df[el_df$team_name == as.character(name_A),]['rating'] <- RA1
    }
    if (EB != SB){
        RB1 <- RB + k*(SB - EB)
        el_df[el_df$team_name == as.character(name_B),]['rating'] <- RB1
    }
}


el_df[el_df$rating != 1000,]

u_date <- unique(df$game_date)  # get the unique date

el_df$rating <- 1000  # reset the ranking

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
            #el_df[as.character(name_A),] <- RA + k*(SA - EA)
            el_df[el_df$team_name == as.character(name_A),]['rating'] <- RA + k*(SA - EA)
        }
        if (EB != SB){
            #el_df[as.character(name_B),] <- RB + k*(SB - EB)
            el_df[el_df$team_name == as.character(name_B),]['rating'] <- RB + k*(SB - EB)
        }
    
    }
}

el_df[order(el_df$rating),]

el_df[el_df$team_name == as.character('EDG'),]['rating'] <- 100

el_df[el_df$rating == 100,]

el_df[sample(10),]
