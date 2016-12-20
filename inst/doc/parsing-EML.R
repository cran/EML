## ------------------------------------------------------------------------
library("EML")
f <- system.file("xsd/test/eml-i18n.xml", package = "EML")
eml <- read_eml(f)

## ------------------------------------------------------------------------
coverage <- eml_get(eml, "coverage")
coverage

## ------------------------------------------------------------------------
eml_get(coverage, "temporalCoverage")

## ------------------------------------------------------------------------
eml_HARV <- read_eml("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")

## ------------------------------------------------------------------------
dt <- eml_get(eml_HARV, "dataTable")
length(dt)

## ------------------------------------------------------------------------
entities <- sapply(dt, eml_get, "entityName")
urls <- sapply(dt, eml_get, "url")

## ------------------------------------------------------------------------
urls <- sapply(dt, function(x) x@physical[[1]]@distribution[[1]]@online@url)

## ------------------------------------------------------------------------
attrs <- eml_get(dt, "attributeList") 
length(attrs)
attrs[[1]]

## ------------------------------------------------------------------------
get_attributes(eml_HARV@dataset@dataTable[[1]]@attributeList)

