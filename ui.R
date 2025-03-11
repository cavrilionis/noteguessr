
fluidPage(
  useShinyjs(),
  theme = shinythemes::shinytheme("yeti"),
  titlePanel("NoteGuessR"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "numNotes",
        "Number of Notes to Guess:",
        min = 5,
        max = 30,
        value = 5
      ),
      radioButtons(
        "guess",
        "Guess the Note:",
        choices = c("C", "D", "E", "F", "G", "A", "B"),
        selected = character(0)
      ),
      actionButton("submit", "Submit"),
      actionButton("restart", "Restart")
    ),
    mainPanel(
      imageOutput("noteImage"),
      textOutput("result"),
      textOutput("percentage"),
    )
  )
)
