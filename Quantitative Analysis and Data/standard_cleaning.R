# Libraries you may find useful.
library(ggplot2)
library(countrycode)
library(MASS)
library(lmtest)
library(brant)
# This one writes data frames to LaTeX tables. 
library(xtable)

# This sets the working directory to the source directory of this file, so none of us have issues reading the CSV. You may have to install the rstudioapi package.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data = read.csv("final_cleaned.csv")

# Remove first row, which contains the questions (not data)
data = data[-1,]

# Delete person who said they had autism and were NT
data = subset(data, ResponseId != "R_2n7MjgcYuUKFf9g")

# Set up our primary indicators of whether someone has ADHD, is non-ADHD ND, or is NT
data$HasADHD = data$Q3_1 != "" | data$Q3_2 != "" | data$Q3_3 != ""
data$OtherND = data$Q3_1 == "" & data$Q3_2 == "" & data$Q3_3 == "" & (data$Q3_4 != "" | data$Q3_5 != "" | data$Q3_6 != "" | data$Q3_7 != "" | data$Q3_8 != "" | data$Q3_11 != "")

# Rename relevant columns so they are more interpretable going forward.
colnames(data)[colnames(data) == "Q14"] = "gender"
colnames(data)[colnames(data) == "Q9"] = "yoe"
colnames(data)[colnames(data) == "Q71"] = "age"
colnames(data)[colnames(data) == "Q20"] = "job_satisfaction"
colnames(data)[colnames(data) == "Q10"] = "job_title"
colnames(data)[colnames(data) == "Q12"] = "company_size"
colnames(data)[colnames(data) == "Q16"] = "wfh_status"
colnames(data)[colnames(data) == "Q4"] = "diagnosis_status"
colnames(data)[colnames(data) == "Q7"] = "ageofadhd_realization"
colnames(data)[colnames(data) == "Q56"] = "context_switching"
colnames(data)[colnames(data) == "Q90"] = "standup"
colnames(data)[colnames(data) == "Q94"] = "wait_compile"
colnames(data)[colnames(data) == "Q95"] = "git_ease"

# Remove responses completed 1.5 stdev below the median time.
duration = as.numeric(data$Duration..in.seconds., na.rm = T)
mean_duration = mean(duration, na.rm = T)
print(mean_duration)
stdev = sd(duration, na.rm = T)
threshold = mean_duration - 1.5 * stdev
data = data[data$Duration..in.seconds. >= threshold, ]

# Participant R_2K3VFfSApPaNAX2 is autistic and has adhd/it isn't diagnosed. So change hasadhd column for this row. Reason: see qual analysis.
data$HasADHD[data$ResponseId == "R_2K3VFfSApPaNAX2"] = TRUE

# Remove data points where someone did not say what neurotype they are
data = subset(data, GUID != "15cfbd5200919006854c01")
data = subset(data, GUID != "fc86f6a2f118fe22b6161")
data = subset(data, GUID != "c355e3ef8818fe0da1957")
data = subset(data, GUID != "1301b4f4d6218fc58ce0bd")
data = subset(data, GUID != "12c58ca151018fa153d008")
data = subset(data, GUID != "ccd463c0ca18fa1588d5d")
nrow(data)

# Making this respondent's YOE equal to NA, since they put 99 for YOE when they're younger than 99. We assume they misclicked since their free response answers are cogent. See: data.
data$yoe[data$ResponseId == "R_5lFbs73hpKJv0Aj"] = NA
nrow(data)

# Make a column for region
data$region <- countrycode(sourcevar = data[, "country"],
                           origin = "country.name",
                           destination = "region")
data$region = factor(data$region)

# Make a column for group of interest in statistical tests.
data$HasADHD
data$group = ifelse(data$HasADHD, "ADHD", ifelse(data$OtherND, "ND non-ADHD", "NT"))
data$group = factor(data$group)

# Make additional row which has the average of positive mental health (PMH). 
# There are 9 questions in the PMH scale. We can average them to find a semi-objective score.
# This causes some NA values (see the warning message). That's okay. I don't think we should impute them.
data[, c("Q24_1", "Q24_2", "Q24_3", "Q24_4", "Q24_5", "Q24_6", "Q24_7", "Q24_8", "Q24_9")] = lapply(data[, c("Q24_1", "Q24_2", "Q24_3", "Q24_4", "Q24_5", "Q24_6", "Q24_7", "Q24_8", "Q24_9")], as.numeric)
data$pmh_avg = rowMeans(data[, c("Q24_1", "Q24_2", "Q24_3", "Q24_4", "Q24_5", "Q24_6", "Q24_7", "Q24_8", "Q24_9")])

# Note: did not ask about proficiency at prototyping. Rats. 

# Make diagnosis status for ADHD'ers binary.
data$diagnosis_status = data$diagnosis_status == "I am professionally diagnosed with ADHD"
data$diagnosis_status = factor(data$diagnosis_status)

# Turn blanks into NA values.
data[data == ""] = NA

# Turn N/A don't do this task into real NA cells
data[data == "N/A: I don't do this task"] = NA

