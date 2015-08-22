setwd("~/study/developing_data_products/assessor-data")

years <- 2008:2015

for(year in years) {
    dataUrl <- paste("http://web.assess.co.polk.ia.us/info/web/abstract/", year, "/AbstractReconciliationPolk", year, ".xls", sep="")
    fileName <- paste("./data/AbstractReconciliationPolk", year, ".xls", sep="")
    if (!file.exists(fileName)) {
        print(paste("Fetching data for", year))
        download.file(dataUrl, destfile=fileName, method="libcurl")
    } else {
        print(paste("We already have data for", year))
    }
}

library(xlsx)

readValues = function(year) {
    print(paste("Loading data for", year))

    fileName <- paste("./data/AbstractReconciliationPolk", year, ".xls", sep="")

    agData  <- read.xlsx(fileName, 1, stringsAsFactors = FALSE)
    resData <- read.xlsx(fileName, 3, stringsAsFactors = FALSE)
    comData <- read.xlsx(fileName, 4, stringsAsFactors = FALSE)
    indData <- read.xlsx(fileName, 6, stringsAsFactors = FALSE)

    if (year %in% 2008:2013) {
        agCities <- c(agData[34:52, 1], "Windsor Heights")
        agValues <- c(as.numeric(agData[34:52, 5]), 0)

        resCities <- resData[35:54, 1]
        resValues <- as.numeric(resData[35:54, 4])

        comCities <- comData[35:54, 1]
        comValues <- as.numeric(comData[35:54, 4])

        indCities <- indData[34:53, 1]
        indValues <- as.numeric(indData[34:53, 4])
    } else if (year %in% 2014:2015) {
        agCities <- agData[49:68, 1]
        agValues <- as.numeric(agData[49:68, 5])

        resCities <- resData[48:67, 1]
        resValues <- as.numeric(resData[48:67, 4])

        # Multiresidential class added 2015
        if (year >= 2015) {
            mrData <- read.xlsx(fileName, 5, stringsAsFactors = FALSE)
            mrValues <- as.numeric(mrData[48:67, 4])
            resValues <- resValues + mrValues
        }

        comCities <- comData[48:67, 1]
        comValues <- as.numeric(comData[48:67, 4])

        indCities <- indData[49:68, 1]
        indValues <- as.numeric(indData[49:68, 4])
    } else {
        stop(paste(year, "is not a valid year"))
    }

    data.frame(city = agCities, year = year, residential = resValues, commercial = comValues, industrial = indValues, agricultural = agValues)
}

data_file <- "./data/prop_vals.Rda"

if(!file.exists(data_file)) {
    prop_vals <- data.frame()
    for(year in years) {
        prop_vals <- rbind(prop_vals, readValues(year))
    }
    save(prop_vals, file = data_file)
}
