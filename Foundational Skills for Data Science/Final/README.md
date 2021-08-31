# Final Project Brainstorm
#### Contributors: Kevin Nguyen, Khoa Tran, Vincent Ma, Jared Pancho

## Domain of Interest: Predicting the NBA

### Why are we interest in this field/domain?

  - NBA viewership just hit an four-year high in the 2017-2018 season up 8% from previous seasons. As the NBA begins to grow their reach internationally, the field of analytics only becomes more lucrative alongside sports betting. We are interested in how well stats of previous seasons are able to help predict playoff outcomes. How much do those supposedly "professional analysts" actually know?

### Other examples of data driven projects we found related to this domain:

  - [Using Data Science to Predict the Next NBA MVP](https://towardsdatascience.com/using-data-science-to-predict-the-next-nba-mvp-30526e0443da) project involves data scientists taking data about season standings, advanced total, and pregame individual player stats, and award data from 1976 to 2018 to predict James Harden as the league MVP for 2019. Although the prediction was wrong, the actual MVP (Giannis Antetokounmpo) only trailed by .6%.
  - [Data Analytics, The 3 Point Shot and Data Visualization Tools](https://towardsdatascience.com/nba-data-analytics-changing-the-game-a9ad59d1f116) research is based on NBA basketball is going through a dramatic change as teams are adapting to increase the volume of their 3 point shots and as these shots become more popular, it is important for teams to be able to view and analyze why or why not these shots are successful. Notable analysis examine court position, shot frequency and player position to output noteworthy coaching points.
  - [Analytics help separate the ALl-Stars from the Potential Busts](https://www.espn.com/nba/story/_/id/19681478/most-likely-all-stars-starters-role-players-top-2017-nba-draft) project emphasizes drafting the correct players as it is just as important as having a star veteran player, as the future of your team relies on the rookies. This project analyzes statistical plus-minus in order to rank draft picks as role-players, starts, and all-stars.

### Data-driven questions we have:
  - How do certain offensive stats within teams correlate with making it to the playoffs in 2019? This can be answered through aggregating various stats of playoff teams during the regular season and comparing those to other play-off team stats to see which stat/s are the best indicator of making it to the playoffs.
  - What is the importance of defense and taking care of the ball on wins in 2019? This can be answered by aggregating defensive stats (DRB, blocks, turnovers, and steals) of each team and comparing it to how many wins they have.
  - How do changes within the teams correlate with changes in their win percentage? This can be answered by evaluating the top three teams with the biggest win differential and then evaluating what stats have improved the most.

## Finding data

### Data Source 1
- Source: [(2016-2017 team stats)](https://www.basketball-reference.com/leagues/NBA_2017_per_game.html)
- Sportradar, the official stats partner of the NBA recorded this data and Basketball-reference uses the provider and their recorded statistics to display and allow for access towards statistics of every team in the NBA during the 2016-2017 season.
- Observations:
- Features:
- Questions that can be answered:
  - How do changes within the teams correlate with changes in their win percentage? 

### Data Source 3
- Source: [2018-2019 Team Stats](https://www.basketball-reference.com/leagues/NBA_2019_per_game.html)
- Sportsradar compiles the statistics of each team per game, and averages them to produce the numbers we see in this dataset.
- Observations
- Features
- Questions that can be answered:
  - How do certain offensive stats within teams correlate with making it to the playoffs in 2019? This can be answered through aggregating various stats of playoff teams and compare those to other teams stats that to see which stat/s are the best indicator of making it the playoffs through.
  - How do changes within the teams correlate with changes in their win percentage? This can be answered by evaluating the top three teams with the biggest win differential and then evaluating what stats have improved the most.
  - What is the importance of defense and taking care of the ball on wins in 2019?


### Data Source 4
- Source: [2019 play-off team stats](https://www.basketball-reference.com/playoffs/NBA_2019.html)
- Like the previous datasets, Sportsradar recorded the data for Basketball Reference to display. The data team data for all teams that played in the play-offs for the 2019 season.
- Observations: 530 rows
- Features: 30 columns
- Questions that can be answered:
	- How do certain offensive stats within teams correlate with making it to the playoffs in 2019?
