#Designing connected experiences with BLE 


[Workshop description](http://resonate.io/2015/education/designing-connected-experiences-with-ble/)


## How To Get Started
####Download repository

Git user can follow these steps in the terminal:

- navigate to the location where you want to copy the repository;
- type ```
git clone https://github.com/Tellart/Resonate2015.git
```

otherwhise just download this repo from github.

####Run the server
######Mac OS X 
- Navigate to client connector ```cd Resonate2015/clientConnector```
- Start the webserver with the command: ```python -m SimpleHTTPServer 8000```
- Open your browser and go to the url ```http://localhost:8000/sample/``` to check that is working.

In the folder clientConnector you can duplicate the _sample_ folder and rename it as you like. 

Open your browser and go to the url ```http://localhost:8000/yourname/```.


The server is not necessary but just nice to have, you can directly open _index.html_ located in the sample folder or the duplicate of it.

 

## Reference
<p align="center" >
  <img src="https://raw.github.com/Tellart/Resonate2015/system.png" alt="AFNetworking" title="AFNetworking">
</p>



### `gem` object

The gem object is a singleton that abstract the controller of the ble modules. 
To retrieve the object call `getInstance` on gem.

```javascript
gem.getInstance()
```


##### Properties
`status`  can be __INIT__, __OPENED__, __CLOSED__, __ERROR__

```javascript
if(gem.getInstance().status=="OPENED")
{
	background(12,255,23);
}

```



##### Methods
__utility methods__  
 
`setupSocket()` 					 start the communication with the connector on default address;  
`setupSocket(socketAddress)`   start the communication with a socket address in the form `"192.168.1.17:9092"` (the server is receiving on port 9092)  

__actuators methods__   
`setColor(deviceNumber,red,green,blue,intensity)` set the color the led of one board. _deviceNumber_ is an integer between 0 and 4, the components _red_, _green_, _blue_ and _intensity_ are integers between 0 and 255

`makeVibrate(deviceNumber)` _deviceNumber_ is an integer between 0 and 4, it will create a vibration

__sensors methods__ 





