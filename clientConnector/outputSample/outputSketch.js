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

  if(connector.getInstance().status=="RUNNING" && !started) {
      connector.getInstance().makeVibrate();
      started = true;
    }


  if (counter%1000 == 0){
    connector.getInstance().setColor(connector.getInstance().boardNumber, 255, 0, 0);
      if (counter%2000) {
        connector.getInstance().setColor(connector.getInstance().boardNumber, 0, 0, 0);
        connector.getInstance().makeVibrate();
        counter = 0;
      };
  }

  counter++;

}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}



