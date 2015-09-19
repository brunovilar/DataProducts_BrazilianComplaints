library(shiny)
library(memoise)
library("data.table")
library("ggplot2")
library("dplyr")

getComplaints = memoise(function(){

    #Creates an empty data.frame
    ds = data.frame()
    
    #Loads and merge all files from consumidor.gov.br
    for(f in list.files("data", pattern = "*.csv")){
        ds = rbind(ds, fread(input = paste0("data/", f), stringsAsFactors=TRUE))
    }

    #Defines the column names
    setnames(ds, c("Region", "State", "City", "Gender", "Age", "OpeningYear", "OpeningMonth", "OpeningDate", "AnswerDate", "ClosingDate", "AnswerTime", "Company", "MarketSegment", "Area", "Subject", "GroupProblem", "Problem", "HowItWasBoughtOrContracted", "ConcatectedCompany", "Answered", "Status", "Assessment", "Rating"))

    #Extracts the original Market Segment values
    originalMarketSegmentNames = unique(ds$MarketSegment)

    #Creates a translated version of the unique market segment values
    translatedMarketSegmentNames = c("Telecom",  "Finance",  "Shopping", "Manufacturers - Electronics & Computers", "Energy, Water and Sewage", "Brokers and Insurance", "Retail", "Traveling", "Air Transport", "Carriers", "Supermarkets", "Consortium", "Manufacturers - Freezers, Air Conditioners, etc.", "Manufacturers - Appliances", "Online Payment", "Perfumery", "Credit",  "Pharmaceutics", "Sports", "Loyalty Programs", "Educational Institutions", "Energy, Water and Sewage", "CRM", "Internet service provider", "Land transport", "Publishers")

    #Replaces the original market segment names by the correspondent translation
    ds$MarketSegment = as.factor(sapply(ds$MarketSegment, function(item){
        translatedMarketSegmentNames[which(item == originalMarketSegmentNames)]
    }))

    #Extracts the original list of assessment values
    originalAssessments = unique(ds$Assessment)
    
    #Creates a translated version of the unique assessment values
    translatedAssessments = c("Resolved", "Unresolved", "Not Assessed")

    #Replaces the original assessment values by the correspondent translation
    ds$Assessment = as.factor(sapply(ds$Assessment, function(item){
        translatedAssessments[which(item == originalAssessments)]
    }))

    #Selects only the used columns and renames the Assessment to Complaints
    ds %>% select(OpeningYear, OpeningMonth, MarketSegment, Assessment, Region) %>% rename(Complaints=Assessment)
})

#Returns the list of unique combination of values from month/year in order to fill the HTML component
getYearMonth = memoise(function(){
    uniqueYearMonthCombination = select(ds, OpeningYear, OpeningMonth) %>% unique() %>% as.data.frame()

    c(
        "All Periods",
        paste0(uniqueYearMonthCombination[, c('OpeningMonth')], '/', uniqueYearMonthCombination[, c('OpeningYear')])
    )
})
#Returns the list of unique region names in order to fill the HTML component
getRegion = memoise(function(){
    regions = select(ds, Region) %>% unique()

    c(
        "All Regions",
        regions
    )
})

#Creates a variable filled with the main dataset used
ds = getComplaints()
