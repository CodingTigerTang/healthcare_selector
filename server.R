
server <- function(input, output, session) {
  
observeEvent(input$Plan1_de, {
  feedbackWarning(
    inputId = "Plan1_de",
    show = input$Plan1_de < 0,
    text = "Plan deductable cannot be below 0"
      
  )
})
  
observeEvent(input$Plan2_de, {
    feedbackWarning(
      inputId = "Plan2_de",
      show = input$Plan2_de < 0,
      text = "Plan deductable cannot be below 0"
      
    )
})

observeEvent(input$Plan3_de, {
  feedbackWarning(
    inputId = "Plan3_de",
    show = input$Plan3_de < 0,
    text = "Plan deductable cannot be below 0"
    
  )
})

bill <- c(0:50)*1000

data <- reactive({ 

  plan1_c <- input$Plan1_name
  
  data <- tibble(
    plan1 = map_dbl(bill,pay_cal,deductable = input$Plan1_de,
                                out_of_pocket = input$Plan1_po,
                                coinsurance = input$Plan1_co,
                                premium = input$Plan1_pm, 
                                HSA_contribution = input$Plan1_hsa, 
                                company_match = input$Plan1_hsa_c
                                  ),
  plan2 = map_dbl(bill,pay_cal,deductable = input$Plan2_de,
                  out_of_pocket = input$Plan2_po,
                  coinsurance = input$Plan2_co,
                  premium = input$Plan2_pm, 
                  HSA_contribution = input$Plan2_hsa, 
                  company_match = input$Plan2_hsa_c),
  plan3 = map_dbl(bill,pay_cal,deductable = input$Plan3_de,
                 out_of_pocket = input$Plan3_po,
                 coinsurance = input$Plan3_co,
                 premium = input$Plan3_pm, 
                 HSA_contribution = input$Plan3_hsa, 
                 company_match = input$Plan3_hsa_c),
  bill
) 
  
colnames(data)[1:3] <- c(input$Plan1_name,input$Plan2_name,input$Plan3_name)    
  
data %>% 
    gather(key = "plan",value = "payable",-bill)
})


# ggplot render ------------------------------------------------------------------  

output$comparison <- renderPlotly({
 req(input$compare) 
a <- ggplot(data = data(),aes(x = bill, y = payable,color = plan)) + 
  geom_point(aes(text = paste0(sprintf("<br>bill: $%s <br> payable: $%s <br> plan: %s",comma(bill),comma(payable),plan)))) + 
  geom_line() 

ggplotly(a,tooltip = "text")
  
})

# recommendation ----------------------------------------------------------
data1 <<- reactive({
  
data <- tibble(
  Plan1 = map_dbl(bill,pay_cal,deductable = input$Plan1_de,
                  out_of_pocket = input$Plan1_po,
                  coinsurance = input$Plan1_co,
                  premium = input$Plan1_pm, 
                  HSA_contribution = input$Plan1_hsa, 
                  company_match = input$Plan1_hsa_c
  ),
  Plan2 = map_dbl(bill,pay_cal,deductable = input$Plan2_de,
                  out_of_pocket = input$Plan2_po,
                  coinsurance = input$Plan2_co,
                  premium = input$Plan2_pm, 
                  HSA_contribution = input$Plan2_hsa, 
                  company_match = input$Plan2_hsa_c),
  Plan3 = map_dbl(bill,pay_cal,deductable = input$Plan3_de,
                  out_of_pocket = input$Plan3_po,
                  coinsurance = input$Plan3_co,
                  premium = input$Plan3_pm, 
                  HSA_contribution = input$Plan3_hsa, 
                  company_match = input$Plan3_hsa_c),
  bill = c(0:50)*100
) 

colnames(data)[1:3] <- c(input$Plan1_name,input$Plan2_name,input$Plan3_name)

data

})



output$comparison2 <- renderDataTable( {
  req(input$compare) 
data1() %>% 
    mutate(choice = case_when(
      eval(as.name(input$Plan1_name)) < .data[[input$Plan2_name]] & .data[[input$Plan1_name]]  < .data[[input$Plan3_name]] ~ input$Plan1_name,
      .data[[input$Plan2_name]]  < .data[[input$Plan1_name]]  & .data[[input$Plan2_name]]  < .data[[input$Plan3_name]] ~ input$Plan2_name,
      TRUE ~ input$Plan3_name)) %>% 
    select(bill,
           .data[[input$Plan1_name]],
           .data[[input$Plan2_name]],
           .data[[input$Plan3_name]],
           recommended_choice = choice) %>% 
    arrange(desc(bill)) %>% 
    datatable(rownames = F,class = 'hover cell-border stripe compact nowrap', extensions = 'Buttons', options = list(dom = 'Bfrtip',buttons = c('copy', 'csv', 'excel', 'pdf', 'print'))) %>% 
    formatCurrency(
      c(input$Plan1_name,
      input$Plan2_name,
      input$Plan3_name,
      "bill"),
      currency = "$",
      interval = 3,
      mark = ",",
      digits = 0,
      dec.mark = getOption("OutDec"),
      before = TRUE
    )
  
  },server = FALSE)

}




