#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxLibwebsockets.h"
#import <MetaWear/MetaWear.h>

#define NUM_MESSAGES 30 // how many past messages we want to keep
#define MAX_NUM_OF_DEVICES 16


class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	/*
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void deviceOrientationChanged(int newOrientation);
     
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
     void ofApp::deviceOrientationChanged(int newOrientation){
     
     }

    */
        void gotMemoryWarning();
 
    
        ofxLibwebsockets::Server server;
    
        vector<string> messages;
    
        string       bleIPMap[MAX_NUM_OF_DEVICES];
        MBLMetaWear* bleDeviceMap[MAX_NUM_OF_DEVICES];
    
        string delayedMessage="";
        
        void sendMessageWithDelay(string message);
        
        bool bSetup;
        
        // websocket methods
        void onConnect( ofxLibwebsockets::Event& args );
        void onOpen( ofxLibwebsockets::Event& args );
        void onClose( ofxLibwebsockets::Event& args );
        void onIdle( ofxLibwebsockets::Event& args );
        void onMessage( ofxLibwebsockets::Event& args );
        void onBroadcast( ofxLibwebsockets::Event& args );
    
    
        //**BOARD MANAGER**//
        void initStructures();
        void assignIPToDevice(string ip);
        void setColor(int boardNumber,int red, int green, int blue);
    
};


