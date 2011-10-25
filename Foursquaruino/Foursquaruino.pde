//  ************************************************************************************************************************************************************************
//  Twiproduino.
//  Shaun McWhinnie + Tim Pryde, 25th Aug, 2011.
//  Triggers an arduino event whenever any status of the OAuth registered user is retweeted. 
//  Uses Twitter4J (http://twitter4j.org), Processing Arduino library (http://arduino.cc/playground/Interfacing/Processing) and Firmata (http://firmata.org/wiki/Main_Page).
//  Howzitgaun.com/TimPryde.com
//  ************************************************************************************************************************************************************************

// Imports
import cc.arduino.*;
import processing.serial.*;
import fi.foyt.foursquare.api.*;

// Globals
FoursquareApi foursquareApi;
long lastRT;
long lastRTcount;

// Arduino - add pin numbers as ints here with sensible names.
Arduino arduino;
int ledPin = 13;
Long hereCount = 0L;
long epoch = 0;
// int motorPin = 7 etc.

// OAuth Details

String consumerKey = "Your consumer key";
String consumerSecret = "Your consumer secret";
String accessToken = "Access token";
String accessSecret = "Access secret";

//  ************************************************************************************************************************************************************************

void setup() {

    try {
      // finally we need to authenticate that authorization code 
      foursquareApi = new FoursquareApi(consumerKey, consumerSecret, "http://localhost/app");
      foursquareApi.setoAuthToken(accessSecret);
      
      Result<CheckinGroup> result = foursquareApi.venuesHereNow("4dc7b6991f6ef43b8a4b534f", null, null, null);
      hereCount = result.getResult().getCount();
      
      System.out.println("There are currently " + result.getResult().getCount() + " people checked into Mint Digital:");
      for (Checkin c : result.getResult().getItems()) {
        System.out.println(c.getUser().getFirstName() + " " + c.getUser().getLastName());
      }
      
      epoch = System.currentTimeMillis()/1000;
      
    } catch (FoursquareApiException e) {
      println("hello: " + e);
      //println(e.printStackTrace());
     // TODO: Error handling
    }

  // Set up Arduino
  //Arduino.list(); //Uncomment to get list of serial devices attached, update [x]. Remember to setup arduino pins as inputor output here.
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw() {
  try {
    

    Result<CheckinGroup> result = foursquareApi.venuesHereNow("4dc7b6991f6ef43b8a4b534f", null, null, epoch);
    
    if (result.getMeta().getCode() == 200) {

      System.out.println("There are currently " + hereCount + " people checked into Mint Digital.");
      for (Checkin c : result.getResult().getItems()) {
        System.out.println(c.getUser().getFirstName() + " " + c.getUser().getLastName());
      }
      
      if (hereCount != result.getResult().getCount()) {
        
        println("The number of checkins has changed! Old checkin count: " + hereCount + ". New checkin count: " + result.getResult().getCount() + ".");
  
        System.out.println(result.getResult().getCount());
        hereCount = result.getResult().getCount();
        
        arduino.digitalWrite(ledPin, Arduino.HIGH);
        delay(10000);
        arduino.digitalWrite(ledPin, Arduino.LOW);
      }
    } else {
      
      // TODO: Proper error handling
      System.out.println("Error occured: ");
      System.out.println("  code: " + result.getMeta().getCode());
      System.out.println("  type: " + result.getMeta().getErrorType());
      System.out.println("  detail: " + result.getMeta().getErrorDetail()); 
    }
    
    // Slow everything down so you don't exceed twitter's rate limits. Check every 10 secs.
    delay(5000);
    epoch = System.currentTimeMillis()/1000;

    
    // Catch Exceptions.
    } catch(FoursquareApiException fe) {
      println("error: " + fe);
    }
};

