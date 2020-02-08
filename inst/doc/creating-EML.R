## ----include=FALSE------------------------------------------------------------
has_pandoc <-  rmarkdown::pandoc_available()

## -----------------------------------------------------------------------------
library(EML)
library(emld)

## -----------------------------------------------------------------------------
attributes <-
tibble::tribble(
~attributeName, ~attributeDefinition,                                                 ~formatString, ~definition,        ~unit,   ~numberType,
  "run.num",    "which run number (=block). Range: 1 - 6. (integer)",                 NA,            "which run number", NA,       NA,
  "year",       "year, 2012",                                                         "YYYY",        NA,                 NA,       NA,
  "day",        "Julian day. Range: 170 - 209.",                                      "DDD",         NA,                 NA,       NA,
  "hour.min",   "hour and minute of observation. Range 1 - 2400 (integer)",           "hhmm",        NA,                 NA,       NA,
  "i.flag",     "is variable Real, Interpolated or Bad (character/factor)",           NA,            NA,                 NA,       NA,
  "variable",   "what variable being measured in what treatment (character/factor).", NA,            NA,                 NA,       NA,
  "value.i",    "value of measured variable for run.num on year/day/hour.min.",       NA,            NA,                 NA,       NA,
  "length",    "length of the species in meters (dummy example of numeric data)",     NA,            NA,                 "meter",  "real")


## -----------------------------------------------------------------------------
i.flag <- c(R = "real",
            I = "interpolated",
            B = "bad")
variable <- c(
  control  = "no prey added",
  low      = "0.125 mg prey added ml-1 d-1",
  med.low  = "0,25 mg prey added ml-1 d-1",
  med.high = "0.5 mg prey added ml-1 d-1",
  high     = "1.0 mg prey added ml-1 d-1",
  air.temp = "air temperature measured just above all plants (1 thermocouple)",
  water.temp = "water temperature measured within each pitcher",
  par       = "photosynthetic active radiation (PAR) measured just above all plants (1 sensor)"
)

value.i <- c(
  control  = "% dissolved oxygen",
  low      = "% dissolved oxygen",
  med.low  = "% dissolved oxygen",
  med.high = "% dissolved oxygen",
  high     = "% dissolved oxygen",
  air.temp = "degrees C",
  water.temp = "degrees C",
  par      = "micromoles m-1 s-1"
)

## Write these into the data.frame format
factors <- rbind(
data.frame(
  attributeName = "i.flag",
  code = names(i.flag),
  definition = unname(i.flag)
),
data.frame(
  attributeName = "variable",
  code = names(variable),
  definition = unname(variable)
),
data.frame(
  attributeName = "value.i",
  code = names(value.i),
  definition = unname(value.i)
)
)

## -----------------------------------------------------------------------------
attributeList <- set_attributes(attributes, factors, col_classes = c("character", "Date", "Date", "Date", "factor", "factor", "factor", "numeric"))

## -----------------------------------------------------------------------------
physical <- set_physical("hf205-01-TPexp1.csv")

## -----------------------------------------------------------------------------
dataTable <- list(
                 entityName = "hf205-01-TPexp1.csv",
                 entityDescription = "tipping point experiment 1",
                 physical = physical,
                 attributeList = attributeList)

## -----------------------------------------------------------------------------
geographicDescription <- "Harvard Forest Greenhouse, Tom Swamp Tract (Harvard Forest)"


coverage <- 
  set_coverage(begin = '2012-06-01', end = '2013-12-31',
               sci_names = "Sarracenia purpurea",
               geographicDescription = geographicDescription,
               west = -122.44, east = -117.15, 
               north = 37.38, south = 30.00,
               altitudeMin = 160, altitudeMaximum = 330,
               altitudeUnits = "meter")

## ----eval=has_pandoc----------------------------------------------------------
methods_file <- system.file("examples/hf205-methods.docx", package = "EML")
methods <- set_methods(methods_file)

## ----include=FALSE, eval=!has_pandoc------------------------------------------
#  ## placeholder if pandoc is not installed
#  methods <- NULL

