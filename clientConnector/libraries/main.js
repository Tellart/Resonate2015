
var  connector= (function () {
    var instance;
 
    function createInstance() {
        var object = new Object();

        object.socket 				= new Object();
        object.status 			   	= "INIT";

        object.boardNumber          = -1;

        object.buttonState      	= false;
        object.buttonRegistered   	= false;

        object.temperatureRegistered = false;
        object.temperature           = "";
        
        object.freeFallRegistered    = false;
        object.freeFall              = false;

        object.tapRegistered 		 = false;
        object.tap					 = false;

        object.orientationRegistered = false;
        object.orientation			 = "";

        object.setupSocket = function(socketAddress){
			// setup websocket
			// get_appropriate_ws_url is a nifty function by the libwebsockets people
			// it decides what the websocket url is based on the broswer url
			// e.g. https://mygreathost:9099 = wss://mygreathost:9099
			if(socketAddress=="")
			{
				socketAddress = "192.168.1.:9092";
			}

			if (BrowserDetect.browser == "Firefox") {
				object.socket = new MozWebSocket(get_appropriate_ws_url(socketAddress));
			} else {
				object.socket = new ReconnectingWebSocket(get_appropriate_ws_url(socketAddress));
			}
			
			// open
			try {
				object.socket.onopen = function() {
					
					object.status = "OPENED";
				} 


				// received message
				object.socket.onmessage =function got_packet(msg) {
					console.log(msg);
					messageObject = JSON.parse(msg.data);
					if(messageObject["message"]=="buttonEvent")
					{
						if(messageObject["value"]==0)
						{
							object.buttonState=false;
						}
						else
						{
							object.buttonState=true;
							
							
						}
						try{
					        buttonPressed();
						}
						catch(e)
						{
							
						}
						return;
					}
					else if(messageObject["message"] == "freeFallEvent")
					{
						object.freeFall = true;
						window.setTimeout(function(){
								object.freeFall = false;
						},500);
						try{
					        isFalling();
						}
						catch(e)
						{
							
						}
					}
					else if(messageObject["message"] == "orientationEvent")
					{
						object.orientation = messageObject["value"];

						try{
					        orientationChanged(object.orientation);
						}
						catch(e)
						{
							
						}
					}else if(messageObject["message"] == "temperatureEvent")
					{
						object.temperature = messageObject["value"];
					}
					else if(messageObject["message"] == "tapEvent")
					{
						object.tap = true;
						window.setTimeout(function(){
								object.tap = false;
						},100);

						try{
					        tapped();
						}
						catch(e)
						{
							
						}
					}
					else if(messageObject["message"] == "shakeEvent")
					{
						object.shaked = true;
						window.setTimeout(function(){
								object.shaked = false;
						},100);

						try{
					        shaked();
						}
						catch(e)
						{
							
						}
					}else if(messageObject["message"] == "error")
					{
						console.warn(messageObject["type"]);
					}
					else if(messageObject["message"] == "bleAssigned")
					{
						object.status = "RUNNING"
						object.boardNumber = messageObject["number"];
						try{
					        initDevice(object.boardNumber);
						}
						catch(e)
						{
							
						}
					}
				}

				object.socket.onclose = function(){
					object.status = "CLOSED";
					console.warn("connection:"+object.status);
					object.boardNumber = -1;
				}
				object.socket.onerror = function(){
					object.status = "ERROR";
				}
				
			} catch(exception) {
				alert('<p>Error' + exception);  
				object.status = "ERROR";
			}
		}
		/*
		object.getButtonState = function(){
			if(!object.buttonRegistered)
			{
				return -1;
			}
			else
			{
				return object.getButtonStateVariable;
			}
		}
		*/

		object.setColor = function(deviceNumber,red,green,blue,intensity)
		{
			if(arguments.length == 5)
			{	
				
				var message="{\"message\":\"setColor\",\"device\":\""+deviceNumber+"\",\"red\":\""+red+"\",\"blue\":\""+blue+"\",\"green\":\""+green+"\",\"intensity\":\""+intensity+"\"}";
				

				this.sendMessage(message);
				
			}
			else
			{
				var message="{\"message\":\"setColor\",\"device\":\""+object.boardNumber+"\",\"red\":\""+arguments[0]+"\",\"blue\":\""+arguments[1]+"\",\"green\":\""+arguments[2]+"\",\"intensity\":\""+arguments[3]+"\"}";
				
				this.sendMessage(message);
				
			}
		}
		object.registerButton = function(deviceNumber)
		{
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"registerButton\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
			
		}
		object.registerTemperature = function(deviceNumber)
		{
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"registerTemperature\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
			object.temperatureRegistered = true;

		}
		object.releaseTemperature= function(){
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"releaseTemperature\"}";
			this.sendMessage(message);
			object.temperatureRegistered = false;
		}
		
		object.registerShake = function(deviceNumber)
		{
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"registerShake\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);

		}
		object.shaked= function()
		{
			
		}
		object.releaseShake= function(){

			var message="{\"message\":\"releaseShake\"}";
			this.sendMessage(message);
		}
		object.registerFreeFall = function(deviceNumber)
		{
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"registerFreeFall\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}
		object.releaseFreeFall= function(){
			var message="{\"message\":\"releaseFreeFall\"}";
			this.sendMessage(message);
		}
		object.registerTap = function(deviceNumber)
		{
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"registerTap\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}
		object.releaseTap= function(){
			
			var message="{\"message\":\"releaseTap\"}";
			this.sendMessage(message);
		}
		object.registerOrientation = function(deviceNumber)
		{
			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			var message="{\"message\":\"registerOrientation\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}
		object.releaseOrientation= function(){
			
			var message="{\"message\":\"releaseOrientation\"}";
			this.sendMessage(message);
		}
		object.makeVibrate= function(deviceNumber){

			if(deviceNumber=="" || deviceNumber==undefined)
			{
				deviceNumber =object.boardNumber;
			}
			
			var message;
			
			message="{\"message\":\"makeVibrate\",\"device\":\""+deviceNumber+"\"}";
			
			
			this.sendMessage(message);
		}
		object.makeVibrateWithOptions= function(length,amplitude,deviceNumber){

			
			if(length=="" || length==undefined)
			{
				length=500;
			}
			var message;
			if(arguments.length==3)
			{
				message="{\"message\":\"makeVibrate\",\"device\":\""+deviceNumber+"\",\"withLength\":\""+length+"\",\"withAmplitude\":\""+amplitude+"\"}";
			}
			else
			{
				message="{\"message\":\"makeVibrate\",\"device\":\""+object.boardNumber+"\",\"withLength\":\""+arguments[0]+"\",\"withAmplitude\":\""+arguments[1]+"\"}";	
			}
			console.log(message);
			this.sendMessage(message);
		}

		object.releaseButton= function(){
			var message="{\"message\":\"releaseButton\"}";
			this.sendMessage(message);
		}
		
		object.sendMessage = function(message){
			try{
				object.socket.send(message);
			}
			catch(e)
			{
				console.warn("error in communicating with the connector");
			}

		}
        return object;
    }
    

 
    return {
        getInstance: function () {
            if (!instance) {
                instance = createInstance();
            }
            return instance;
        }
    };
})();

function clamp(value, minVal, maxVal)
{
	if(value<minVal)
	{
		value = minVal;
		return value;
	}
	if(value>maxVal)
	{
		value = maxVal;
		return value;
	}
	return value;
}
 
