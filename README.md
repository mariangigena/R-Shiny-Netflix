# Análisis de Programas de Netflix con Shiny
![Imagen](https://github.com/mariangigena/R-Shiny-Netflix/blob/main/Banner%20para%20github.png)



## Descripción

Este proyecto utiliza una aplicación Shiny en R para analizar datos sobre programas de Netflix. La aplicación responde a dos preguntas interesantes sobre el conjunto de datos de programas de Netflix  1. ¿Cuál es la distribución de programas por tipo (TV Show o Movie)?,
2. ¿Cuál es el país con más programas en Netflix? y ademas permite generar un archivo de Excel con información relevante.

## Conjunto de Datos

Se utiliza el conjunto de datos de programas de Netflix que se encuentra en el siguiente enlace: [TidyTuesday Netflix Programs Data](https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-04-20). Este conjunto de datos incluye información sobre programas disponibles en Netflix.

## Puntos Clave de la Aplicación

1.`Proceso On-Demand para Generar un Archivo Excel`: La aplicación Shiny permite a los usuarios generar un archivo de Excel descargable con los datos de programas de Netflix al hacer clic en el botón "Descargar datos en Excel".

2.` Estructuración de la Aplicación Shiny`: Aunque no sigue un diseño de dashboard, la aplicación tiene una estructura organizada con una barra lateral y un área principal para mostrar gráficos y tablas de manera clara y funcional.

3.` Uso de Librerías Relacionadas con Shiny`: Se utilizan librerías como "shiny", "tidyverse", "plotly" y "DT", todas relacionadas con Shiny, para crear la interfaz y visualizaciones interactivas.

4.`Uso de Tidyverse para Manipular los Datos`: Funciones del tidyverse, como dplyr y tidyr, se utilizan de manera eficiente para manipular y analizar los datos de programas de Netflix.

5.`Adherencia al Tidyverse Style Guide`: El código sigue los principios de DRY (Don't Repeat Yourself) y es legible, utilizando funciones del tidyverse de manera eficiente para manipulaciones de datos.


## Codigo de la Aplicación

```
library(shiny)
library(tidyverse)
library(plotly)
library(DT)
library(openxlsx)  # Nueva adición para cargar openxlsx

# Cargar el conjunto de datos de programas de Netflix
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

# Crear la aplicación Shiny
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
      write.xlsx(netflix_data, file)  # Utiliza write.xlsx de openxlsx
    }
  )
}

shinyApp(ui, server)

```

