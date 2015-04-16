
var started = false;


function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   frameRate(25); 

}

function draw() {
  background(255);


if(connector.getInstance().status=="RUNNING" && !started)
  {

  }

  
}



