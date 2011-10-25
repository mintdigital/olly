//  ************************************************************************************************************************************************************************
// Simple test program allowing you to release smells at the press of a button
//  ************************************************************************************************************************************************************************

import cc.arduino.*;
import processing.serial.*;

Arduino arduino;
int ledPin = 13;

color buttonColor, highlightColor, backgroundColor;
int rectX, rectY, rectWidth, rectHeight;
PFont f;

void setup() {  
  // Set up Arduino
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);

  size(200, 200);
  buttonColor = color(255,0,0);
  highlightColor = color(155,0,0);
  rectX = 50;
  rectY = 75;
  rectWidth = 100;
  rectHeight = 50;
  f = loadFont("SansSerif-24.vlw");
  textFont(f);
}

void draw(){
  background(color(255));
  noStroke();
  if(overButton(rectX, rectY, rectWidth, rectHeight)){
    fill(highlightColor);
  }else{
    fill(buttonColor);
  }
  rect(rectX, rectY, rectWidth, rectHeight);
  fill(color(255));
  text("Test", 75, 110);
}

void mousePressed()
{
  if(overButton(rectX, rectY, rectWidth, rectHeight)) {
    arduino.digitalWrite(ledPin, Arduino.HIGH);
    delay(100);
    arduino.digitalWrite(ledPin, Arduino.LOW);
    println("Button pressed");
  }
}

boolean overButton(int x, int y, int width, int height) 
{
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
