#include "ofApp.h"


//--------------------------------------------------------------
void ofApp::setup(){	
    ofxLibwebsockets::ServerOptions options = ofxLibwebsockets::defaultServerOptions();
    options.port = 9092;
    options.bUseSSL = false; // you'll have to manually accept this self-signed cert if 'true'!
    bSetup = server.setup( options );
    
    // this adds your app as a listener for the server
    server.addListener(this);
    
    ofSetFrameRate(3);
    initStructures();
    NSArray *whiteList = @[@"AB316079-B6D3-89EA-5C09-080DAA732412",@"AB316079-B6D3-89EA-5C09-080DAA732412",@"AB316079-B6D3-89EA-5C09-080DAA732412",@"AB316079-B6D3-89EA-5C09-080DAA732412"];
    
    // Begin scanning for MetaWear boards
    [[MBLMetaWearManager sharedManager] startScanForMetaWearsWithHandler:^(NSArray *array) {
        // Hooray! We found a MetaWear board, so stop scanning for more
        //[[MBLMetaWearManager sharedManager] stopScanForMetaWears];
        // Connect to the board we found
        
        for (int i=0; i<[array count]; i++) {
            MBLMetaWear *device = [array objectAtIndex:i];
            if([whiteList indexOfObject:device.identifier.UUIDString]!= NSNotFound)
            {
                [device connectWithHandler:^(NSError *error) {
                    if (!error) {
                        
                        // Hooray! We connected to a MetaWear board, so flash its LED!
                        [device.led flashLEDColor:[UIColor greenColor] withIntensity:1 numberOfFlashes:2];
                        NSLog(@"%@",device.identifier.UUIDString);
                        
                        [device rememberDevice];
                       
                        
                        //*****CHECK IF DEVICE ALREADY SAVED*****//
                        bool deviceAlreadyPresent = false;
                        for(int k=0;k<MAX_NUM_OF_DEVICES;k++)
                        {
                            if(bleDeviceMap[k]!=nil)
                            {
                                if(bleDeviceMap[k].identifier==device.identifier)
                                {
                                    deviceAlreadyPresent = true;
                                }
                            }
                        }
                        //*****IF NOT SAVED, SAVE DEVICE*****//
                        if(!deviceAlreadyPresent)
                        {
                            for(int k=0;k<MAX_NUM_OF_DEVICES;k++)
                            {
                                if(bleDeviceMap[k]==nil)
                                {
                                    bleDeviceMap[k]=device;
                                    break;
                                }
                            }
                        }
                       
                    }
                }];
            }
          
        }
    }];
}

//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofBackground(0, 0, 0);
    if ( bSetup ){
        ofSetColor(0,150,0);
        
        ofDrawBitmapString("WebSocket server setup at "+ofToString( server.getPort() ) + ( server.usingSSL() ? " with SSL" : " without SSL"), 20, 20);
        
        ofSetColor(150);
    } else {
        ofDrawBitmapString("WebSocket setup failed :(", 20,20);
    }
    
    int x = 20;
    int y = 50;
    
    ofSetColor(255);
    for (int i = messages.size() -1; i >= 0; i-- ){
        ofDrawBitmapString( messages[i], x, y );
        y += 20;
    }
    if (messages.size() > NUM_MESSAGES) messages.erase( messages.begin() );
    
    
    ofSetColor(255);
    for (int i=0; i<MAX_NUM_OF_DEVICES; i++) {
        if(bleDeviceMap[i]!=NULL)
        {
            ofRect(i*15+15, ofGetHeight()-15, 12, 12);
        }
    }
}

//--------------------------------------------------------------
void ofApp::exit(){
    //server.close();
}
//--------------------------------------------------------------
void ofApp::lostFocus(){
   // server.close();

}
//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}
//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    messages.clear();
}
/****************
 ******
 WEBSOCKET METHODS
 ****************/
//--------------------------------------------------------------
void ofApp::onConnect( ofxLibwebsockets::Event& args ){
    cout<<"on connected"<<endl;
    
}

//--------------------------------------------------------------
void ofApp::onOpen( ofxLibwebsockets::Event& args ){
    cout<<"new connection open"<<endl;
    ofxLibwebsockets::Connection cTmp=args.conn;
    string sTmp=cTmp.getClientName();
 
    messages.push_back(ofToString(ofGetFrameNum())+" conn " + cTmp.getClientIP() );
    
    assignIPToDevice(cTmp.getClientIP());
   
}

//--------------------------------------------------------------
void ofApp::onClose( ofxLibwebsockets::Event& args ){
    cout<<"on close"<<endl;
    messages.push_back("Connection closed");
  
}

//--------------------------------------------------------------
void ofApp::onIdle( ofxLibwebsockets::Event& args ){
    cout<<"on idle"<<endl;
    
}

