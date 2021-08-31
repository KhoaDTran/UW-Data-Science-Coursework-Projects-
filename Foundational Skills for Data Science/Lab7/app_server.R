#Create a temporary empty server
app_server <- function(input, output){
    
    #Updates the elements in midwest for better visulizations
    new_midwest <- midwest %>%
        
        #Rename all poverty groups
        rename(
            all_groups = percbelowpoverty,
            children = percchildbelowpovert,
            adults = percadultpoverty,
            elderly = percelderlypoverty
        ) %>%
    
        #Change 1 to TRUE and 0 to FALSE for metro vs. rural
        mutate(inmetro = (inmetro - 1 == 0)) 

    #Define a rural or metro population breakdown table to render in the UI
    output$population_table <- renderTable({
        
        #Create a table with counties having populations greater than  
        #or equal to user's slider input and filtering either metro or rural 
        #data depending on the user's input
        table <- new_midwest %>%
            filter(inmetro == input$metro) %>% #input either metro or rural
            filter(poptotal >= input$min_pop) %>% #select only counties from inputted population
            group_by(state) %>% #group by state
            
            #Find the population sum of each race grouped by state
            summarize(
                total_population = sum(poptotal),
                total_black = sum(popblack),
                total_white = sum(popwhite),
                total_asian = sum(popasian),
                total_amerindian = sum(popamerindian),
                total_allother = sum(popother)
            ) %>%
            
            #Calculate the percent of population for each race group
            mutate(percent_black = 100 * total_black / total_population) %>%
            mutate(percent_white = 100 * total_white / total_population) %>%
            mutate(percent_asian = 100 * total_asian / total_population) %>%
            mutate(percent_amerindian = 100 * total_amerindian / total_population) %>%
            mutate(percent_allother = 100 * total_allother / total_population) %>%
            select(state, percent_black, percent_white, percent_asian, percent_amerindian, percent_allother)
        
        #Rename the display columns
        colnames(table) <- c("State", "Percent Black", "Percent White", 
                             "Percent Asian", "Percent American Indian", 
                             "Percent Other")
        #Return table
        table
    })
    
    #Define a poverty vs education scatterplot to render in the UI
    output$poverty_education <- renderPlot(
        
        #Create and output the scatterplot with the chosen poverty group and state
        ggplot(data = filter(new_midwest, state == input$chosen_state)) +
            geom_point(mapping = aes(
                x = eval(parse(text = gsub(" ", "_", input$poverty_group))),
                y = percollege
            )) +
            #Add the title and axis labels
            labs(
                title = "Poverty vs. Education",
                x = paste("Percent of", str_to_title(input$poverty_group), "Impoverished"),
                y = "Percent Educated (Attended College)"
            )
    )
}
