//  ************************************************************************************************************************************************************************
// Make a smell every time somone follows Snoop on Instagram
//  ************************************************************************************************************************************************************************

// IMPORTS
import org.json.*;
import cc.arduino.*;
import processing.serial.*;

// GLOBAL VARS
String baseUrl = "https://api.instagram.com/v1/users/1574083/?client_id=";
String clientID = "0eb4568c2a4545f386fe55484abbdeb8";
int newFollowerCount;
int recentFollowerCount;

// Arduino - add pin numbers as ints here with sensible names.
Arduino arduino;
int ledPin = 13;
// int motorPin = 7 etc.

void setup(){
  recentFollowerCount = getFollowerCount();
  newFollowerCount = recentFollowerCount;
};

void draw(){
  
  newFollowerCount = getFollowerCount();
  
  if (newFollowerCount == recentFollowerCount) {
    println ("Follower Count NOT Canged");
    delay(1000);
  } else {
    println ("Follower Count Changed");
    println ("Follower Count now " + newFollowerCount);
    recentFollowerCount = newFollowerCount;
    arduino.digitalWrite(ledPin, Arduino.HIGH);
    delay(100);
    arduino.digitalWrite(ledPin, Arduino.LOW);
    delay(1000);
  }
};

int getFollowerCount(){
  String request = baseUrl + clientID;
  String result = join( loadStrings( request ), "");
  int followers = 0;
  
  try {
    JSONObject instagramData = new JSONObject(join(loadStrings(request), ""));
    JSONObject data = instagramData.getJSONObject("data");
    JSONObject counts = data.getJSONObject("counts");
    followers = counts.getInt("followed_by");
  } 
  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
    return(0);
  };
  return (followers);
};
