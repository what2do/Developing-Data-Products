require(shiny)

shinyUI(bootstrapPage(
  titlePanel("Risk Calculator"),
  sidebarLayout(
    sidebarPanel(
        textInput("name", "Name:"),
        br(),        
        radioButtons("sex", "Sex:",
                     c("Male" = "M",
                       "Female" = "F")),
        br(),        
        sliderInput("age",
                    "Your age as of 1st Jan this year:",
                    min = 1,
                    max = 75,
                    value = 1),
        br(),        
        selectInput("cigarette", "Number of cigarette you smoke a day:", 
                    choices = c("0", "1-3", "4-5", ">5")),
        br(),        
        selectInput("occupation", "Your Occupation:", 
                    choices = c("Office", "Sales", "Construction")),
        br(),        

        checkboxInput("preexistingcondition", 
                      "Do you have any pre-existing condition?", value = FALSE),
        br(),        
        helpText("Note: The calculator will base on the inputs provided above to compute a risk index and work out the premium rates to pay from the current age band onwards."),
        
        submitButton("Compute")
    ),
    mainPanel(
      h2(textOutput("displayname")),
      br(),
      tabsetPanel(
          tabPanel("Premium", br(), h3("Your computed annual premiums are as below:"), br(), dataTableOutput("view")),
          tabPanel("About", br(), h3("Risk Calculator"), br(), 
                   p("The calculator will base on the inputs provided on the left tab to compute a risk index and work out the premium rates to pay from the current age band onwards."), br(), 
                   h3("How it works"), p("Overall risk index is computed as the sum of the below risk indexes"), 
                   h4("Cigarette risk index"), p("0 -> 0"),p("1-3 -> +0.1"),p("4-5 -> +0.3"),p(">5 -> +0.5"), br(),
                   h4("Occupation risk index"), p("Office -> 0"),p("Sales -> +0.1"),p("Construction -> +0.3"), br(),
                   h4("Pre-existing condition risk index"), p("No -> 0"),p("Yes -> +1"), br(),
                   p("The index is multiplied to the original premium as the extra loading for the risks."), br(),
                   p("The premium table will based on the Sex specified and age selected to only display the premium for the Sex and show the premiums for the current age band onwards.")
          )          
      )
    )
  )
))