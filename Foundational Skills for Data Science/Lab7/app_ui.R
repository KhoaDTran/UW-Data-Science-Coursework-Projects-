first_page <- tabPanel(
    "The Population Diversity of States", #tab title
    titlePanel("The Population Diversity of States in Rurual vs Metro Areas"), #page title 
    #Output widgets
    sidebarLayout(
        sidebarPanel(
            #User selection of rural or metro areas
            checkboxInput(
                inputId = "metro",
                label = "Metro(checked), Rural(unchecked)",
                value = FALSE
            ),
            #User selects the minimum population for data viewing
            sliderInput(
                inputId = "min_pop",
                label = h3("The Minimum Population"),
                min = min(midwest$poptotal),
                max = max(midwest$poptotal),
                value = min(midwest$poptotal)
            )
        ),
        
        #Output the table
        mainPanel(
            tableOutput("population_table")
        )
    )
)

second_page <- tabPanel(
    "Poverty vs. Educated", #tab title
    titlePanel("Attended College Compared to Percent Improverished"), #page title
    
    #Output widgets
    sidebarLayout(
        sidebarPanel(
            #User select the state
            selectInput(
                inputId = "chosen_state",
                label = h3("Select a State"),
                choices = as.list(midwest$state),
                selected = 1
            ),
            #User select the poverty age group to view
            radioButtons(
                inputId = "poverty_group",
                label = h3("Choose a Poverty Age Group"),
                choices = c("all groups", "children", "adults", "elderly")
            )
        ),
        
        #Output the poverty vs. educated scatterplot
        mainPanel(
            plotOutput(outputId = "poverty_education")
        )
    )
)

app_ui <- navbarPage(
    "Summary of the Midwest", #Title of App
    first_page, #The Population Diversity of States
    second_page #Poverty vs. Educated
)
