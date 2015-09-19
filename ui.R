library("shiny")

shinyUI(
    fluidPage(        
        #Include page title centralized
        h1("Brazilian Complaints on consumidor.gov.br", style="text-align:center"),
    
        #Create layout with side bar and main panel
        sidebarLayout(
            #Configure side bar
            sidebarPanel(
                h4("Filter Data", style="text-align:center"), #Side bar title
                br(), #line break
                selectInput('monthYear', 'Month/Year', getYearMonth(), selected="All Periods"), #Input Field
                selectInput('region', 'Region', getRegion(), selected="All Regions") #Input Field
            ),
            #Configure main panel
            mainPanel(
                plotOutput('chart') #Set the content of the panel as the plot
            )
        ),

        hr(), #Horizontal line

        #Configure a new panel to describe the application
        mainPanel(
            h2("Application's Information"), #Section title
            p("The goal of this application is visualize complaints by Market Segments from Brazil. It allows to filter complaints by period and/or regions."), #Paragraph
            h3("Instructions"), #Subsection title
            p(HTML("The application can be used as follows: <ul><li>Use the control panel on the left to set the month/year and/or region to filter the data;</li><li>The plot is presented on the right side of the application, presenting the number of complaints by Market Segment.</li></ul>")), #Paragraph with bullets
            h3("Dataset"), #Subsection title
            p(HTML("The dataset used was obtained from <a href='http://dados.gov.br/'>dados.gov.br</a>, a brazilian website for government's open-data. The source of the data is from <a href='https://www.consumidor.gov.br/'>consumidor.gov.br</a>, which allows consumers to register complaints about products or services.")) #Paragraph
        )
    )
)