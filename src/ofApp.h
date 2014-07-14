#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxOsc.h"
#include "ofxCenteredTrueTypeFont.h"

#define HOST "localhost"
//beware app wont complie+run if no wifi connected! < switch back to localhost
#define PORT 12345

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
    
    void grabColor();
    void colorWheelClickCheck();
    
    //text sender
    ofxOscSender sender;
    string input;
    ofColor feedbackFlash;
    
    
    //balloon selector bar
    bool bBarOn;
    bool bControlingBar;
    
    ofRectangle bar;
    ofRectangle currentBar;
    
    int totalBalloon;
    int output;
    int prevOutput;
    
    int holdDelay;
    
    ofRectangle activatePanelRect;
    bool bCallingPanel;
    
    //color picker
    ofImage wheel;
    ofColor cPick;
    ofColor prevCPick;
    bool bPickingColor;
    bool bIxFadeToneTrigger;
    float ixFadeTone;
    
    ofPoint posWheelCenter;
    ofPoint currentTouch;
    ofPoint currentColorPickBoundedTouch;
    ofPoint posOnPixel;
    
    float distFromWheelCenter;
    
    
    
    ofImage bg;
    ofImage head;
    float bgRatio;
    ofxCenteredTrueTypeFont headFont;
    
    
    string placeholder[5] = {
        "tell me your secret",
        "what is your greatest struggle",
        "say something to someone far away",
        "give an advice to a large group of people",
        "tell me the name of person you love the most"
    };
};


