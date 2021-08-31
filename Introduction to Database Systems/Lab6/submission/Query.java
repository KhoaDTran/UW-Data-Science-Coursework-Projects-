package edu.uw.cs;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.security.*;
import java.security.spec.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import javax.xml.bind.*;

/**
 * Runs queries against a back-end database
 */
public class Query {
  // DB Connection
  private Connection conn;

  // Password hashing parameter constants
  private static final int HASH_STRENGTH = 65536;
  private static final int KEY_LENGTH = 128;

  // Canned queries
  private static final String CHECK_FLIGHT_CAPACITY = "SELECT capacity FROM FLIGHTS WHERE fid = ?";
  private PreparedStatement checkFlightCapacityStatement;
  
  private static final String CREATE_LOGIN = "INSERT INTO USERS VALUES (?, ?, ?)";
  private PreparedStatement createLogin;
  
  private static final String LOGIN_CHECK = "SELECT COUNT(*) as cnt FROM USERS WHERE username = ? AND password = ?";
  private PreparedStatement loginCheck;
  
  private String user = "";
  
  private boolean check_loggedin = false;
  
  private ArrayList<ArrayList<Integer>> Itineraries;
  
  // Query assumes that the flights are in July 2015
  private static final String SEARCH_DIRECT = "SELECT TOP (?) fid, day_of_month, carrier_id, flight_num, origin_city, dest_city, actual_time, capacity, price "
                                            + "FROM FLIGHTS WHERE origin_city = ? and dest_city = ? and day_of_month = ? and month_id = 7 and "
                                            + "actual_time is NOT NULL "
                                            + "ORDER BY actual_time ASC, fid;";
  private PreparedStatement searchDirect;                                          
  
  // Query assumes that the flights are in July 2015
  private static final String SEARCH_TWO = "SELECT TOP (?) F.fid, F.day_of_month, F.carrier_id, F.flight_num, F.origin_city, F.dest_city, F.actual_time, F.capacity, F.price, "
                                         + "F1.fid, F1.day_of_month, F1.carrier_id, F1.flight_num, F1.origin_city, F1.dest_city, F1.actual_time, F1.capacity, F1.price"
                                         + "(F.actual_time + F1.actual_time) as total_time "
                                         + "FROM FLIGHTS as F, FLIGHTS as F1 WHERE F1.origin_city = F.dest_city and "
                                         + "F.origin_city = ? and F1.dest_city = ? and "
                                         + "F.day_of_month = ? and F1.day_of_month = F.day_of_month and F.actual_time is NOT NULL and "
                                         + "F1.actual_time is NOT NULL and F.month_id = 7 and F1.month_id = 7 "
                                         + "ORDER BY total_time ASC, f.fid, f1.fid;";
  private PreparedStatement searchTwo;
  
  private static final String CHECK_NUM_BOOKED = "SELECT COUNT(*) FROM RESERVATIONS WHERE fid1 = ?";
  private PreparedStatement checkNumBooked;
  
  private static final String INSERT_RESERVATION = "INSERT INTO RESERVATIONS VALUES (?, ?, ?, ?, ?, 0, ?, 0)";
  private PreparedStatement insertReservation;
  
  private static final String LIST_RESERVATION = "SELECT paid, reseravtion_id, fid1, fid2 "
                                               + "FROM RESERVATIONS WHERE username = ? ORDER BY reservation_id ASC, username";
  private PreparedStatement listReservation;
  
  private static final String FLIGHT_INFORMATION = "SELECT * FROM FLIGHTS WHERE fid = ?";
  private PreparedStatement flightInfo;
  
  private static final String CHECK_SAME_DAY = "SELECT COUNT(*) as cnt FROM RESERVATIONS WHERE username = ? and day_of_month = ?";
  private PreparedStatement checkSameDay;
  
  private static final String NUM_RESERVATION = "SELECT COUNT(*) as cnt FROM RESERVATIONS";
  private PreparedStatement numReservation;
  
  private static final String PAYBALANCE_UPDATE = "UPDATE USERS SET account_balance = ? WHERE username = ?";
  private PreparedStatement payBalance;
  
