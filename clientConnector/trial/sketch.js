
var once = false;
function setup() {
   createCanvas(windowWidth, windowHeight);
   connector.getInstance().setupSocket("192.168.1.6:9092");
   
}

function draw() {
  background(55,66,187);
  
  text("hello world",20,30);
  noStroke();
  if(millis()>1000 && connector.getInstance().status=="OPENED" && !once)
  {
  	console.log("sending");
  	once = true;
  	connector.getInstance().readBatteryLevel(0);
  }

  
}