//--------------------------------------------------------------
void ofApp::onMessage( ofxLibwebsockets::Event& args ){
    cout<<"got message "<<args.message<<endl;
   
    string from = args.conn.getClientIP();
    
    string message = args.json.get("message", "error").asString();
    messages.push_back("message: "+message);
    printf("%d mess %s %s",ofGetFrameNum(),from.c_str(),message.c_str());
    
    if(message=="setColor")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        int red         = args.json.get("red", -1).asInt();
        int green       = args.json.get("green", -1).asInt();
        int blue        = args.json.get("blue", -1).asInt();
        int intensity   = args.json.get("intensity", -1).asInt();
       
        if(deviceIndex<=MAX_NUM_OF_DEVICES && deviceIndex>=0 && red>=0 && red <256 && green>=0 && green <256 && blue>=0 && blue <256 && intensity>=0 && intensity <256)
        {
        
            [bleDeviceMap[deviceIndex].led setLEDColor:[UIColor colorWithRed:red green:green blue:blue alpha:255] withIntensity:ofMap(intensity, 0, 255, 0, 1)];
        }
        
        return;
    }
    else if(message == "registerButton")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        if(deviceIndex<=MAX_NUM_OF_DEVICES && deviceIndex>=0)
        {
            if(registeredForButton.find(deviceIndex)==registeredForButton.end())
            {
                bool ipPresent = false;
                for (std::map<int, string>::iterator it=registeredForButton.begin(); it!=registeredForButton.end(); it++) {
                    string ipTmp=it->second;
                    if(ipTmp==ipAddress)
                    {
                        ipPresent=true;
                    }
                }
                if(!ipPresent){
                    [bleDeviceMap[deviceIndex].mechanicalSwitch.switchUpdateEvent startNotificationsWithHandler:^(MBLNumericData* obj, NSError   *error) {
                        string newMessage="{\"message\":\"buttonEvent\",\"value\":\""+ofToString([obj.value integerValue])+"\"}";
                        server.send(newMessage, ipAddress);
                    }];
                    registeredForButton[deviceIndex]=ipAddress;
                }
            }
        }
        
        return;
    }
    else if(message == "releaseButton")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        
        
        for (std::map<int, string>::iterator it=registeredForButton.begin(); it!=registeredForButton.end(); it++) {
            string ipTmp=it->second;
            if(ipTmp==ipAddress)
            {
                [bleDeviceMap[it->first].mechanicalSwitch.switchUpdateEvent stopNotifications];
                registeredForButton.erase(deviceIndex);
                break;
            }
        }
    }
    else if(message == "registerAccelerometer")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        if(deviceIndex<=MAX_NUM_OF_DEVICES && deviceIndex>=0)
        {
            if(registeredForAccelerometer.find(deviceIndex)==registeredForAccelerometer.end())
            {
                bool ipPresent = false;
                for (std::map<int, string>::iterator it=registeredForAccelerometer.begin(); it!=registeredForAccelerometer.end(); it++) {
                    string ipTmp=it->second;
                    if(ipTmp==ipAddress)
                    {
                        ipPresent=true;
                    }
                }
                if(!ipPresent){
                    bleDeviceMap[deviceIndex].accelerometer.fullScaleRange = MBLAccelerometerRange2G;  // Default: +- 8G
                    bleDeviceMap[deviceIndex].accelerometer.sampleFrequency = MBLAccelerometerSampleFrequency12_5Hz;
                    [bleDeviceMap[deviceIndex].accelerometer.dataReadyEvent startNotificationsWithHandler:^(MBLAccelerometerData *obj, NSError   *error) {
                        string newMessage="{\"message\":\"accelerometerEvent\",\"x\":\""+ofToString(obj.x)+"\",\"y\":\""+ofToString(obj.y)+"\",\"z\":\""+ofToString(obj.z)+"\"}";
                       // NSLog(@"accelerometer:%d,%d,%d",obj.x,obj.y,obj.z);
                        
                        server.send(newMessage, ipAddress);
                    }];
                    registeredForAccelerometer[deviceIndex]=ipAddress;
                }
            }
        }
        
        return;
    }
    else if(message == "releaseAccelerometer")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        
        
        for (std::map<int, string>::iterator it=registeredForAccelerometer.begin(); it!=registeredForAccelerometer.end(); it++) {
            string ipTmp=it->second;
            if(ipTmp==ipAddress)
            {
                [bleDeviceMap[it->first].accelerometer.dataReadyEvent stopNotifications];
                registeredForAccelerometer.erase(deviceIndex);
                registeredForAccelerometer.erase(it, it);
                registeredForAccelerometer.erase(it->first);
                break;
            }
        }
    }
    else if(message == "registerShake")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        if(deviceIndex<=MAX_NUM_OF_DEVICES && deviceIndex>=0)
        {
            if(registeredForShake.find(deviceIndex)==registeredForShake.end())
            {
                bool ipPresent = false;
                for (std::map<int, string>::iterator it=registeredForShake.begin(); it!=registeredForShake.end(); it++) {
                    string ipTmp=it->second;
                    if(ipTmp==ipAddress)
                    {
                        ipPresent=true;
                    }
                }
                if(!ipPresent){
                    
                    [bleDeviceMap[deviceIndex].accelerometer.shakeEvent startNotificationsWithHandler:^(id obj, NSError *error) {
                        string newMessage="{\"message\":\"shakeEvent\"}";
                        server.send(newMessage, ipAddress);

                    }];
                    
                    registeredForShake[deviceIndex]=ipAddress;
                }
            }
        }
        
        return;
    }
    else if(message == "releaseShake")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        
        
        for (std::map<int, string>::iterator it=registeredForShake.begin(); it!=registeredForShake.end(); it++) {
            string ipTmp=it->second;
            if(ipTmp==ipAddress)
            {
                [bleDeviceMap[it->first].accelerometer.shakeEvent stopNotifications];
                registeredForShake.erase(deviceIndex);
                registeredForShake.erase(it, it);
                registeredForShake.erase(it->first);
                break;
            }
        }
    }
    else if(message == "registerTemperature")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        if(deviceIndex<=MAX_NUM_OF_DEVICES && deviceIndex>=0)
        {
            if(registeredForTemperature.find(deviceIndex)==registeredForTemperature.end())
            {
                bool ipPresent = false;
                for (std::map<int, string>::iterator it=registeredForTemperature.begin(); it!=registeredForTemperature.end(); it++) {
                    string ipTmp=it->second;
                    if(ipTmp==ipAddress)
                    {
                        ipPresent=true;
                    }
                }
                if(!ipPresent){
                     bleDeviceMap[deviceIndex].temperature.samplePeriod = 2000;
                    [ bleDeviceMap[deviceIndex].temperature.dataReadyEvent startNotificationsWithHandler:^(NSDecimalNumber* temp, NSError *error) {
                        string suffix = bleDeviceMap[deviceIndex].temperature.units == MBLTemperatureUnitCelsius ? "°C" : "°F";
                        
                        NSString *decimalString =  [NSString stringWithFormat:@"%@",temp];
                        decimalString = [[decimalString componentsSeparatedByString:@" "] objectAtIndex:4] ;
                        string tempTmp = ofToString([decimalString UTF8String] )+suffix;
                        
                        tempTmp = "{\"message\":\"temperatureEvent\",\"value\":\""+tempTmp+"\"}";
                        
                        server.send(tempTmp, ipAddress);

                    }];
                   
                    registeredForTemperature[deviceIndex]=ipAddress;
                }
            }
        }
        
        return;
    }
    else if(message == "releaseTemperature")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        
        
        
        for (std::map<int, string>::iterator it=registeredForTemperature.begin(); it!=registeredForTemperature.end(); it++) {
            string ipTmp=it->second;
            if(ipTmp==ipAddress)
            {
                [bleDeviceMap[it->first].temperature.dataReadyEvent stopNotifications];
                registeredForTemperature.erase(deviceIndex);
                registeredForTemperature.erase(it, it);
                registeredForTemperature.erase(it->first);
                break;
            }
        }
    }
    else if(message == "makeVibrate")
    {
        int deviceIndex = args.json.get("device", -1).asInt();
        string ipAddress = args.conn.getClientIP();
        uint8_t dcycle = 500;
        uint16_t pwidth = 248;
        
        if(args.json.get("hasOptions",-1).asBool())
        {
            dcycle =ofClamp(args.json.get("dcycle", 500).asInt(),0,5000);
            pwidth = ofClamp(args.json.get("pwidth",248).asInt(),0,248);
        }
        if(deviceIndex<=MAX_NUM_OF_DEVICES && deviceIndex>=0)
        {
            [bleDeviceMap[deviceIndex].hapticBuzzer startHapticWithDutyCycle:dcycle pulseWidth:pwidth completion:nil];
        }
    }
}

//--------------------------------------------------------------
void ofApp::onBroadcast( ofxLibwebsockets::Event& args ){
    cout<<"got broadcast "<<args.message<<endl;
}
//--------------------------------------------------------------
void ofApp::sendMessageWithDelay( string message ){
    server.send(message);
}
/****************
 ******
COMMUNICATION WITH BLE
 ****************/
//--------------------------------------------------------------
void ofApp::initStructures(){
    for (int i=0; i<MAX_NUM_OF_DEVICES; i++) {
        bleDeviceMap[i] = NULL;
    }
    for (int i=0; i<MAX_NUM_OF_DEVICES; i++) {
        bleIPMap[i] = "";
    }
    
}
//--------------------------------------------------------------
void ofApp::assignIPToDevice(string ip){
    for (int i=0; i<MAX_NUM_OF_DEVICES; i++) {
        if(bleDeviceMap[i]!=NULL && bleIPMap[i] == "")
        {
            bleIPMap[i] = ip;
            return;
        }
    }
}
//--------------------------------------------------------------
void ofApp::setColor(int boardNumber,int red, int green, int blue){
  
}
