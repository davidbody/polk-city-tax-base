setwd("~/study/data_products/assessor-data")

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

        comCities <- comData[48:67, 1]
        comValues <- as.numeric(comData[48:67, 4])

        indCities <- indData[49:68, 1]
        indValues <- as.numeric(indData[49:68, 4])
    } else {
        stop(paste(year, "is not a valid year"))
    }

    data.frame(city = agCities, year = year, residential = resValues, commercial = comValues, industrial = indValues, agricultural = agValues)
}

df <- data.frame()
for(year in years) {
    df <- rbind(df, readValues(year))
}

df$total <- df$residential + df$commercial + df$industrial + df$agricultural

plotCity <- function(df, city) {
    library(reshape2)
    library(ggplot2)
    library(scales)

    percent_residential <- df[df$city == city, c(1,2,3,7)]
    percent_residential$percent <- percent_residential$residential / percent_residential$total

    city.without_totals <- df[df$city == city, -7]

    city.m <- melt(city.without_totals, id.vars = c("year", "city"), variable.name = "prop_class")

    g <- ggplot(city.m, aes(x = year, y = value, fill = prop_class))
    g <- g + geom_bar(stat="identity")
    g <- g + scale_y_continuous(labels = dollar)
    g <- g + scale_x_continuous(breaks = years)
    g <- g + labs(title = city, y = "Assessed Property Value", x = "Year")
    g <- g + labs(fill = "Property Class")

    for(year in years) {
        r <- percent_residential[percent_residential$year == year, 3]
        p <- percent_residential[percent_residential$year == year, 5] * 100
        g <- g + annotate("text", x = year, y = r * .95, label = sprintf("%.1f %%", p))
    }

    g
}

plotCity(df, "Polk City")
