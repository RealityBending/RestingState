# install.packages("jsonlite")

files <- list.files(path="data/", pattern = "\\.json$", full.names = TRUE)

df <- data.frame()
for(file in files) {
  json <- jsonlite::fromJSON(file, simplifyVector=FALSE)[[1]]
  data <- data.frame(Participant = json$participant_id,
                     Duration = json$duration,
                     Version = json$version,
                     Date = json$date,
                     Time = json$time,
                     Item = names(unlist(json$response)),
                     Answer = as.numeric(unlist(json$response)),
                     Order = unlist(json$question_order))
  df <- rbind(df, data)
}

data
