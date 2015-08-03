# 10. Download a file
URL <- "https://raw.githubusercontent.com/TimothyChenAllen/ten_tasks/master/pa_tx_extract.csv"
download.file(URL, destfile = "pa_tx_extract.csv", mode="wb")

# 9. Read in a CSV file
pa_tx <- read.csv("pa_tx_extract.csv")

# 8. Look at the data
# See an overview
head(pa_tx)
View(pa_tx)

# Look at a column
pa_tx[ ,1]
pa_tx$amount

# Look at a row
pa_tx[1, ]

# Look at a few rows
pa_tx[1:20, ]

# 7. Graph it
# See how it's distributed
hist(pa_tx_extract$amount, col="blue", density=16)
# Blah!  It's really right skewed!
hist(log(pa_tx_extract$amount), col="blue", density=16)

# Plot a scatterplot and a best-fit line
plot(x=mtcars$wt, y=mtcars$mpg, bg=mtcars$cyl, pch=21)
abline(lm(mpg ~ wt, data=mtcars))

# 6. Install a library
install.packages("xlsx")

# 5. Load an Excel file
download.file("https://github.com/TimothyChenAllen/ten_tasks/blob/master/decs_merged.xlsx?raw=true",
              destfile="decs_merged.xlsx", mode="wb")
require(openxlsx)
decs <- read.xlsx(xlsxFile="decs_merged.xlsx", sheet="decs",startRow=5)
head(decs)

# 4. Find rows with missing data
download.file("https://raw.githubusercontent.com/TimothyChenAllen/ten_tasks/master/pa_tx_missing.csv",
              destfile="pa_missing.csv", mode="wb")
pa_missing <- read.csv("pa_missing.csv")
# How many rows have missing data?
sum(!complete.cases(pa_missing))
# View rows with missing data
View(pa_missing[!complete.cases(pa_missing),])
# Let's keep track of which rows had missing data
missing <- rownames(pa_missing[!complete.cases(pa_missing),])

# 3. Deal with missing data (Multiple Imputation)
# http://www.ats.ucla.edu/STAT/r/faq/R_pmm_mi.htm
require(mice)
# Use Multiple Imputation to model missing values
pa_imputed <- mice(pa_missing, m = 5)
# load(file="pa_imputed.SAV") # Just in case

# Create a dataset using these predicted values
pa_complete <- complete(x=pa_imputed, action=5)
# There are no missing numbers now
sum(!complete.cases(pa_complete))
# Let's see the rows that were missing values
View(pa_complete[missing,])