  private static final String RESERVATION_PAYUPDATE = "UPDATE RESERVATIONS SET paid = 1 WHERE reservation_id = ?";
  private PreparedStatement payReservationUpdate;
  
  private static final String CHECK_RESERVATIONID = "SELECT reservation_id FROM RESERVATIONS WHERE reservation_id = ? and username = ?";
  private PreparedStatement checkReservationID;
  
  private static final String PRICE_BALANCE = "SELECT U.balance, R.total_price from Users as U, RESERVATIONS as R WHERE U.username = ? AND R.reservation_id = ?";
  private PreparedStatement priceBalance;
  
  private static final String UPDATE_RESERVATION = "UPDATE RESERVATIONS SET canceled = 1 WHERE reservation_id = ? and username = ?";
  private PreparedStatement updateReservation;
  
  private static final String CHECK_PAID = "SELECT paid FROM RESERVATIONS WHERE reservation_id = ? and username = ?";
  private PreparedStatement checkPaid;
  
  private static final String UPDATE_CANCELBALANCE = "UPDATE USERS SET account_balance = account_balance + ? FROM USERS WHERE username = ?";
  private PreparedStatement updateCancelBalance;
  
  private static final String TOTAL_PRICE = "SELECT total_price FROM RESERVATIONS WHERE reservation_id = ? and username = ?";
  private PreparedStatement totalPrice;
  
  private static final String CLEAR_USERS  = "DELETE FROM USERS";
  private PreparedStatement clearUser;
  
  private static final String CLEAR_RESERVATIONS = "DELETE FROM RESERVATIONS";
  private PreparedStatement clearReservations;
  

  /**
   * Establishes a new application-to-database connection. Uses the
   * dbconn.properties configuration settings
   * 
   * @throws IOException
   * @throws SQLException
   */
  public void openConnection() throws IOException, SQLException {
    // Connect to the database with the provided connection configuration
    Properties configProps = new Properties();
    configProps.load(new FileInputStream("dbconn.properties"));
    String serverURL = configProps.getProperty("hw1.server_url");
    String dbName = configProps.getProperty("hw1.database_name");
    String adminName = configProps.getProperty("hw1.username");
    String password = configProps.getProperty("hw1.password");
    String connectionUrl = String.format("jdbc:sqlserver://%s:1433;databaseName=%s;user=%s;password=%s", serverURL,
        dbName, adminName, password);
    conn = DriverManager.getConnection(connectionUrl);

    // By default, automatically commit after each statement
    conn.setAutoCommit(true);

    // By default, set the transaction isolation level to serializable
    conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
  }

  /**
   * Closes the application-to-database connection
   */
  public void closeConnection() throws SQLException {
    conn.close();
  }

