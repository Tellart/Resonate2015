var started=false;

var myButton=false;
var circleSize=20; 

var myDevice = 1;

var counter = 0;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   frameRate(30); 
}

function draw() {
  background(255);
  textSize(32);
  fill(0);
  noStroke();

if(connector.getInstance().status=="RUNNING" && !started)
  {
    console.log("registering orientation");
    connector.getInstance().registerButton(myDevice);
    connector.getInstance().registerOrientation(myDevice);
    connector.getInstance().registerTemperature(myDevice);
    connector.getInstance().registerShake(myDevice);
    connector.getInstance().registerFreeFall(myDevice);
    connector.getInstance().registerTap(myDevice);

    connector.getInstance().makeVibrate(myDevice);
    started = true;
  }

  text("Device: "+myDevice, 20, 50);
  text("Status: "+connector.getInstance().status, 20,150)
  text("Button: "+connector.getInstance().buttonState, 20, 200);
  text("Temperature: "+connector.getInstance().temperature, 20, 250);
  text("Orientation: "+connector.getInstance().orientation, 20, 300);
  text("Shake: "+connector.getInstance().shaked, 20, 350);
  text("Tap: "+connector.getInstance().tap, 20, 400);
  text("Free Fall: "+connector.getInstance().freeFall, 20, 450);

if (counter%200 == 0){
  connector.getInstance().readBatteryLevel();
  connector.getInstance().readRSSI();
  counter = 0;
}

  text("Battery Level: "+connector.getInstance().batteryLevel, 20, 550);
  text("Signal Strength: "+connector.getInstance().rssi, 20, 600);

}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}



