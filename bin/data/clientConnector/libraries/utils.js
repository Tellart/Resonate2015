//code based on example code from libwebsockets http://git.warmcat.com/cgi-bin/cgit/libwebsockets/

/* BrowserDetect came from http://www.quirksmode.org/js/detect.html */

var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{
			string: navigator.userAgent,
			subString: "Chrome",
			identity: "Chrome"
		},
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			prop: window.opera,
			identity: "Opera",
			versionSearch: "Version"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			   string: navigator.userAgent,
			   subString: "iPhone",
			   identity: "iPhone/iPod"
	    },
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};
BrowserDetect.init();

	var pos = 0;

function get_appropriate_ws_url(custom_server)
{
	var pcol;
	var u = document.URL;

	/*
	 * We open the websocket encrypted if this page came on an
	 * https:// url itself, otherwise unencrypted
	 */

	if (u.substring(0, 5) == "https") {
		pcol = "wss://";
		u = u.substr(8);
	} else {
		pcol = "ws://";
		if (u.substring(0, 4) == "http")
			u = u.substr(7);
	}

	u = u.split('/');
	var address = "";
	if(custom_server=="")
	{
		address=u[0];
	}
	else
	{
		address=custom_server;
	}
	return pcol +address;
}
function ReconnectingWebSocket(url, protocols) {
    protocols = protocols || [];

    // These can be altered by calling code.
    this.debug = false;
    this.reconnectInterval = 10000;
    this.timeoutInterval = 5000;

    var self = this;
    var ws;
    var forcedClose = false;
    var timedOut = false;

    this.url = url;
    this.protocols = protocols;
    this.readyState = WebSocket.CONNECTING;
    this.URL = url; // Public API

    this.onopen = function(event) {
    };

    this.onclose = function(event) {
    };

    this.onconnecting = function(event) {
    };

    this.onmessage = function(event) {
    	console.log("message");
    };

    this.onerror = function(event) {
        console.log("error", event)
    };

    function connect(reconnectAttempt) {
        ws = new WebSocket(url, protocols);

        self.onconnecting();
        if (self.debug || ReconnectingWebSocket.debugAll) {
            console.debug('ReconnectingWebSocket', 'attempt-connect', url);
        }

        var localWs = ws;
        var timeout = setTimeout(function() {
            if (self.debug || ReconnectingWebSocket.debugAll) {
                console.debug('ReconnectingWebSocket', 'connection-timeout', url);
            }
            timedOut = true;
            localWs.close();
            timedOut = false;
        }, self.timeoutInterval);

        ws.onopen = function(event) {
            clearTimeout(timeout);
            if (self.debug || ReconnectingWebSocket.debugAll) {
                console.debug('ReconnectingWebSocket', 'onopen', url);
            }
            self.readyState = WebSocket.OPEN;
            reconnectAttempt = false;
            self.onopen(event);
        };

        ws.onclose = function(event) {
            clearTimeout(timeout);
            ws = null;
            if (forcedClose) {
                self.readyState = WebSocket.CLOSED;
                self.onclose(event);
            } else {
                self.readyState = WebSocket.CONNECTING;
                self.onconnecting();
                if (!reconnectAttempt && !timedOut) {
                    if (self.debug || ReconnectingWebSocket.debugAll) {
                        console.debug('ReconnectingWebSocket', 'onclose', url);
                    }
                    self.onclose(event);
                }
                setTimeout(function() {
                    connect(true);
                }, self.reconnectInterval);
            }
        };
        ws.onmessage = function(event) {
            if (self.debug || ReconnectingWebSocket.debugAll) {
                console.debug('ReconnectingWebSocket', 'onmessage', url, event.data);
            }
        	self.onmessage(event);
        };
        ws.onerror = function(event) {
            if (self.debug || ReconnectingWebSocket.debugAll) {
                console.debug('ReconnectingWebSocket', 'onerror', url, event);
            }
            if(ws!=null)
            {
	            if (ws.readyState == 3) { //closed
	                ws.onclose(event)
	            }
        	}
            self.onerror(event);
        };
    }
    connect(url);

    this.send = function(data) {
        if (ws) {
            if (self.debug || ReconnectingWebSocket.debugAll) {
                console.debug('ReconnectingWebSocket', 'send', url, data);
            }
            return ws.send(data);
        } else {
            throw 'INVALID_STATE_ERR : Pausing to reconnect websocket';
        }
    };

    this.close = function() {
        if (ws) {
            forcedClose = true;
            ws.close();
        }
    };

    /**
     * Additional public API method to refresh the connection if still open (close, re-open).
     * For example, if the app suspects bad data / missed heart beats, it can try to refresh.
     */
    this.refresh = function() {
        if (ws) {
            ws.close();
        }
    };
}

/**
 * Setting this to true is the equivalent of setting all instances of ReconnectingWebSocket.debug to true.
 */
ReconnectingWebSocket.debugAll = false;
