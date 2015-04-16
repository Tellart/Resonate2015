/*******
 Made by Tellart
	prepared for Resonate 2015
 *******/

#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxLibwebsockets.h"
#import <MetaWear/MetaWear.h>

#define NUM_MESSAGES 30 // how many past messages we want to keep
#define MAX_NUM_OF_DEVICES 6

struct accValue {
    int x;
    int y;
    int z;
};

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
        void lostFocus();
        void touchDoubleTap(ofTouchEventArgs & touch);
    
        void touchUp(ofTouchEventArgs & touch);
    
        
	/*
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
     
     
        void touchCancelled(ofTouchEventArgs & touch);

     
        void gotFocus();
        void deviceOrientationChanged(int newOrientation);
     
     //--------------------------------------------------------------
     void ofApp::touchDown(ofTouchEventArgs & touch){
     
     }
     
     //--------------------------------------------------------------
     void ofApp::touchMoved(ofTouchEventArgs & touch){
     
     }
     
     
     
     
     
     //--------------------------------------------------------------
     void ofApp::touchCancelled(ofTouchEventArgs & touch){
     
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
    
        map<string,int> idNumberReference;
    
        map<int,bool>   accessGranted;
    
        map<int,string> registeredForButton;
        map<int,string> registeredForTemperature;
        map<int,string> registeredForShake;
        map<int,string> registeredForTap;
        map<int,string> registeredForFreeFall;
        map<int,string> registeredForOrientation;
    
        map<int,vector<string> > registeredForAccelerometer;
        map<int,accValue>        accValues;
    
        
    
    
        int    numOfConnectedDevices;
    
        BOOL   accessRequestNeeded = false;
    
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
        void assignIPToDevices();
        void retractIPToDevice(string ip);
        void setColor(int boardNumber,int red, int green, int blue);
    
        float timePassedSinceLastSentData = 0;
        void sendAccelerometerData();
    
};


