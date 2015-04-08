
var  gem= (function () {
    var instance;

 
    function createInstance() {
        var object = new Object();

        object.socket = new Object();
        object.status = "INIT";

        object.setupSocket = function(){
			// setup websocket
			// get_appropriate_ws_url is a nifty function by the libwebsockets people
			// it decides what the websocket url is based on the broswer url
			// e.g. https://mygreathost:9099 = wss://mygreathost:9099

			if (BrowserDetect.browser == "Firefox") {
				object.socket = new MozWebSocket(get_appropriate_ws_url("192.168.1.12:9092"));
			} else {
				object.socket = new ReconnectingWebSocket(get_appropriate_ws_url("192.168.1.12:9092"));
			}
			
			// open
			try {
				object.socket.onopen = function() {
					
					object.status = "OPENED";
				} 

				// received message
				object.socket.onmessage =function got_packet(msg) {
					
				}

				object.socket.onclose = function(){
					object.status = "CLOSED";
				}
			} catch(exception) {
				alert('<p>Error' + exception);  
				object.status = "ERROR";
			}
		}
		
		object.setColor= function(deviceNumber,red,green,blue,intensity)
		{
			var message="{\"message\":\"setColor\",\"device\":\""+deviceNumber+"\",\"red\":\""+red+"\",\"blue\":\""+blue+"\",\"green\":\""+green+"\",\"intensity\":\""+intensity+"\"}";
			this.sendMessage(message);
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
 
