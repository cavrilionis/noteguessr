
ui <- fluidPage(
  titlePanel("Note Guessing Game"),
  mainPanel(
    plotOutput("staff", width = "80%", height = "200px"),
    selectInput("guess", "Guess the Note:",
                choices = c("C3", "D3", "E3", "F3", "G3", "A3", "B3", "C4")),
    actionButton("submit", "Submit Guess"),
    textOutput("result")
  )
)
