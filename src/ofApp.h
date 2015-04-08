#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxLibwebsockets.h"
#define NUM_MESSAGES 30 // how many past messages we want to keep

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        ofxLibwebsockets::Server server;
    
        vector<string> messages;
        map<string,ofxLibwebsockets::Connection> elementsConnected;
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
};


