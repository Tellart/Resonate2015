function setup() {
   createCanvas(200, 100);
   gem.getInstance().setupSocket();
   
   //gem.getInstance().setColor(0,0,255,0,1);
}

function draw() {
	if(gem.getInstance().status=="OPENED")
	{
 	 	background(11,255,50);
	}
	else if(gem.getInstance().status=="CLOSE")
	{
		background(255,125,84);
	}
	else if(gem.getInstance().status=="INIT")
	{
		background(255,255,0);
	}
	
	
	
}


