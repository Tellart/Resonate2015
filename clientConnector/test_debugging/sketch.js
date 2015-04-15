var started=false;

var myButton=-1;
var circleSize=5;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   frameRate(30); 
}

function draw() {
  background(255);
  textSize(32);
	fill(0, 102, 153, 51);
	text("It works!", 10, 30); 


  //ellipse(100,100,clamp(map(connector.getInstance().accelerometer.y,-1024,1024,0,100),0,100),clamp(map(connector.getInstance().accelerometer.y,-1024,1024,0,100),0,100));
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

function shaked()
{

}

function orientationChanged(newOrientation)
{
 
}

function tapped()
{

}

function isFalling()
{

}

function buttonPressed()
{

}

function initDevice(deviceNumber)
{

}



