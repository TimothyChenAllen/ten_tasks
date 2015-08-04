# dplyr / readr version
require(dplyr)
require(readr)

pa.raw <- read_csv(file = "PAData.csv", col_types = "iciicccccccddddd")
pa.pretty <-  pa.raw %>% 
  select(dr=DISASTER_NUMBER, pw=PW_NUMBER, version=VERSION_NUMBER,
    eligibility=ELIGIBILITY_STATUS, size=PROJECT_SIZE, cat=DAMAGE_CATEGORY_CODE,
    amount=PROJECT_AMOUNT)

# Find the 80th percentile for large projects version zero for each dr
pa.80pct <- pa.pretty %>% 
  filter(version==0, eligibility!="Ineligible", size=="Large") %>%
  group_by(dr) %>% summarize(pct80=quantile(amount, probs=.8, na.rm=TRUE)) %>%
  print

# Find the mean project amount as grouped by size, cat, pct80
expected.versions <- left_join(pa.pretty, pa.80pct) %>% 
  mutate(lower80=(amount<pct80)) %>%
  group_by(size, cat, lower80) %>%
  summarize(expected.versions=mean(version)) %>%
  filter(!is.na(lower80))

View(expected.versions)
# write_csv(expected.versions, "expected_versions.csv")

