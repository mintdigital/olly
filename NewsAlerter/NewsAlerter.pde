//  ************************************************************************************************************************************************************************
// Triggers an arduino event when we get a new news story matching a keyword
//  ************************************************************************************************************************************************************************

// Imports
import cc.arduino.*;
import processing.serial.*;

// Globals
String url;
String lastItem;
String interestedIn;

// Arduino - add pin numbers as ints here with sensible names.
Arduino arduino;
int ledPin = 13;
// int motorPin = 7 etc.


//  ************************************************************************************************************************************************************************

void setup() {

  // Set up rss feed (this is the public twitter timeline)
  url = "http://feeds.bbci.co.uk/news/rss.xml";
  
  // Set up what news we're interested in
  interestedIn = ".*Cameron.*";
  
  // Set up Arduino
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw() {
  
    XMLElement rss = new XMLElement(this, url); 
    
    XMLElement[] titleXMLElements = rss.getChildren("channel/item/title");  
    String recentItem = titleXMLElements[0].getContent();
    if(lastItem == null){
      lastItem = recentItem;
    }

    //Do we have a new item and does it match our pattern?
    if (!lastItem.equals(recentItem) && lastItem.matches(interestedIn)) {
      println("New item: " + recentItem);

      lastItem = recentItem;
      //Arduino - standard LED blinky action.  

      arduino.digitalWrite(ledPin, Arduino.HIGH);
      delay(100);
      arduino.digitalWrite(ledPin, Arduino.LOW);
    }

    // Slow everything down so you don't exceed twitter's rate limits. Check every 10 secs.
    delay(10000);
};