# Turn data into appropriate types.
data$age = as.numeric(data$age)
data$yoe = as.numeric(data$yoe)
# Convert specified columns to ordered factors
data[53:59] <- lapply(data[53:59], function(x) factor(x, ordered = TRUE))
data[64:94] <- lapply(data[64:94], function(x) factor(x, ordered = TRUE))
data$Q58 = factor(data$Q58, ordered = TRUE)
data$Q91_1 = factor(data$Q91_1, ordered = TRUE)
data$Q91_2 = factor(data$Q91_2, ordered = TRUE)
data$Q91_3 = factor(data$Q91_3, ordered = TRUE)
data$Q92_1 = factor(data$Q92_1, ordered = TRUE)
data$Q92_2 = factor(data$Q92_2, ordered = TRUE)
data$Q92_3 = factor(data$Q92_3, ordered = TRUE)
data$wait_compile = factor(data$wait_compile, ordered = TRUE)
data$git_ease = factor(data$git_ease, ordered = TRUE)
data[117:127] <- lapply(data[117:127], function(x) factor(x, ordered = TRUE))
data[154:171] <- lapply(data[154:171], function(x) factor(x, ordered = TRUE))
data$Q43 = as.numeric(data$Q43)
data$stigma = factor(data$stigma, ordered = TRUE)
data$job_satisfaction = as.numeric(data$job_satisfaction)
data$gender = factor(data$gender)
data$wfh_status = factor(data$wfh_status, levels = c("In person: I work in person the majority of the time", "Hybrid: I work from home some days out of the week, and in person others", "Work from home: I work from home the majority of the time"))
data$ageofadhd_realization = factor(data$ageofadhd_realization)

# Utility function for making freq. tables. We love non-duplicative code.
add_freq_row = function(df, i, num_adhd, num_nd_nonadhd, num_nt, total_people) {
  # Make row for this strategy and cat to strategy_table
  column_name = colnames(data)[i]
  total_chose = sum(!is.na(data[i]))
  adhd_chose = sum(!is.na(data[i]) & data$group == "ADHD")
  nd_chose = sum(!is.na(data[i]) & data$group == "ND non-ADHD")
  nt_chose = sum(!is.na(data[i]) & data$group == "NT")
  percent_adhd = adhd_chose / num_adhd * 100
  percent_nd = nd_chose / num_nd_nonadhd * 100
  percent_nt = nt_chose / num_nt * 100
  percent_total = total_chose / total_people * 100
  
  # Make new row to df
  new_row = data.frame(col.name = column_name,
                       adhd.chose = adhd_chose,
                       nd.chose = nd_chose,
                       nt.chose = nt_chose,
                       total.chose = total_chose,
                       percent.adhd = percent_adhd,
                       percent.nd = percent_nd,
                       percent.nt = percent_nt,
                       percent.total = percent_total)
  
  # Append new row to strategy df
  df = rbind(df, new_row)
  return(df)
}

# Utility function for adding rows to challenge/strength model dfs
add_polr_row = function(curr_data, df, i, task_competency) {
  colname = colnames(curr_data)[i]
  print(paste("THIS IS THE TEST: ", colname))
  curr_data[[i]] = ordered(curr_data[[i]])
  
  # Make formula into string using paste
  # Simplest model
  formula = ""
  if (is.null(task_competency)) {
    formula = paste(colname, "~ group + yoe + pmh_avg + wfh_status")
  }
  else {
    formula = paste(colname, "~ group + yoe + pmh_avg + wfh_status +", task_competency)
  }
  
  print(formula)
  
  m = polr(formula, data = data, Hess = TRUE, na.action = na.omit)
  
  # Check prop odds assumption
  br = brant(m)
  omnibus = br[1, 3]
  
  # Check to see if the polr model is appropriate and keep that as data in the dataframe
  brant_pass = omnibus > .05
  
  # Extract z-values from the summary
  summary_polr = summary(m)
  z_values = summary_polr$coefficients[, "t value"]
  
  # Calculate p-values
  p_values = 2 * pnorm(-abs(z_values))
  if (is.null(task_competency)) {
    p_values = p_values[1:6]
  }
  else {
    p_values = p_values[1:7]
  }
  
  print(confint(m))
  new.row = data.frame()
  
  # Extract coefficients
  coefficients = coef(m)
  
  # Calculate odds ratios for each coefficient -- basically an effect size for how much sway each predictor has on the response variable. Increase by 1, or from reference value, increases the odds of increasing the response
  # variable by one level by [odds ratio] times
  odds_ratios = exp(coefficients)
  
  if (is.null(task_competency)) {
    new.row = data.frame(challenge = colname,
                         can_use = brant_pass,
                         adhdp = p_values[1],
                         ndp = p_values[2],
                         yoep = p_values[3],
                         pmhp = p_values[4],
                         hybridp = p_values[5],
                         wfhp = p_values[6])
  }
  
  else {
  new.row = data.frame(challenge = colname,
                       can_use = brant_pass,
                       adhdp = p_values[1],
                       ndp = p_values[2],
                       yoep = p_values[3],
                       pmhp = p_values[4],
                       hybridp = p_values[5],
                       wfhp = p_values[6],
                       compp = p_values[7])
  }
  odds_ratio_df = as.data.frame(t(odds_ratios))
  if (is.null(task_competency)) {
    colnames(odds_ratio_df) = c("coef_adhd", "coef_nd", "coef_yoe", "coef_pmh", "coef_hybrid", "coef_wfh")
  }
  else {
    colnames(odds_ratio_df) = c("coef_adhd", "coef_nd", "coef_yoe", "coef_pmh", "coef_hybrid", "coef_wfh", "coef_comp")
  }
  new.row = cbind(new.row, odds_ratio_df)
  df = rbind(df, new.row)
  return(df)
}

# Forgot to change all acc difficulty answers to numerical values rather than their individual names
data$acc.difficulty[data$acc.difficulty == "Extremely easy"] = 0
data$acc.difficulty[data$acc.difficulty == "Somewhat easy"] = 1
data$acc.difficulty[data$acc.difficulty == "Neither easy nor difficult"] = 2
data$acc.difficulty[data$acc.difficulty == "Somewhat difficult"] = 3
data$acc.difficulty[data$acc.difficulty == "Extremely difficult"] = 4