server <- shinyServer(function(input, output, session) {
  observeEvent(input$submitdata, {
    
    updateTabsetPanel(session,"change",selected="results")
    
  })
  
  
 
  # added "session" because updateSelectInput requires it
  
  
  data <- reactive({ 
    req(input$file1) ## ?req #  require that the input is available
    
    inFile <- input$file1 
    
    df <- readLines(inFile$datapath)
    
    return(df)
  })
  
  output$contents <- renderTable({
    data()
  })
  
  output$MyPlot <- renderPlot({
    
    #if(is.null(df)){return (NULL)}
    #data()
    
    #Read from chat history file
    texts = data();
    
    #texts <- readLines("samplechat.txt")
    text=texts;
    
    library("tm")
    library("SnowballC")
    library("wordcloud")
    library("RColorBrewer")
    library("syuzhet") 
    library("lubridate") 
    library("ggplot2")
    library("dplyr")
    library("mailR")
    library("sendmailR")
    library("shinyAce")
    #fetch sentiment words from chats
    mySentiment <- get_nrc_sentiment(texts)
    head(mySentiment)
    text <- cbind(texts, mySentiment)
    
    #count the sentiment words by category
    sentimentTotals <- data.frame(colSums(text[,c(2:11)]))
    names(sentimentTotals) <- "count"
    sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
    rownames(sentimentTotals) <- NULL
    
    
    #calculate total sentiment
    syuzhet_vector <- get_sentiment(texts, method="syuzhet")
    sumsent<-sum(syuzhet_vector)
    value <- reactiveVal(0)  
    observeEvent(input$submitdata, {
      newValue <- sumsent     # newValue <- rv$value - 1
      value(newValue)             # rv$value <- newValue
    })
    
    #total sentiment score of all texts
    x <- ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
      geom_bar(aes(fill = sentiment), stat = "identity") +
      theme(legend.position = "none") +
      xlab("Sentiments") + ylab("Grading points") + ggtitle("Sentiment Analysis")
    
    plot(x)
    output$value <- renderText({
          value()           # rv$value
    })
    
   
  
    output$pacifier_image <- renderImage({ 
     
      if(value()>0){
      return(list(
        src = "www/child abuse.jpg",
        filetype = "png/jpeg",
        height=350,
        width=350,
        alt = "T"
      ))}
      else  {
        return(list(
          src = "www/child abuse.jpg",
          filetype = "png/jpeg",
          alt = "T"
        ))}
      
    }, deleteFile = FALSE)
    
    
    
    
    
    })
    
  })
  