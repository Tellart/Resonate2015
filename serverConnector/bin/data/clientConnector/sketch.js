var started=false;

function setup() {
   createCanvas(900, 900);
   gem.getInstance().setupSocket();
   frameRate(30); 
}

function draw() {
  
 if(gem.getInstance().status=="OPENED" && !started)
  {
    console.log("registering accelerometer 1");
    gem.getInstance().registerAccelerometer(0);
    started = true;
  }
  ellipse(100,100,map(gem.getInstance().accelerometer.y,-1024,1024,0,100),map(gem.getInstance().accelerometer.y,-1024,1024,0,100));
  
  
}


