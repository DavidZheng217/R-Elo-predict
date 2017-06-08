file_helper <- function(){
  cat('Where is your data file ? :','\n')
  loc <- scan(nmax = 1,what = 'character',quiet = T)
  setwd(loc)
  cat('What is your file\'s name ? :','\n')
  nm <- scan(nmax = 1,what = 'character',quiet = T)
  if (grepl('.csv',nm)){
    df <- read.csv(nm) 
  }else{
    cat('Dose the data file has headers ? [T/F] :')
    H <- scan(nmax = 1,what = 'character',quiet = T)
    cat('Use what to separate the data ? :')
    S <- scan(nmax = 1,what = 'character',quiet = T)
    cat('Use what to represent the decimal point ? :')
    D <- scan(nmax = 1,what = 'character',quiet = T)
    if (H == 'T'){
      df <- read.table(nm,header = T, sep = S, dec = D) 
    }else{
      df <- read.table(nm,header = F, sep = S, dec = D)
    }
  }
  return(df)
}
