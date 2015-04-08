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
    
    
    // Begin scanning for MetaWear boards
    [[MBLMetaWearManager sharedManager] startScanForMetaWearsWithHandler:^(NSArray *array) {
        // Hooray! We found a MetaWear board, so stop scanning for more
        [[MBLMetaWearManager sharedManager] stopScanForMetaWears];
        // Connect to the board we found
        
        
        for (int i=0; i<[array count]; i++) {
            MBLMetaWear *device = [array objectAtIndex:i];
            [device rememberDevice];
            [device connectWithHandler:^(NSError *error) {
                if (!error) {
                    // Hooray! We connected to a MetaWear board, so flash its LED!
                    [device.led flashLEDColor:[UIColor greenColor] withIntensity:0.5];
                    [device.led setLEDColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:255] withIntensity:0];
                }
            }];
            bleDeviceMap[i]=device;
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
}

//--------------------------------------------------------------
void ofApp::exit(){

}
//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
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
        [bleDeviceMap[deviceIndex].led setLEDColor:[UIColor colorWithRed:red green:green blue:blue alpha:255] withIntensity:intensity];
        return;
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