  /**
   * Clear the data in any custom tables created.
   * 
   * WARNING! Do not drop any tables and do not clear the flights table.
   */
  public void clearTables() {
    try {
      clearUser.clearParameters();
      clearUser.executeUpdate();
      clearReservations.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  /*
   * prepare all the SQL statements in this method.
   */
  public void prepareStatements() throws SQLException {
    checkFlightCapacityStatement = conn.prepareStatement(CHECK_FLIGHT_CAPACITY);
    createLogin = conn.prepareStatement(CREATE_LOGIN);
    loginCheck = conn.prepareStatement(LOGIN_CHECK);
    searchDirect = conn.prepareStatement(SEARCH_DIRECT);
    searchTwo = conn.prepareStatement(SEARCH_TWO);
    checkNumBooked = conn.prepareStatement(CHECK_NUM_BOOKED);
    insertReservation = conn.prepareStatement(INSERT_RESERVATION);
    listReservation = conn.prepareStatement(LIST_RESERVATION);
    flightInfo = conn.prepareStatement(FLIGHT_INFORMATION);
    checkSameDay = conn.prepareStatement(CHECK_SAME_DAY);
    numReservation = conn.prepareStatement(NUM_RESERVATION);
    payBalance = conn.prepareStatement(PAYBALANCE_UPDATE);
    payReservationUpdate = conn.prepareStatement(RESERVATION_PAYUPDATE);
    priceBalance = conn.prepareStatement(PRICE_BALANCE);
    checkReservationID = conn.prepareStatement(CHECK_RESERVATIONID);
    updateReservation = conn.prepareStatement(UPDATE_RESERVATION);
    updateCancelBalance = conn.prepareStatement(UPDATE_CANCELBALANCE);
    checkPaid = conn.prepareStatement(CHECK_PAID);
    totalPrice = conn.prepareStatement(TOTAL_PRICE);
    clearUser = conn.prepareStatement(CLEAR_USERS); 
    clearReservations = conn.prepareStatement(CLEAR_RESERVATIONS);
    Itineraries = new ArrayList<ArrayList<Integer>>();
  }

  /**
   * Takes a user's username and password and attempts to log the user in.
   *
   * @param username user's username
   * @param password user's password
   *
   * @return If someone has already logged in, then return "User already logged
   *         in\n" For all other errors, return "Login failed\n". Otherwise,
   *         return "Logged in as [username]\n".
   */
  public String transaction_login(String username, String password) {
     try {
        if(check_loggedin = true) {
           return "User already logged in\n";
        }	     
        loginCheck.clearParameters();
        loginCheck.setString(1, username);
        loginCheck.setString(2, password);
        ResultSet resultLogin = loginCheck.executeQuery();
        if (resultLogin.next()) {
           int count = resultLogin.getInt("cnt");
           if (count == 1) {
              user = username;
              check_loggedin = true;
              Itineraries.clear();
              resultLogin.close();
              return "Logged in as " + username + "\n";  
           } 
        } else {
           resultLogin.close();
           return "Login failed\n";
        }
        resultLogin.close();       
     }
     catch (Exception e) {
        return "Login failed\n";
     }
     return "Login failed\n";
  }

  /**
   * Implement the create user function.
   *
   * @param username   new user's username. User names are unique the system.
   * @param password   new user's password.
   * @param initAmount initial amount to deposit into the user's account, should
   *                   be >= 0 (failure otherwise).
   *
   * @return either "Created user {@code username}\n" or "Failed to create user\n"
   *         if failed.
   */
  public String transaction_createCustomer(String username, String password, int initAmount) {
     if (initAmount < 0) {
           return "Failed to create user\n";
     }
     try {
        createLogin.clearParameters();
        createLogin.setString(1, username);
        createLogin.setString(2, password);
        createLogin.setInt(3, initAmount);
        createLogin.executeUpdate();
        return "Created user" + username + "\n";
     }
     catch (Exception e) {
        return "Failed to create user\n";
     }   
  }

  /**
   * Implement the search function.
   *
   * Searches for flights from the given origin city to the given destination
   * city, on the given day of the month. If {@code directFlight} is true, it only
   * searches for direct flights, otherwise is searches for direct flights and
   * flights with two "hops." Only searches for up to the number of itineraries
   * given by {@code numberOfItineraries}.
   *
   * The results are sorted based on total flight time.
   *
   * @param originCity
   * @param destinationCity
   * @param directFlight        if true, then only search for direct flights,
   *                            otherwise include indirect flights as well
   * @param dayOfMonth
   * @param numberOfItineraries number of itineraries to return
   *
   * @return If no itineraries were found, return "No flights match your
   *         selection\n". If an error occurs, then return "Failed to search\n".
   *
   *         Otherwise, the sorted itineraries printed in the following format:
   *
   *         Itinerary [itinerary number]: [number of flights] flight(s), [total
   *         flight time] minutes\n [first flight in itinerary]\n ... [last flight
   *         in itinerary]\n
   *
   *         Each flight should be printed using the same format as in the
   *         {@code Flight} class. Itinerary numbers in each search should always
   *         start from 0 and increase by 1.
   *
   * @see Flight#toString()
   */
  public String transaction_search(String originCity, String destinationCity, boolean directFlight, int dayOfMonth,
      int numberOfItineraries) {    
     StringBuffer sb = new StringBuffer();
     Itineraries.clear();
     try {
        searchDirect.clearParameters();
        searchDirect.setInt(1, numberOfItineraries);
        searchDirect.setString(2, originCity);
        searchDirect.setString(3, destinationCity);
        searchDirect.setInt(4, dayOfMonth);
        ResultSet searchDirectResults = searchDirect.executeQuery();
        int flight_cnt = 0;
        while (searchDirectResults.next() && flight_cnt < numberOfItineraries) {
           flight_cnt++;
           sb.append("Itinerary " + flight_cnt + ": 1 flights(s), " + searchDirectResults.getInt("actual_time") + " minutes\n" +
                     "ID: " + searchDirectResults.getInt("fid") + " Day: " + searchDirectResults.getInt("day_of_month") +
                     " Carrier: " + searchDirectResults.getString("carrier_id") + " Number: " + searchDirectResults.getInt("flight_num") + 
                     " Origin: " + searchDirectResults.getString("origin_city") + " Dest: " + searchDirectResults.getString("dest_city") +
                     " Duration: " + searchDirectResults.getInt("actual_time") + " Capacity: " + searchDirectResults.getInt("capacity") +
                     " Price: " + searchDirectResults.getInt("price"));
           Itineraries.add(flight_cnt, new ArrayList<Integer>());
           Itineraries.get(flight_cnt).add(searchDirectResults.getInt("fid"));
           Itineraries.get(flight_cnt).add(0);
           Itineraries.get(flight_cnt).add(searchDirectResults.getInt("day_of_month"));
           Itineraries.get(flight_cnt).add(searchDirectResults.getInt("price"));        
        }
        searchDirectResults.close();
        if (!directFlight && flight_cnt < numberOfItineraries) {
           searchTwo.clearParameters();
           searchTwo.setInt(1, numberOfItineraries);
           searchTwo.setString(2, originCity);
           searchTwo.setString(3, destinationCity);
           searchTwo.setInt(4, dayOfMonth);
           ResultSet searchTwoResults = searchTwo.executeQuery();
           while (searchTwoResults.next() && flight_cnt < numberOfItineraries) {
              flight_cnt++;
              sb.append("Itinerary " + flight_cnt + ": 2 flights(s), " + searchTwoResults.getInt("total_time") + " minutes\n" +
                     "ID: " + searchTwoResults.getInt("F.fid") + " Day: " + searchTwoResults.getInt("F.day_of_month") +
                     " Carrier: " + searchTwoResults.getString("F.carrier_id") + " Number: " + searchTwoResults.getInt("F.flight_num") + 
                     " Origin: " + searchTwoResults.getString("F.origin_city") + " Dest: " + searchTwoResults.getString("F.dest_city") +
                     " Duration: " + searchTwoResults.getInt("F.actual_time") + " Capacity: " + searchTwoResults.getInt("F.capacity") +
                     " Price: " + searchTwoResults.getInt("F.price") + "\n" +
                     "ID: " + searchTwoResults.getInt("F1.fid") + " Day: " + searchTwoResults.getInt("F1.day_of_month") +
                     " Carrier: " + searchTwoResults.getString("F1.carrier_id") + " Number: " + searchTwoResults.getInt("F1.flight_num") + 
                     " Origin: " + searchTwoResults.getString("F1.origin_city") + " Dest: " + searchTwoResults.getString("F1.dest_city") +
                     " Duration: " + searchTwoResults.getInt("F1.actual_time") + " Capacity: " + searchTwoResults.getInt("F1.capacity") +
                     " Price: " + searchTwoResults.getInt("F1.price"));
              Itineraries.add(flight_cnt, new ArrayList<Integer>());
              Itineraries.get(flight_cnt).add(searchTwoResults.getInt("f.fid"));
              Itineraries.get(flight_cnt).add(searchTwoResults.getInt("f1.fid"));
              Itineraries.get(flight_cnt).add(searchTwoResults.getInt("day_of_month"));
              Itineraries.get(flight_cnt).add((searchTwoResults.getInt("f.price") + searchTwoResults.getInt("f1.price")));
           }
           searchTwoResults.close();        
        } 
     }
     catch (Exception e) {
        e.printStackTrace();
     } 
     return sb.toString();      
  } 

  /**
   * Implements the book itinerary function.
   *
   * @param itineraryId ID of the itinerary to book. This must be one that is
   *                    returned by search in the current session.
   *
   * @return If the user is not logged in, then return "Cannot book reservations,
   *         not logged in\n". If try to book an itinerary with invalid ID, then
   *         return "No such itinerary {@code itineraryId}\n". If the user already
   *         has a reservation on the same day as the one that they are trying to
   *         book now, then return "You cannot book two flights in the same
   *         day\n". For all other errors, return "Booking failed\n".
   *
   *         And if booking succeeded, return "Booked flight(s), reservation ID:
   *         [reservationId]\n" where reservationId is a unique number in the
   *         reservation system that starts from 1 and increments by 1 each time a
   *         successful reservation is made by any user in the system.
   */
  public String transaction_book(int itineraryId) {
    if (user == null) {
       return "Cannot book reservations, not logged in\n";
	 } else if (itineraryId < 0 || itineraryId >= Itineraries.size()) {
       return "No such itinerary " + itineraryId + "\n";
    }
    try {
       ArrayList<Integer> bookItinerary = Itineraries.get(itineraryId);
       checkSameDay.clearParameters();
       checkSameDay.setString(1, user);
       checkSameDay.setInt(2, bookItinerary.get(2));
       ResultSet sameDayResult = checkSameDay.executeQuery();
       sameDayResult.next();
       int count = sameDayResult.getInt("cnt");
       sameDayResult.close();
       if (count != 0) {
          return "You cannot book two flights in the same day\n";
       }
       checkNumBooked.clearParameters();
       checkNumBooked.setInt(1, bookItinerary.get(0));
       ResultSet firstFlight = checkNumBooked.executeQuery();
       if(firstFlight.next() && firstFlight.getInt("cnt") < checkFlightCapacity(bookItinerary.get(0))) {
          if(bookItinerary.get(1) == 0) {
             firstFlight.close();
             return addReservation(itineraryId);
          } else {
             checkNumBooked.clearParameters();
             checkNumBooked.setInt(1, bookItinerary.get(1));
             checkNumBooked.setInt(2, bookItinerary.get(1));
             ResultSet secondFlight = checkNumBooked.executeQuery();
             if (secondFlight.next() && secondFlight.getInt("cnt") < checkFlightCapacity(bookItinerary.get(1))) {
                secondFlight.close();
                return addReservation(itineraryId);
             }
          }
       }
    }
    catch (Exception e) {
       return "Booking failed\n";
    }    
    return "Booking failed\n";
  }

   private String addReservation(int itineraryId){
      try {    
          numReservation.clearParameters();
          ResultSet numberResult = numReservation.executeQuery();
          int newId = numberResult.getInt("cnt") + 1;
          numberResult.close();
          insertReservation.clearParameters();
          insertReservation.setInt(1, newId);
          insertReservation.setString(2, user);
          insertReservation.setInt(4, Itineraries.get(itineraryId).get(0));
          insertReservation.setInt(5, Itineraries.get(itineraryId).get(1));
          insertReservation.setInt(3, Itineraries.get(itineraryId).get(2));
          insertReservation.setInt(6, Itineraries.get(itineraryId).get(3));
          insertReservation.executeUpdate();
          return "Booked flight(s), reservation ID: " + newId + "\n";
      } 
      catch (Exception e) {
         return "Booking failed\n";
      }    
  }
  
  /**
   * Implements the pay function.
   *
   * @param reservationId the reservation to pay for.
   *
   * @return If no user has logged in, then return "Cannot pay, not logged in\n"
   *         If the reservation is not found / not under the logged in user's
   *         name, then return "Cannot find unpaid reservation [reservationId]
   *         under user: [username]\n" If the user does not have enough money in
   *         their account, then return "User has only [balance] in account but
   *         itinerary costs [cost]\n" For all other errors, return "Failed to pay
   *         for reservation [reservationId]\n"
   *
   *         If successful, return "Paid reservation: [reservationId] remaining
   *         balance: [balance]\n" where [balance] is the remaining balance in the
   *         user's account.
   */
  public String transaction_pay(int reservationId) {
    if (user == null) {
       return "Cannot pay, not logged in\n";
    }
    try {
       checkReservationID.clearParameters();
       checkReservationID.setInt(1, reservationId);
       checkReservationID.setString(2, user);
       ResultSet resultReservation = checkReservationID.executeQuery();
       if (resultReservation.next()) {
          resultReservation.close();
          priceBalance.clearParameters();
          priceBalance.setString(1, user);
          priceBalance.setInt(2, reservationId);
          ResultSet priceBalanceResult = priceBalance.executeQuery();
          if (priceBalanceResult.next() && priceBalanceResult.getInt("U.balance") >= priceBalanceResult.getInt("R.total_price")) {
             payBalance.clearParameters();
             payBalance.setInt(1, priceBalanceResult.getInt("U.balance") - priceBalanceResult.getInt("R.total_price"));
             int finalBalance = priceBalanceResult.getInt("U.balance") - priceBalanceResult.getInt("R.total_price");
             payBalance.setString(2, user);
             payBalance.executeUpdate();
             payReservationUpdate.clearParameters();
             payReservationUpdate.setInt(1, reservationId);
             payReservationUpdate.executeUpdate();
             return "Paid Reservation: " + reservationId + " remaining balance " + finalBalance + "\n";
          } else {
             return "User has only " + priceBalanceResult.getInt("U.balance") + " but itinerary cost " + priceBalanceResult.getInt("R.total_price") + "\n";
          }
       } else {
          return "Cannot find unpaid reservation " + reservationId + " under user: " + user + "\n";
       }
    }
    catch (Exception e) {
       return "Failed to pay for reservation " + reservationId + "\n";
    }
  }

  /**
   * Implements the reservations function.
   *
   * @return If no user has logged in, then return "Cannot view reservations, not
   *         logged in\n" If the user has no reservations, then return "No
   *         reservations found\n" For all other errors, return "Failed to
   *         retrieve reservations\n"
   *
   *         Otherwise return the reservations in the following format:
   *
   *         Reservation [reservation ID] paid: [true or false]:\n" [flight 1
   *         under the reservation] [flight 2 under the reservation] Reservation
   *         [reservation ID] paid: [true or false]:\n" [flight 1 under the
   *         reservation] [flight 2 under the reservation] ...
   *
   *         Each flight should be printed using the same format as in the
   *         {@code Flight} class.
   *
   * @see Flight#toString()
   */
  public String transaction_reservations() {
    if (user == null) {
       return "Cannot view reservations, not logged in\n";
    }
    try {
       listReservation.clearParameters();
       listReservation.setString(1, user);
       ResultSet listResult = listReservation.executeQuery();
       StringBuffer sb = new StringBuffer();
       if (listResult.next()) {
          int fid_1 = listResult.getInt("fid1");
          int fid_2 = listResult.getInt("fid2");
          int paid = listResult.getInt("paid");
          int reservationID = listResult.getInt("reservation_id");
          if (paid == 1) {
             sb.append("Reservation " + reservationID + " paid: true\n");
          } else {
             sb.append("Reservation " + reservationID + " paid: false\n");
          }
          if (fid_2 != 0) {
             sb.append(flightString(fid_1));
             sb.append(flightString(fid_2) + "\n");
          } else {
             sb.append(flightString(fid_1) + "\n");
          }
          while (listResult.next()) {
             paid = listResult.getInt("paid");
             fid_1 = listResult.getInt("fid1");
             fid_2 = listResult.getInt("fid2");
             reservationID = listResult.getInt("reservation_id");
             if (paid == 1) {
                sb.append("Reservation " + reservationID + " paid: true\n");
             } else {
                sb.append("Reservation " + reservationID + " paid: false\n");
             }
             if (fid_2 == 0) {
                sb.append(flightString(fid_1) + "\n");
             } else {
                sb.append(flightString(fid_1));
                sb.append(flightString(fid_2) + "\n");
             }
          }
          listResult.close();
          return sb.toString();
       } else {
          return "No reservations found\n";
       }
    }
    catch (Exception e) {   
       return "Failed to retrieve reservations\n";
    }
  }
  
  private String flightString(int fid) {
     try {
        flightInfo.clearParameters();
        flightInfo.setInt(1, fid);
        ResultSet flightOne = flightInfo.executeQuery();
        flightOne.next();
        int dayResult = flightOne.getInt("day_of_month");
        String carrierResult = flightOne.getString("carrier_id");
        int numFlightResult = flightOne.getInt("flight_num");
        String originCityResult = flightOne.getString("origin_city");
        String destCityResult = flightOne.getString("dest_city");
        int timeResult = flightOne.getInt("actual_time");
        int capacityResult = flightOne.getInt("capacity");
        int priceResult = flightOne.getInt("price");
        int fidResult = flightOne.getInt("fid");
        flightOne.close();
        return "ID: " + fidResult + " Day: " + dayResult + " Carrier: " + carrierResult + " Number: " +
           numFlightResult + " Origin: " + originCityResult + " Dest: " + destCityResult + " Duration: " +
           timeResult + " Capacity: " + capacityResult + " Price: " + priceResult + "\n";
     }
     catch (Exception e) {
        return "Failed to retrieve reservations\n";
     }
  } 
  
  
  /**
   * Implements the cancel operation.
   *
   * @param reservationId the reservation ID to cancel
   *
   * @return If no user has logged in, then return "Cannot cancel reservations,
   *         not logged in\n" For all other errors, return "Failed to cancel
   *         reservation [reservationId]\n"
   *
   *         If successful, return "Canceled reservation [reservationId]\n"
   *
   *         Even though a reservation has been canceled, its ID should not be
   *         reused by the system.
   */
  public String transaction_cancel(int reservationId) {
     if (user == null) {
        return "Cannot cancel reservations, not logged in\n";
     }
     try {
        checkReservationID.clearParameters();
        checkReservationID.setInt(1,reservationId);
        checkReservationID.setString(2,user);      
        ResultSet checkResult = checkReservationID.executeQuery();
        if (checkResult.next()) {
           checkPaid.clearParameters();
           checkPaid.setInt(1, reservationId);
           checkPaid.setString(2, user);
           ResultSet paidCheck = checkPaid.executeQuery();
           if (paidCheck.getInt("paid") == 1) {
              totalPrice.clearParameters();
              totalPrice.setInt(1, reservationId);
              totalPrice.setString(2, user);
              ResultSet priceTotal = totalPrice.executeQuery();
              priceTotal.next();
              int price = priceTotal.getInt("total_price");
              updateCancelBalance.clearParameters();
              updateCancelBalance.setInt(1, price);
              updateCancelBalance.setString(2, user);
              updateCancelBalance.executeUpdate();
           }
           updateReservation.clearParameters();
           updateReservation.setInt(1, reservationId);
           updateReservation.setString(2, user);
           updateReservation.executeUpdate();
           return "Canceled reservation" + reservationId + "\n";
        }       
     }
     catch (Exception e) {
        return "Failed to cancel reservation " + reservationId + "\n";
     }
  return "Failed to cancel reservation " + reservationId + "\n";
  }

  /**
   * Example utility function that uses prepared statements
   */
  private int checkFlightCapacity(int fid) throws SQLException {
    checkFlightCapacityStatement.clearParameters();
    checkFlightCapacityStatement.setInt(1, fid);
    ResultSet results = checkFlightCapacityStatement.executeQuery();
    results.next();
    int capacity = results.getInt("capacity");
    results.close();

    return capacity;
  }

  /**
   * A class to store flight information.
   */
  class Flight {
    public int fid;
    public int dayOfMonth;
    public String carrierId;
    public String flightNum;
    public String originCity;
    public String destCity;
    public int time;
    public int capacity;
    public int price;

    @Override
    public String toString() {
      return "ID: " + fid + " Day: " + dayOfMonth + " Carrier: " + carrierId + " Number: " + flightNum + " Origin: "
          + originCity + " Dest: " + destCity + " Duration: " + time + " Capacity: " + capacity + " Price: " + price;
    }
  }
}
