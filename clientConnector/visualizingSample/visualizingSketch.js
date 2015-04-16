var started=false;
var circleSize = 0;
var state=false;
var bg = 0;
var f = 255;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   frameRate(25);
   //background(bg);
}

function draw() {
  background(bg);
  fill(f);
  noStroke();

  if(connector.getInstance().status=="RUNNING" && !started) {
      connector.getInstance().registerButton();
      connector.getInstance().registerShake();
      connector.getInstance().registerTap();

      connector.getInstance().makeVibrate();
      console.log(connector.getInstance().boardNumber);
      started = true;
    }

  if(connector.getInstance().shaked) circleSize = 0;
  if (connector.getInstance().buttonState) circleSize +=50;

  ellipseMode(CENTER);
  ellipse(windowWidth/2,windowHeight/2,circleSize,circleSize);
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}



