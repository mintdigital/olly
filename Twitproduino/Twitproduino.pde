//  ************************************************************************************************************************************************************************
//  Twiproduino.
//  Shaun McWhinnie + Tim Pryde, 25th Aug, 2011.
//  Triggers an arduino event whenever any status of the OAuth registered user is retweeted. 
//  Uses Twitter4J (http://twitter4j.org), Processing Arduino library (http://arduino.cc/playground/Interfacing/Processing) and Firmata (http://firmata.org/wiki/Main_Page).
//  Howzitgaun.com/TimPryde.com
//  ************************************************************************************************************************************************************************

// Imports
import twitter4j.*;
import cc.arduino.*;
import processing.serial.*;

// Globals
Twitter twitter;
AccessToken token;
long lastRT;
long lastRTcount;

// Arduino - add pin numbers as ints here with sensible names.
Arduino arduino;
int ledPin = 13;

// OAuth Details
String consumerKey = "Your consumer key";
String consumerSecret = "Your consumer secret";
String accessToken = "Access token";
String accessSecret = "Access secret";

//  ************************************************************************************************************************************************************************

void setup() {

  // Login with API. 
  twitter = new TwitterFactory().getInstance();
  twitter.setOAuthConsumer(consumerKey, consumerSecret);
  token = new AccessToken(accessToken, accessSecret);
  twitter.setOAuthAccessToken(token);
  
  // Set up Arduino
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw() {
  try {
    //Load timeline of retweets
    ArrayList timeline = (ArrayList) twitter.getRetweetsOfMe();

    // Get first retweet.
    Status tweet = (Status) timeline.get(0);
    println ("Tweet id = " + tweet.getId() + " -- " + tweet.getText() + " : " + tweet.getRetweetCount() );

    // Ascertain if the top Retweet has a new ID (i.e. it's new) or if it's the same, has the count changed (i.e. it's been retweeted again).
    if (lastRT != tweet.getId() || lastRTcount != tweet.getRetweetCount()) {
      println("New ReTweet: \"" + tweet.getText() + "\". Number of times retweeted: " + (tweet.getRetweetCount()+1) + ".");

      // Update last retweet details.
      lastRT = tweet.getId();      
      lastRTcount = tweet.getRetweetCount();

      //Arduino - standard LED blinky action.  

      arduino.digitalWrite(ledPin, Arduino.HIGH);
      delay(100);
      arduino.digitalWrite(ledPin, Arduino.LOW);
    }

    // Slow everything down so you don't exceed twitter's rate limits. Check every 10 secs.
    delay(10000);
  }  

  // Catch Exceptions.
  catch(TwitterException te) {
    println("error: " + te);
  }
};

