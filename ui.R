source("pages/main.R")
source("pages/readme.R")

ui <- navbarPage(theme = shinytheme("sandstone"),
                 title = "HealthCare selector",
                 
                 tabPanel("main page",
                          icon  = icon("tasks"),
                          main
                 ),
                 tabPanel("readme",
                          icon  = icon("info-circle"),
                          readme
                 ),
                 useShinyFeedback() 
)

