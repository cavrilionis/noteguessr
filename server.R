
server <- function(input, output, session) {
  
  reactive_note <- reactiveVal()
  
  observeEvent(NULL, {
    generate_note()
  }, once = TRUE)
  
  generate_note <- function() {
    note_names <- c("C3", "D3", "E3", "F3", "G3", "A3", "B3", "C4")
    random_note <- sample(note_names, 1)
    reactive_note(random_note)
    
    output$staff <- renderPlot({
      gm(
        list(
          clef = "bass",
          time_signature = "4/4",
          note(random_note, duration = 1)
        )
      )
    })
    
    invalidateLater(10000, session)
    observeEvent(invalidateLater(10000, session),{
      showModal(modalDialog(
        title = "Time's up!",
        "Time is up! Please press refresh to play again.",
        easyClose = TRUE,
        footer = NULL
      ))
      disable("submit")
    }, ignoreNULL = FALSE, once = TRUE)
  }
  
  observeEvent(input$submit, {
    guessed_note <- input$guess
    correct_note <- reactive_note()
    
    if (guessed_note == correct_note) {
      output$result <- renderText("Correct!")
    } else {
      output$result <- renderText(paste("Incorrect. The correct note was:", correct_note))
    }
  })
}
