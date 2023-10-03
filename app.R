library(shiny)
library(tidyverse)
library(plotly)
library(DT)
library(openxlsx)


netflix_data <- readr::read_csv("C:/Users/maria/OneDrive/Escritorio/RStudio/netflix_titles.csv")

# Pregunta 1: ¿Cuál es la distribución de programas por tipo (TV Show o Movie)?
programs_by_type <- netflix_data %>%
  group_by(type) %>%
  summarise(count = n())

# Pregunta 2: ¿Cuál es el país con más programas en Netflix?
programs_by_country <- netflix_data %>%
  filter(!is.na(country)) %>%
  group_by(country) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  top_n(10)


ui <- fluidPage(
  titlePanel("Análisis de Programas de Netflix"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Preguntas de interés:"),
      p("1. ¿Cuál es la distribución de programas por tipo (TV Show o Movie)?"),
      p("2. ¿Cuál es el país con más programas en Netflix?"),
      downloadButton('downloadData', 'Descargar datos en Excel')
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Pregunta 1", plotlyOutput("plot1")),
        tabPanel("Pregunta 2", DTOutput("table1"))
      )
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlotly({
    # Gráfico de la distribución de programas por tipo
    plot_ly(programs_by_type, x = ~type, y = ~count, type = 'bar') %>%
      layout(title = "Distribución de programas por tipo", xaxis = list(title = "Tipo"), yaxis = list(title = "Cantidad"))
  })
  
  output$table1 <- renderDT({
    # Tabla de los países con más programas en Netflix
    datatable(programs_by_country, options = list(pageLength = 10), 
              caption = "Países con más programas en Netflix")
  })
  
  # Función para descargar los datos en Excel
  output$downloadData <- downloadHandler(
    filename = function() { paste("netflix_programs_data_", Sys.Date(), ".xlsx", sep = "") },
    content = function(file) {
      write.xlsx(netflix_data, file)
    }
  )
}

shinyApp(ui, server)


