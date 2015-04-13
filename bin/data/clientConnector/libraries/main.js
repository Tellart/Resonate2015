
var  gem= (function () {
    var instance;

 
    function createInstance() {
        var object = new Object();

        object.socket 				= new Object();
        object.status 			   	= "INIT";
        object.buttonStateVariable 	= true;
        object.buttonRegistered   	= -1;
        object.accelerometer        = {};
        object.accelerometer.x      = 0;
        object.accelerometer.y      = 0;
        object.accelerometer.z      = 0;


        object.setupSocket = function(socketAddress){
			// setup websocket
			// get_appropriate_ws_url is a nifty function by the libwebsockets people
			// it decides what the websocket url is based on the broswer url
			// e.g. https://mygreathost:9099 = wss://mygreathost:9099
			if(socketAddress=="")
			{
				socketAddress = "192.168.1.17:9092";
			}

			if (BrowserDetect.browser == "Firefox") {
				object.socket = new MozWebSocket(get_appropriate_ws_url(socketAddress));
			} else {
				object.socket = new ReconnectingWebSocket(get_appropriate_ws_url("192.168.1.17:9092"));
			}
			
			// open
			try {
				object.socket.onopen = function() {
					
					object.status = "OPENED";
				} 

				// received message
				object.socket.onmessage =function got_packet(msg) {
					console.log(msg);
					messageObejct = JSON.parse(msg.data);
					if(messageObejct["message"]=="buttonEvent")
					{
						if(msg.data["value"]==0)
						{
							object.buttonStateVariable=false;
						}
						else
						{
							object.buttonStateVariable=true;
							object.buttonDelegate();
							
						}
						return;
					}
					else if(messageObejct["message"] == "accelerometerEvent")
					{
						object.accelerometer.x = messageObejct["x"];
						object.accelerometer.y = messageObejct["y"];
						object.accelerometer.z = messageObejct["z"];
						console.log(object.accelerometer);
					}
				}

				object.socket.onclose = function(){
					object.status = "CLOSED";
				}
				object.socket.onerror = function(){
					object.status = "ERROR";
				}
				
			} catch(exception) {
				alert('<p>Error' + exception);  
				object.status = "ERROR";
			}
		}
		
		object.getButtonState = function(){
			if(object.buttonRegistered)
			{
				return -1;
			}
			else
			{
				return buttonStateVariable;
			}
		}
		object.getAccelerometerData = function()
		{

		}
		object.getTemperatureData = function()
		{
			
		}

		object.setColor = function(deviceNumber,red,green,blue,intensity)
		{
			var message="{\"message\":\"setColor\",\"device\":\""+deviceNumber+"\",\"red\":\""+red+"\",\"blue\":\""+blue+"\",\"green\":\""+green+"\",\"intensity\":\""+intensity+"\"}";
			this.sendMessage(message);
		}
		object.registerButton = function(deviceNumber)
		{
			var message="{\"message\":\"registerButton\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
			
		}
		object.registerAccelerometer = function(deviceNumber)
		{
			var message="{\"message\":\"registerAccelerometer\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}
		object.releaseAccelerometer= function(){
			var message="{\"message\":\"releaseAccelerometer\"}";
			this.sendMessage(message);
		}
		object.registerTemperature = function(deviceNumber)
		{
			var message="{\"message\":\"registerTemperature\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}
		object.releaseTemperature= function(){
			var message="{\"message\":\"releaseTemperature\"}";
			this.sendMessage(message);
		}
		object.registerShake = function(deviceNumber)
		{
			var message="{\"message\":\"registerShake\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}
		object.releaseShake= function(){
			var message="{\"message\":\"releaseShake\"}";
			this.sendMessage(message);
		}
		object.makeVibrate= function(deviceNumber){
			var message="{\"message\":\"makeVibrate\",\"device\":\""+deviceNumber+"\"}";
			this.sendMessage(message);
		}

		object.releaseButton= function(){
			var message="{\"message\":\"releaseButton\"}";
			this.sendMessage(message);
		}
		object.buttonState = function()
		{
			
		}
		object.sendMessage = function(message){
			object.socket.send(message);
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
 
