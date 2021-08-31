#Load 'dplyr' & 'plotly' & 'ggplot2' & 'leaflet' packages
library(dplyr)
library(plotly)
library(ggplot2)
library(leaflet)

#Load dataset into a dataframe, with not reading strings as factors
shootings2018_data <- read.csv("data/shootings-2018.csv", stringsAsFactors = FALSE)



#Summary Information -----------------------------------------------------


#Getting original data source
shootings_source <- "http://www.shootingtracker.com"
#Analyze how many shootings occurred 
#by defining shootings as number of shooting incidents
total_num_shootings <- nrow(shootings2018_data)

#Analyze how many lives were lost
#by defining lives lost as number of people killed
total_lives_lost <- shootings2018_data %>%
  select(num_killed) %>%
  #Deal with potential NA values
  sum(na.rm = TRUE)

#Analyze which city was impacted most by mass shootings
#by defining impacted as city with most killed and most injured
city_most_impacted <- shootings2018_data %>%
  #Checking for multiple states with the same city don't count for
  #double by specifing the state of the city
  mutate(location = paste(city, ", ", state, sep = "")) %>%
  #Calculate the number of people impacted
  mutate(impacted_num = num_killed + num_injured) %>%
  group_by(location) %>%
  summarize(
    #Deal with potential NA values
    total_impacted = sum(impacted_num, na.rm = TRUE)
  ) %>%
  #Find the most impacted location and pull the location
  filter(total_impacted == max(total_impacted)) %>%
  pull(location)

#First insight: month with the most shootings occurred
#by defining most shootings as total number of incidents
most_shootings_month <- shootings2018_data %>%
  #Get month name
  mutate(month = gsub(" ", "", substr(date, 1, nchar(date) - 8))) %>%
  count(month) %>%
  #Pull month with most shootings
  filter(n == max(n)) %>%
  pull(month)

#Second insight: State that wass most impacted by mass shootings
#by defining most impacted as state with most killed and most injured
state_most_impacted <- shootings2018_data %>%
  #Find number of people impacted
  mutate(impacted_num = num_killed + num_injured) %>%
  group_by(state) %>%
  summarize(
    #Deal with potential NA values
    total_impacted = sum(impacted_num, na.rm = TRUE)
  ) %>%
  #Find the most impacted state and pull the state
  filter(total_impacted == max(total_impacted)) %>%
  pull(state)





#Summary Table --------------------------------------------------------


#This table summarizes the number of people impacted every month

#Add a column for the total number of people impacted per incident and a column
#indicating the month of the incident. After, group by month the number of people impacted,
#and sort it in descending order of the number of people impacted
summarize_shootings_data <- shootings2018_data %>%
  #Get total number of people impacted
  mutate(impacted_num = num_killed + num_injured) %>%
  #Get month name
  mutate(Month = gsub(" ", "", substr(date, 1, nchar(date) - 8))) %>%
  group_by(Month) %>%
  summarize(
    total_impacted = sum(impacted_num)
  ) %>%
  #Sort in descending order of total number of people impacted
  arrange(-total_impacted)



#Description of an Indcident -------------------------------------------


#The incident will be focused on the shooting occued in Seattle
incident <- shootings2018_data %>%
  filter(city == "Seattle (Skyway)")

#Get the date of the indcident
date_of_incident <- incident %>%
  pull(date)

#Get the location of the incident
#by defining the location as 'city, state'
location_of_incident <- paste(pull(incident, city), ", ",
                           pull(incident, state), sep = "")

#Get the geoLocation of the incident
#by defining geolocation as latitude and longitude
geolocation_of_incident <- paste("lat = ", pull(incident, lat),
                              ", long = ", pull(incident, long), sep = "")

#Get the number of people injured
num_injured_of_incident <- incident %>%
  pull(num_injured)

#Get the number of people killed
num_killed_of_incident <- incident %>%
  pull(num_killed)

#External resoure about the incident
incident_extresource <- paste("https://www.kiro7.com/news/local/2-dead-others-injured-",
                           "after-motorcycle-club-shooting-in-skyway/740813121",
                           sep = "")



#Interactive Map ------------------------------------------------------


#Create an interactive map from the shooting data, where the size of each data
#is related to the number of people impacted by the shooting as in the number
#of people killed and the number of people injured. For each data point, it
#has the exact latitude and longitude of the city, and the hovering data point
#displays the city and state, with the number of people killed and the people injured
map_of_shootings <- shootings2018_data %>%
  #Gets the desired radius
  mutate(radius = 5 * ( (num_killed + num_injured) /
                          max(num_killed + num_injured))) %>%
  #Creates the popup data
  mutate(popup_data = paste("Location: ", city, ", ", state, "</br>Killed: ",
                            num_killed, "</br>Injured:", num_injured,
                            sep = "")) %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(
    lat = ~lat, #Latitude for each data point
    lng = ~long, #Longitude for each data point
    popup = ~popup_data, #Add Popup data for each data point
    stroke = TRUE, #Add borders to each circle
    radius = ~radius, #Add the calculated radius
    fillOpacity = 0.5 #Circles' opacity
  ) %>%
  setMaxBounds(-130, 24, -60, 50) #Keeping view of the map to fit the US

#Fifteen Biggest Shootings --------------------------------------------------

#Create a bar chart of the 15 biggest shootings by most number of impacted people
fifteen_biggest_shootings <- shootings2018_data %>%
  #Create a impacted_num column which total number injured and killed
  mutate(impacted_num = num_killed + num_injured) %>%
  #Filter the top 15
  top_n(15, impacted_num) %>% 
  #Sort in ascending order
  arrange(impacted_num) %>% 
  #Create a city_and_state column
  mutate(city_state = paste(city, ", ", state, sep = "")) %>%
  #Set row order
  mutate(location = factor(city_state, city_state))

#Create a horizontal bar chart with
#location as vertical(y) and impacted_num as horizontal(x)
#Creates a horizontal bar chart
ggplot(fifteen_biggest_shootings) +
  geom_col(mapping = aes(x = location, y = impacted_num)) +
  labs( 
    #Add labels to x and y axis
    #Plot title
    title = "Fifteen Biggest Mass Shootings in 2018", 
    #Vertical X axis title
    x = "Location",
    #Horizontal Y axis title
    y = "Number of People Impacted" 
  ) +
  coord_flip() #Make horizontal bars with cities on the side for better visibility
