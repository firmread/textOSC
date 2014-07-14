#include "ofApp.h"
#include "textView.h"
textView *txt;
//--------------------------------------------------------------
void ofApp::setup(){
    
    ofEnableAlphaBlending();
    ofSetCircleResolution(100);
    ofSetFrameRate(60);
//    ofSetOrientation(OF_ORIENTATION_90_LEFT);
    
    //balloon selection bar
    totalBalloon = 50;
    output = 0;
    
    bar.set(25, 25, ofGetWidth()-50, 50);
    currentBar = bar;
    currentBar.width = 0;
    
    bBarOn = false;
    bControlingBar = false;
    
    activatePanelRect.set(0, 0,  ofGetWidth(), 100);
    
    //osc
    sender.setup(HOST, PORT);
    
    
    txt = [[textView alloc] initWithNibName:@"textView" bundle:nil];
    [ofxiOSGetGLView() addSubview:txt.view];
    
//    bg.loadImage("bg.jpg");
    
    wheel.loadImage("wheel.png");
    head.loadImage("lights.png");
    cPick.set(255);
    prevCPick = cPick;
    posWheelCenter.set(ofGetWidth()/2 ,wheel.height/2);
    distFromWheelCenter = 0;
    ixFadeTone = 50;
    bIxFadeToneTrigger = false;
    bPickingColor = false;
    
    currentColorPickBoundedTouch = posWheelCenter;
//    bgRatio = bg.height/bg.width;
    
    
    headFont.loadFont("Avenir.ttc", 42);
    feedbackFlash.set(0);
}

//--------------------------------------------------------------
void ofApp::update(){
    output = ofMap(currentBar.width, 0, bar.width, 0, totalBalloon, true);
    
    if (output != prevOutput) {
//        ofxOscMessage m;
//        m.setAddress("/balloonOut");
//        m.addIntArg(output);
//        sender.sendMessage(m);
        cout << ofToString(output) << endl;
    }
    
    if (cPick != prevCPick) {
        
//        ofxOscMessage m;
//        m.setAddress("/colorpick/r");
//        m.addIntArg(cPick.r);
//        m.setAddress("/colorpick/g");
//        m.addIntArg(cPick.g);
//        m.setAddress("/colorpick/b");
//        m.addIntArg(cPick.b);
//        sender.sendMessage(m);
        bIxFadeToneTrigger = true;
    }
    
    prevCPick  = cPick;
    prevOutput = output;
    
    
    posOnPixel.set(wheel.width/2, wheel.height/2);
    
    if (bCallingPanel) {
        holdDelay++;
    }
    else holdDelay = 0;
    
    if (holdDelay > 100) {
        bBarOn = true;
    }
    
    if (feedbackFlash.getBrightness() > 0){
        feedbackFlash.setBrightness(feedbackFlash.getBrightness()-5);
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofSetColor(255);
//    bg.draw(0,0,  bgRatio * ofGetHeight(), ofGetHeight());
//    bg.draw(0,0);
    
    ofSetColor(0, 150);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    ofColor dark(50);
    ofBackgroundGradient(dark, feedbackFlash);
    
    //colorwheel
    
    ofSetColor(255);
    ofSetRectMode(OF_RECTMODE_CENTER);
    wheel.draw(posWheelCenter);
    ofSetColor(255,200);
//    float headRatio = head.width/head.height;
//    head.draw(ofGetWidth()/2, 60, 350, 350/headRatio);
    ofSetRectMode(OF_RECTMODE_CORNER);
    headFont.drawStringCentered("Connecting Light", ofGetWidth()/2, 100);
    //        ofDrawBitmapStringHighlight(ofToString(distFromWheelCenter), posWheelCenter);
    

    if (bIxFadeToneTrigger) {
        ixFadeTone = 250;
        bIxFadeToneTrigger = false;
    }
    else ixFadeTone -= 20;
    
    if (ixFadeTone < 100) ixFadeTone = 100;
    
    ofSetColor(255, ixFadeTone);
    ofCircle(currentColorPickBoundedTouch, 20);
    
    ofSetColor(cPick);
    ofCircle(currentColorPickBoundedTouch, 15);
    
    if(bBarOn){
        ofSetColor(255,180);
        ofRect(bar);
        ofSetColor(100,180);
        ofRect(currentBar);
        ofSetColor(0);
        ofDrawBitmapStringHighlight(ofToString(output), ofGetWidth()/2-10, 50);
        
    }
}


void ofApp::grabColor(){
    ofPoint imgRelative(wheel.width/2, wheel.height/2);
    posOnPixel = currentTouch - posWheelCenter + imgRelative;
//    cout << posOnPixel.x << "." <<  posOnPixel.y << endl;
    
    unsigned char * pixels = wheel.getPixels();
    cPick.r = pixels[((int)posOnPixel.y*wheel.width + (int)posOnPixel.x)*4];
    cPick.g = pixels[((int)posOnPixel.y*wheel.width + (int)posOnPixel.x)*4+1];
    cPick.b = pixels[((int)posOnPixel.y*wheel.width + (int)posOnPixel.x)*4+2];
}

void ofApp::colorWheelClickCheck(){
    distFromWheelCenter = ofDist(posWheelCenter.x, posWheelCenter.y, currentTouch.x, currentTouch.y);
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    if (bar.inside(touch.x, touch.y)) {
        bControlingBar = true;
    }
    currentTouch.x = touch.x;
    currentTouch.y = touch.y;
    colorWheelClickCheck();
    if (distFromWheelCenter < 170) {
        //grab color,,,
        grabColor();
        currentColorPickBoundedTouch.set(touch.x, touch.y);

    }
    
    if (activatePanelRect.inside(touch.x, touch.y)) {
        bCallingPanel = true;
    }
    else bCallingPanel = false;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    if (bControlingBar &&
        touch.x > bar.x &&
        touch.x < bar.width+bar.x) {
        
        currentBar.width = touch.x -bar.x;
    }
    currentTouch.x = touch.x;
    currentTouch.y = touch.y;
    colorWheelClickCheck();
    if (distFromWheelCenter < 170) {
        //grab color,,,
        grabColor();
        currentColorPickBoundedTouch.set(touch.x, touch.y);
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
    if(bBarOn) bBarOn = false;
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
