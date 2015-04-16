var started=false;
var counter = 0;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   frameRate(25); 
}

function draw() {
  background(255);
  textSize(24);
  fill(0);
  noStroke();

if(connector.getInstance().status=="RUNNING" && !started)
  {
    
    console.log("registering...");
    connector.getInstance().registerButton();
    connector.getInstance().registerOrientation();
    connector.getInstance().registerTemperature();
    connector.getInstance().registerShake();
    connector.getInstance().registerFreeFall();
    connector.getInstance().registerTap();

    console.log("done");
    connector.getInstance().makeVibrate();
    started = true;
  }

  text("Device: "+connector.getInstance().boardNumber, 20, 40);
  text("Status: "+connector.getInstance().status, 20,120)
  text("Button: "+connector.getInstance().buttonState, 20, 160);
  text("Temperature: "+connector.getInstance().temperature, 20, 200);
  text("Orientation: "+connector.getInstance().orientation, 20, 240);
  text("Shake: "+connector.getInstance().shaked, 20, 280);
  text("Tap: "+connector.getInstance().tap, 20, 320);
  text("Free Fall: "+connector.getInstance().freeFall, 20, 360);

if (counter%100 == 0){
  connector.getInstance().readBatteryLevel();
  connector.getInstance().readRSSI();
  counter = 0;
}

  text("Battery Level: "+connector.getInstance().batteryLevel, 20, 400);
  text("Signal Strength: "+connector.getInstance().rssi, 20, 440);

  counter++;
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}



