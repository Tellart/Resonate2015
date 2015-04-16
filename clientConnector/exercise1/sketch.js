
var started = false;

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   frameRate(25); 

   textSize(24);
  fill(0);
}

function draw() {
  background(255);
  
  text("hello world",20,30);
  noStroke();

if(connector.getInstance().status=="RUNNING" && !started)
  {
    fill(0,255,0);
    started = true;
  }
  
}



