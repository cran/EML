## ------------------------------------------------------------------------
library("EML")

## ------------------------------------------------------------------------
custom_units <- 
  data.frame(id = "speciesPerSquareMeter", 
             unitType = "arealDensity", 
             parentSI = "numberPerSquareMeter", 
             multiplierToSI = 1, 
             description = "number of species per square meter")


unitList <- set_unitList(custom_units)

## ------------------------------------------------------------------------
me <- list(individualName = list(givenName = "Carl", surName = "Boettiger"))
my_eml <- list(dataset = list(
              title = "A Minimal Valid EML Dataset",
              creator = me,
              contact = me),
              additionalMetadata = list(metadata = list(
                unitList = unitList
              ))
            )


## ------------------------------------------------------------------------
write_eml(my_eml, "eml-with-units.xml")
eml_validate("eml-with-units.xml")

## ------------------------------------------------------------------------
f <- system.file("tests", emld::eml_version(), "eml-datasetWithUnits.xml", package = "emld")
eml <- read_eml(f)

## ----include = FALSE-----------------------------------------------------
# clean up
unlink("eml-with-units.xml")

