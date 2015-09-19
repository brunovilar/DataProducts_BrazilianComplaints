library(dplyr)

shinyServer(function(input, output, session) {

    #Create a reactive function to filter the dataset according to the month/year selected
    data <- reactive({

        filteredDS = ds
        
        #If there is a month/year selected, filters using it
        if(grepl(".*/.*", input$monthYear)){
            month = as.numeric(gsub("/.*", "", input$monthYear))
            year = as.numeric(gsub(".*/", "", input$monthYear))
            filteredDS = filteredDS %>%
                filter(OpeningMonth == month, OpeningYear == year)
        }
        
        #If there is a regions selected, filters using it
        if(input$region != "All Regions"){
            filteredDS = filteredDS %>%
                filter(Region == input$region)
        }
    
        filteredDS %>% select(MarketSegment, Complaints)
    })

    #Creates the a bar plot using the updated dataset
    output$chart <- renderPlot({
        if(input$region == "All Regions"){
            if(!grepl(".*/.*", input$monthYear)){
                titleComplement = paste0(input$monthYear, " and Regions")
            } else {
                titleComplement = paste0(input$monthYear, " from All Regions")
            }
        } else {
            titleComplement = paste0(input$monthYear, " from ", input$region)
        }
        
        ggplot(data(), aes(x = MarketSegment, fill=Complaints)) +
            labs(title = paste0("Complaints by Market Segments - ", titleComplement),  y = "Number of Complaints", x = "Market Segment") + 
            geom_bar() + 
            coord_flip() + 
            theme_grey(base_size = 19) +
            scale_fill_manual(values = c("#808080", "#2E8B57","#FF6347"))
    })
})