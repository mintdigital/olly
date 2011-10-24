//  ************************************************************************************************************************************************************************
// Triggers an arduino event when we get a new rss item
//  ************************************************************************************************************************************************************************

// Imports
import cc.arduino.*;
import processing.serial.*;

// Globals
String url;
String lastItem;

// Arduino - add pin numbers as ints here with sensible names.
Arduino arduino;
int ledPin = 13;
// int motorPin = 7 etc.


//  ************************************************************************************************************************************************************************

void setup() {

  // Set up rss feed (Example below is for a search.)
  url = "http://search.twitter.com/search.atom?q=mintdigital";
  
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

    if (!lastItem.equals(recentItem)) {
      println("New item: " + recentItem);

      lastItem = recentItem;
      //Arduino - standard LED blinky action.  

      arduino.digitalWrite(ledPin, Arduino.HIGH);
      delay(100);
      arduino.digitalWrite(ledPin, Arduino.LOW);
    }

    //Check every 10 secs.
    delay(10000);
};
