

server <- function(input, output, session) {
  # Initialize reactive values
  correct_count <- reactiveVal(0)
  total_count <- reactiveVal(0)
  generated_note <- reactiveVal()
  
  # Notes list
  notes <- c(
    "E2",
    "F2",
    "G2",
    "A2",
    "B2",
    "C3",
    "D3",
    "E3",
    "F3",
    "G3",
    "A3",
    "B3",
    "C4",
    "D4",
    "E4",
    "F4",
    "G4"
  )
  
  # Function to generate music notation image
  generate_music_image <- function(note) {
    # Ensure the required library is loaded
    music <- Music() +
      Line(pitches = c(note), durations = c(4)) +
      Meter(4, 4, invisible = TRUE) +
      Clef("F")
    export(music, "www/score.png")
  }
  
  # Initialize the first random note and generate image
  observe({
    initial_note <- sample(notes, 1)
    generated_note(initial_note)
    generate_music_image(initial_note)
  })
  
  # Display the current image
  output$noteImage <- renderImage({
    list(src = "www/score.png", alt = "Musical Score")
  }, deleteFile = FALSE)
  
  # Submit guess and evaluate
  observeEvent(input$submit, {
    req(input$guess)
    req(input$numNotes)
    
    # Evaluate the guess
    correct_note <- substr(generated_note(), 1, 1) # Extract note name
    if (input$guess == correct_note) {
      correct_count(correct_count() + 1)
      output$result <- renderText("Correct!")
    } else {
      output$result <- renderText(paste("Incorrect! The correct note was", correct_note))
    }
    
    total_count(total_count() + 1)
    
    # Clear the radio button selection
    updateRadioButtons(session, "guess", selected = character(0))
    
    # Check if the game is over
    if (total_count() >= input$numNotes) {
      output$result <- renderText("Game Over!")
      shinyjs::disable("submit")
    } else {
      # Generate a new random note and image
      new_note <- sample(notes, 1)
      generated_note(new_note)
      generate_music_image(new_note)
      
      # Display the current image
      output$noteImage <- renderImage({
        list(src = "www/score.png", alt = "Musical Score")
      }, deleteFile = FALSE)
    }
    
    # Display the percentage of correct guesses
    output$percentage <- renderText({
      if (total_count() > 0) {
        percentage <- (correct_count() / total_count()) * 100
        paste("Percentage of correct guesses:",
              round(percentage, 2),
              "%")
      } else {
        "Percentage of correct guesses: 0%"
      }
    })
  })
  
  # Reset game when "Restart" is clicked
  observeEvent(input$restart, {
    correct_count(0)
    total_count(0)
    new_note <- sample(notes, 1)
    generated_note(new_note)
    generate_music_image(new_note)
    updateRadioButtons(session, "guess", selected = character(0))
    output$result <- renderText("")
    shinyjs::enable("submit")
    # Display the current image
    output$noteImage <- renderImage({
      list(src = "www/score.png", alt = "Musical Score")
    }, deleteFile = FALSE)
  })
}
