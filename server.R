require(shiny)

#Set path to data directory
wd.datapath = paste0(getwd(),"/data")
wd.init = getwd()
setwd(wd.datapath)

#Read riskdata and premiumdata files
premiumData = read.csv("Premium.csv", header = TRUE)

setwd(wd.init)        

shinyServer(function(input, output) {
  
    #Display greeting with name captured
    output$displayname <- reactive({ 
        if (input$name == "" || input$name == " ")
        {
            ""
        }
        else
        {
            paste("Hi ", input$name, ",")
        }
    })        


    #Show premium table accordingly to sex input and current age range and beyond
    #Premium amount is calculated based on the original premium * (1 + combine risk) which is the extra "loading"
    output$view <- renderDataTable({
        
        #Set cigarette risk
        cigarette_risk_index <- switch(input$cigarette, 
                       "0" = 0,
                       "1-3" = 0.1,
                       "4-5" = 0.3,
                       ">5" = 0.5)        

        #Set occupation risk
        occupation_risk_index <- switch(input$occupation, 
                                       "Office" = 0,
                                       "Sales" = 0.1,
                                       "Construction" = 0.3)        

        #Set pre-existing condition risk
        preexistingcondition_risk_index <- if (input$preexistingcondition) 1 else 0   
        
        #Sum all risks to give final risk index
        combine_risk_index <- cigarette_risk_index + occupation_risk_index + preexistingcondition_risk_index
        
        a <- premiumData
                
        a$Premium <- a$Premium * (1 + combine_risk_index)
        
        #Subset to the select sex
        a <- subset(a, Sex==input$sex)
        
        #Subset only to show the current age range and beyond
        a[1:NROW(a) > input$age %/% 10, ]
    })
})