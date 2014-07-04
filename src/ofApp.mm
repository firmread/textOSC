#include "ofApp.h"
#include "textView.h"
textView *txt;
//--------------------------------------------------------------
void ofApp::setup(){
    
    ofEnableAlphaBlending();
    
    //balloon selection bar
    totalBalloon = 50;
    output = 0;
    
    bar.set(25, 25, ofGetWidth()-50, 50);
    currentBar = bar;
    currentBar.width = 0;
    
    bBarOn = false;
    bControlingBar = false;
    
    //osc
    sender.setup(HOST, PORT);
    
    
    txt = [[textView alloc] initWithNibName:@"textView" bundle:nil];
    [ofxiOSGetGLView() addSubview:txt.view];
}

//--------------------------------------------------------------
void ofApp::update(){
    output = ofMap(currentBar.width, 0, bar.width, 0, totalBalloon, true);
    
    if (output != prevOutput) {
        ofxOscMessage m;
        m.setAddress("/balloonOut");
        m.addIntArg(output);
        sender.sendMessage(m);
        cout << ofToString(output) << endl;
    }
    
    prevOutput = output;
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofColor dark(100);
    ofBackgroundGradient(dark, ofColor::black);
    
    if(bBarOn){
        ofSetColor(255,150);
        ofRect(bar);
        ofSetColor(100,150);
        ofRect(currentBar);
        
        ofSetColor(0);
        ofDrawBitmapStringHighlight(ofToString(output), ofGetWidth()/2-10, 50);
    }
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    if (bar.inside(touch.x, touch.y)) {
        bControlingBar = true;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    if (bControlingBar &&
        touch.x > bar.x &&
        touch.x < bar.width+bar.x) {
        
        currentBar.width = touch.x -bar.x;
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    if (bControlingBar) {
        bControlingBar = false;
    }
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    bBarOn = !bBarOn;
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
