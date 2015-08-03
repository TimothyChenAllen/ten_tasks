# Get some data
URL <- "http://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsDetails.csv"
require(readr)
download.file(URL, destfile="PA_projects.csv", mode="wb")
pa_projects <- read_csv("PA_projects.csv")

# Extract just part of the PA dataset
require(dplyr)
pa_tx <- pa_projects %>% 
        select(dr=disasterNumber, pw=pwNumber, cat=damageCategoryCode,
             size=projectSize, county, state=stateCode,
             amount=projectAmount, fed.share=federalShareObligated,
             obligated=totalObligated) %>% 
        filter(state=="TX", amount>0) %>% 
        mutate(cat=substr(cat,1,1)) %>%
        print

write_csv(pa_tx, path = "pa_tx_extract.csv")

# Create a fake missing data set
pa_missing <- pa_tx
pa_missing[sample(NROW(pa_missing), size = NROW(pa_missing)/100),]$amount <- NA
write_csv(pa_missing, path = "pa_tx_missing.csv")


require(ggplot2)
ggplot(pa_tx_extract) + aes(x=log.amount, color="black", fill="red") + 
        geom_histogram() + theme_bw()

hist(pa_tx_extract$log.amount, col="blue", density=16)



require(readr)
require(dplyr)
URL <- "http://www.fema.gov/api/open/v1/DisasterDeclarationsSummaries.csv"
download.file(URL, destfile="decs.csv", mode="wb")
decs <- read.csv("decs.csv")
tbl_df(decs)
