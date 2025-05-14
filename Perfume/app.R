library(shiny)
library(tidyverse)

# Load the data
url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-12-10/parfumo_data_clean.csv"
perfume_data <- read_csv(url)

# UI
ui <- fluidPage(
  
  titlePanel("Perfume Rating Distribution"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_perfume", 
                  "Choose a Perfume Brand:", 
                  choices = sort(unique(perfume_data$Brand)))
    ),
    mainPanel(
      plotOutput("rating_plot")
    )
  )
)

# Server
server <- function(input, output) {
  
  selected_data <- reactive({
    perfume_data %>% filter(Brand == input$selected_perfume)
  })
  
  output$rating_plot <- renderPlot({
    ggplot(perfume_data, aes(y = Rating_Value, x = "")) +
      geom_boxplot(fill = "lightblue", outlier.shape = NA) +
      geom_point(data = selected_data(), 
                 aes(y = Rating_Value), 
                 color = "red", size = 3) +
      labs(title = paste("Rating Distribution (with", input$selected_perfume, "highlighted)"),
           y = "Rating Value",
           x = "") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
