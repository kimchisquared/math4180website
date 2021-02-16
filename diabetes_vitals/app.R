#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(readr) #for reading in data
library(data.table) # for reading in large files
library(janitor) #for tably function (similar to table function)
library(skimr) # for skim function (similar to summary function)
library(naniar) #for missing values
library(shiny)


training <- fread("https://math4180.netlify.app/data/TrainingWiDS2021.csv")
dictionary <- fread("https://math4180.netlify.app/data/DataDictionaryWiDS2021.csv")
vitalnames<- training %>%
    select(contains("h1")|contains("d1")) %>% 
    names()%>%
    gsub("^[h|d]1_(.*)_[minmax]+","\\1",.) %>%
    gsub("(.*)_.*", "\\1", .) %>%
    unique()


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Diabetes dataset vitals"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("vital", 
                        label = "Vitals and Labs:",
                        choices = vitalnames, 
                        selected = vitalnames[1])
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("missing_subsets")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$missing_plot <- renderPlot({
        training %>%
            #sample_frac(size=input$subset) %>%
            select(contains(input$vital)) %>%
            vis_miss(warn_large_data = F)
    })
    output$missing_subsets <- renderPlot({
        training %>%
            #sample_frac(size=input$subset) %>%
            select(contains(input$vital)) %>%
            gg_miss_upset(nsets=15)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
