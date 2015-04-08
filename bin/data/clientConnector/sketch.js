function setup() {
   createCanvas(100, 100);
   gem.getInstance().setupSocket();
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
