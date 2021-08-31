select * from RestaurantsVisited where preference = 1 and date(Last_Visit) < date('now', '-3 month');
