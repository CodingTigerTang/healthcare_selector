main <- fluidPage(

  sidebarLayout(
    
    sidebarPanel ( width = 3,
    
   wellPanel(
     
     tabsetPanel(
       tabPanel(
         title = "Plan1",
         br(),
      textInput("Plan1_name", label = "Code name for plan1",value = "Plan1"),
      numericInput("Plan1_de",label = "Deductable",value = "500"),
      numericInput("Plan1_po",label = "Out of pocket max",value = "2500"),
      numericInput("Plan1_pm",label = "Premium by month",value = "200"),
      numericInput("Plan1_co",label = "Coinsurance(%)",value = "15"),
      numericInput("Plan1_hsa",label = "HSA contribution(total)",value = "0"),
      numericInput("Plan1_hsa_c",label = "HSA company match",value = "0")
      ),
      
       tabPanel(
        title = "Plan2",
        br(),
        textInput("Plan2_name", label = "Code name for plan2",value = "Plan2"),
      numericInput("Plan2_de",label = "Deductable",value = "1000"),
      numericInput("Plan2_po",label = "Out of pocket max",value = "3000"),      
      numericInput("Plan2_pm",label = "Premium by month",value = "120"),
      numericInput("Plan2_co",label = "Coinsurance(%)",value = "20"),
      numericInput("Plan2_hsa",label = "HSA contribution(total)",value = "0"),
      numericInput("Plan2_hsa_c",label = "HSA company match",value = "0")),
      
       tabPanel(
        title = "Plan3",
        br(),
        textInput("Plan3_name", label = "Code name for plan3",value = "Plan3"),
        numericInput("Plan3_de",label = "Deductable",value = "1500"),
        numericInput("Plan3_po",label = "Out of pocket max",value = "5000"),
        numericInput("Plan3_pm",label = "Premium by month",value = "80"),
        numericInput("Plan3_co",label = "Coinsurance(%)",value = "20"),
        numericInput("Plan3_hsa",label = "HSA contribution(total)",value = "0"),
        numericInput("Plan3_hsa_c",label = "HSA company match(total)",value = "0"))
      
      
      ) ,actionButton(inputId = "compare",label = "Compare")
    )
   ),
    
    mainPanel(
      
     plotlyOutput("comparison"),
     dataTableOutput("comparison2")
      
    )
    
  )
)
