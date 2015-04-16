

function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("10.0.0.5:9092");
   
}

function draw() {
  background(255);
  
  text("hello world",20,30);
  noStroke();


  
}



