#include "ofApp.h"
#import <MetaWear/MetaWear.h>

//--------------------------------------------------------------
void ofApp::setup(){	
    ofxLibwebsockets::ServerOptions options = ofxLibwebsockets::defaultServerOptions();
    options.port = 9092;
    options.bUseSSL = false; // you'll have to manually accept this self-signed cert if 'true'!
    bSetup = server.setup( options );
    
    // this adds your app as a listener for the server
    server.addListener(this);
    
    
    ofSetFrameRate(3);
    NSLog(@"here");
    // Begin scanning for MetaWear boards
    [[MBLMetaWearManager sharedManager] startScanForMetaWearsWithHandler:^(NSArray *array) {
        // Hooray! We found a MetaWear board, so stop scanning for more
        [[MBLMetaWearManager sharedManager] stopScanForMetaWears];
        // Connect to the board we found
        MBLMetaWear *device = [array firstObject];
        [device connectWithHandler:^(NSError *error) {
            if (!error) {
                // Hooray! We connected to a MetaWear board, so flash its LED!
                [device.led flashLEDColor:[UIColor greenColor] withIntensity:0.5];
                [device.led setLEDColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:255] withIntensity:0];
            }
        }];
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
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
//--------------------------------------------------------------
void ofApp::onConnect( ofxLibwebsockets::Event& args ){
    cout<<"on connected"<<endl;
    
}

//--------------------------------------------------------------
void ofApp::onOpen( ofxLibwebsockets::Event& args ){
    cout<<"new connection open"<<endl;
    ofxLibwebsockets::Connection cTmp=args.conn;
    string sTmp=cTmp.getClientName();
    
    messages.push_back(ofToString(ofGetFrameNum())+" conn " + cTmp.getClientIP() + ", " + sTmp );
    
    
    printf("connected args -%s-\n",sTmp.c_str());
    
    
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
    
    if(message=="start")
    {
        string firstName = args.json.get("firstName", "error").asString();
        string lastName  = args.json.get("lastName", "error").asString();
        string email     = args.json.get("email", "error").asString();
        
        server.send("{\"message\":\"save_credentials\",\"firstName\":\""+firstName+"\",\"lastName\":\""+lastName+"\",\"email\":\""+email+"\"}");
        return;
    }
    else if(message == "credentials_saved")
    {
        server.send("{\"message\":\"session_started\"}");
        return;
    }
    else if(message == "invalid_email")
    {
        server.send("{\"message\":\"invalid_email\"}");
        return;
    }
    else if(message == "set_destination")
    {
        string destination  = args.json.get("destination", "error").asString();
        string email     = args.json.get("email", "error").asString();
        
        server.send("{\"message\":\"echo_set_destination\",\"destination\":\""+destination+"\",\"email\":\""+email+"\"}");
        return;
    }  else if(message == "destination_received")
    {
        server.send("{\"message\":\"destination_received\",\"destination\":\""+args.json.get("destination", "error").asString()+"\",\"email\":\""+args.json.get("email", "error").asString()+"\"}");
        return;
        
    }else if(message == "back_to_idle")
    {
        server.send("{\"message\":\"back_to_idle\"}");
        
        server.send("{\"message\":\"next_player\",\"destination\":\""+args.json.get("destination", "error").asString()+"\",\"email\":\""+args.json.get("email", "error").asString()+"\"}");
        
    }else if(message == "take_photo")
    {
        
        server.send("{\"message\":\"echo_take_image\",\"email\":\""+args.json.get("email", "").asString()+"\",\"current_attention_level\":\""+args.json.get("current_attention_level", "").asString()+"\"}");
        
    }else if(message == "game_finished")
    {
        delayedMessage="{\"message\":\"retrieve_credentials\",\"email\":\""+args.json.get("email", "").asString()+"\",\"leaderBoard\":\""+args.json.get("leaderBoard", "").asString()+"\"}";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            sendMessageWithDelay(delayedMessage);
        });
        
        
        server.send("{\"message\":\"echo_game_finished\",\"email\":\""+args.json.get("email", "").asString()+"\",\"leaderBoard\":\""+args.json.get("leaderBoard", "").asString()+"\",\"maxFocus\":\""+args.json.get("maxFocus", "").asString()+"\",\"with_points\":\""+args.json.get("with_points", "").asString()+"\"}");
        
    }else if(message == "credentials_for_exit")
    {
        server.send("{\"message\":\"echo_cred_for_exit\",\"email\":\""+args.json.get("email", "").asString()+"\",\"firstName\":\""+args.json.get("firstName", "").asString()+"\",\"destination\":\""+args.json.get("destination", "").asString()+"\",\"code\":\""+args.json.get("code", "").asString()+"\",\"lastName\":\""+args.json.get("lastName", "").asString()+"\"}");
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
