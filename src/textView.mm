//
//  textView.cpp
//  textOSC
//
//  Created by Firm Read on 7/4/14.
//
//

#include "textView.h"
#include "ofxiOSExtras.h"
#include "ofApp.h"

@implementation textView

ofApp *app;
textInput * txtIn;


-(void) viewDidLoad{
    app = (ofApp*)ofGetAppPtr();
    txtIn = [textInput alloc];
    self.textField.delegate = txtIn;
    
}
- (IBAction)textInput:(id)sender {
    UITextField * input = sender;
    app->input = ([input.text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    cout << app->input << endl;
    
    ofxOscMessage m;
    m.setAddress("/inText");
    m.addStringArg(app->input);
//    m.addFloatArg(ofGetElapsedTimef());
    app->sender.sendMessage(m);
}


- (void)dealloc {
    [_textField release];
    [super dealloc];
}


- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}

@end


@implementation textInput

//textView * txt;


- (void)viewDidLoad{
    
}

//CHECK IF RETURN IS PRESSED >> then CALL EditingDidEnd
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //    NSLog(@"You entered %@",textField.text);
    //    cout << "gotcha" << endl;
    [textField resignFirstResponder];
    return YES;
}

@end