## -----------------------------------------------------------------------------
R_person <- person("Aaron", "Ellison", ,"fakeaddress@email.com", "cre", 
                  c(ORCID = "0000-0003-4151-6081"))
aaron <- as_emld(R_person)

## -----------------------------------------------------------------------------
others <- c(as.person("Benjamin Baiser"), as.person("Jennifer Sirota"))
associatedParty <- as_emld(others)
associatedParty[[1]]$role <- "Researcher"
associatedParty[[2]]$role <- "Researcher"

## -----------------------------------------------------------------------------
HF_address <- list(
                  deliveryPoint = "324 North Main Street",
                  city = "Petersham",
                  administrativeArea = "MA",
                  postalCode = "01366",
                  country = "USA")

## -----------------------------------------------------------------------------
publisher <- list(
                 organizationName = "Harvard Forest",
                 address = HF_address)

## -----------------------------------------------------------------------------
contact <- 
  list(
    individualName = aaron$individualName,
    electronicMailAddress = aaron$electronicMailAddress,
    address = HF_address,
    organizationName = "Harvard Forest",
    phone = "000-000-0000")


## -----------------------------------------------------------------------------
keywordSet <- list(
    list(
        keywordThesaurus = "LTER controlled vocabulary",
        keyword = list("bacteria",
                    "carnivorous plants",
                    "genetics",
                    "thresholds")
        ),
    list(
        keywordThesaurus = "LTER core area",
        keyword =  list("populations", "inorganic nutrients", "disturbance")
        ),
    list(
        keywordThesaurus = "HFR default",
        keyword = list("Harvard Forest", "HFR", "LTER", "USA")
        ))

## -----------------------------------------------------------------------------
pubDate <- "2012" 

title <- "Thresholds and Tipping Points in a Sarracenia 
Microecosystem at Harvard Forest since 2012"

abstract <- "The primary goal of this project is to determine
  experimentally the amount of lead time required to prevent a state
change. To achieve this goal, we will (1) experimentally induce state
changes in a natural aquatic ecosystem - the Sarracenia microecosystem;
(2) use proteomic analysis to identify potential indicators of states
and state changes; and (3) test whether we can forestall state changes
by experimentally intervening in the system. This work uses state-of-the
art molecular tools to identify early warning indicators in the field
of aerobic to anaerobic state changes driven by nutrient enrichment
in an aquatic ecosystem. The study tests two general hypotheses: (1)
proteomic biomarkers can function as reliable indicators of impending
state changes and may give early warning before increasing variances
and statistical flickering of monitored variables; and (2) well-timed
intervention based on proteomic biomarkers can avert future state changes
in ecological systems."  

intellectualRights <- "This dataset is released to the public and may be freely
  downloaded. Please keep the designated Contact person informed of any
plans to use the dataset. Consultation or collaboration with the original
investigators is strongly encouraged. Publications and data products
that make use of the dataset must include proper acknowledgement. For
more information on LTER Network data access and use policies, please
see: http://www.lternet.edu/data/netpolicy.html."

## ----eval=has_pandoc----------------------------------------------------------
abstract_file <-  system.file("examples/hf205-abstract.md", package = "EML")
abstract <- set_TextType(abstract_file)

## -----------------------------------------------------------------------------
dataset <- list(
               title = title,
               creator = aaron,
               pubDate = pubDate,
               intellectualRights = intellectualRights,
               abstract = abstract,
               associatedParty = associatedParty,
               keywordSet = keywordSet,
               coverage = coverage,
               contact = contact,
               methods = methods,
               dataTable = dataTable)

## -----------------------------------------------------------------------------
eml <- list(
           packageId = uuid::UUIDgenerate(),
           system = "uuid", # type of identifier
           dataset = dataset)


## -----------------------------------------------------------------------------
write_eml(eml, "eml.xml")

## -----------------------------------------------------------------------------
eml_validate("eml.xml")

## ----include=FALSE------------------------------------------------------------
unlink("eml.xml")

