var started=false;

var myButton=false;
var circleSize=20; 

var device = 0;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("192.168.1.17:9092");
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
    connector.getInstance().registerButton(device);
    started = true;
    
    connector.getInstance().makeVibrate(device);
  }

<<<<<<< Updated upstream
  myButton = connector.getInstance().getButtonState();
  //if (myButton != -1) console.log("BUTTON!");
  circleSize += myButton*5;
=======
  myButton = connector.getInstance().getButtonState(); //true false
  if (myButton) {
    circleSize += 5;
    console.log(circleSize);
  }
  else console.log(myButton);
>>>>>>> Stashed changes

  ellipse(100,100,circleSize,circleSize);

  //ellipse(100,100,clamp(map(connector.getInstance().accelerometer.y,-1024,1024,0,100),0,100),clamp(map(connector.getInstance().accelerometer.y,-1024,1024,0,100),0,100));
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

