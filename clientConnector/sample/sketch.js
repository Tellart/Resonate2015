var started=false;

var myButton=-1;
var circleSize=5;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("192.168.1.12:9092");
   frameRate(30); 
}

function draw() {
  background(255);
  textSize(32);
	fill(0, 102, 153, 51);
	text("It works!", 10, 30); 
	
 if(connector.getInstance().status=="OPENED" && !started)
  {
    console.log("registering button");
    connector.getInstance().registerButton(0);
    started = true;
    
    connector.getInstance().makeVibrate(0);
  }

  myButton = connector.getInstance().getButtonState();
  if (myButton != -1) console.log("BUTTON!");
  circleSize += myButton*5;

  ellipse(100,100,circleSize,circleSize);

  //ellipse(100,100,clamp(map(connector.getInstance().accelerometer.y,-1024,1024,0,100),0,100),clamp(map(connector.getInstance().accelerometer.y,-1024,1024,0,100),0,100));
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

