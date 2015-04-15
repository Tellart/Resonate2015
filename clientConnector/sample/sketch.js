var started=false;

var myButton=false;
var circleSize=20; 

var myDevice = 1;

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
    
    connector.getInstance().makeVibrate(myDevice);
    started = true;
  }

  text("Device: "+myDevice, 20, 50);
  text(connector.getInstance().orientation, 20, 100);
  text(connector.getInstance().buttonState, 20, 150);
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

function drawOrientation(){
  console.log(connector.getInstance().orientation);
  rect(width/2,height/2,400,150);
}


