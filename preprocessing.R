# Preprocessing function
preprocess_RestingState <- function(file) {
  if (!require("jsonlite", character.only = TRUE)) install.packages("jsonlite")

  items <- c(    "I had busy thoughts",
                 "I had rapidly switching thoughts",
                 "I had difficulty holding onto my thoughts",
                 "I thought about others",
                 "I thought about people I like",
                 "I placed myself in other people's shoes",
                 "I thought about my feelings",
                 "I thought about my behaviour",
                 "I thought about myself",
                 "I thought about things I need to do",
                 "I thought about solving problems",
                 "I thought about the future",
                 "I felt sleepy",
                 "I felt tired",
                 "I had difficulty staying awake",
                 "I felt comfortable",
                 "I felt happy",
                 "I felt relaxed",
                 "I was conscious of my body",
                 "I thought about my heartbeat",
                 "I thought about my breathing",
                 "I felt ill",
                 "I thought about my health",
                 "I felt pain",
                 "I thought in images",
                 "I pictured events",
                 "I pictured places",
                 "I thought in words",
                 "I had silent conversations",
                 "I imagined talking to myself",
                 "I had my eyes closed",
                 "I was able to rate the statements above")

  names(items) <- c(    "DoM_1", "DoM_2", "DoM_3",
                        "ToM_1", "ToM_2", "ToM_3",
                        "Self_1", "Self_2", "Self_3",
                        "Plan_1", "Plan_2", "Plan_3",
                        "Sleep_1", "Sleep_2", "Sleep_3",
                        "Comfort_1", "Comfort_2", "Comfort_3",
                        "SomA_1", "SomA_2", "SomA_3",
                        "Health_1", "Health_2", "Health_3",
                        "Visual_1", "Visual_2", "Visual_3",
                        "Verbal_1", "Verbal_2", "Verbal_3", "Check_1", "Check_2")

  json <- jsonlite::fromJSON(file, simplifyVector=FALSE)[[1]]
  data <- data.frame(Participant = json$participant_id,
                     Screen_Resolution = paste0(json$screen_width, "x", json$screen_height),
                     Screen_Refresh = json$vsync_rate,
                     Browser = json$browser,
                     Browser_Version = json$browser_version,
                     Device = ifelse(json$mobile == TRUE, "Mobile", "Desktop"),
                     Device_OS = json$os,
                     Duration = json$duration,
                     Version = json$version,
                     Date = json$date,
                     Time = json$time,
                     Item = names(unlist(json$response)),
                     Answer = as.numeric(unlist(json$response)),
                     Order = unlist(json$question_order))
  data$Label <- items[data$Item]

  # Average per dimension
  data$Dimension <- sapply(strsplit(data$Item, "_", fixed=TRUE), function(x) x[[1]])
  ave <- aggregate(data$Answer, list(data$Dimension), FUN=mean)
  ave <- setNames(ave$x, ave$Group.1)
  data <- cbind(data, as.data.frame(as.list(ave)))
  data
}



# Run ---------------------------------------------------------------------

# Uncomment the lines below to run it.

# # The function can be loaded from the internet
# devtools::source_url("https://raw.githubusercontent.com/RealityBending/RestingState/main/preprocessing.R")
#
# files <- list.files(path="data/", pattern = "\\.json$", full.names = TRUE)
#
# # Loop over each file and compute function
# df <- data.frame()
# for(file in files) df <- rbind(df, preprocess_RestingState(file))
#
# # Clean dataframe
# df
