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
//    input.placeholder = 
    app->input = ([input.text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    cout << app->input << endl;
    
    int pickone = ofRandom(0, 4);
    input.placeholder = [NSString stringWithCString:app->placeholder[pickone].c_str()                                    encoding:[NSString defaultCStringEncoding]];
    
    ofxOscMessage m;
    m.setAddress("/inText");
    m.addStringArg(app->input);
//    m.addFloatArg(ofGetElapsedTimef());
    m.setAddress("/balloonOut");
    m.addIntArg(app->output);
    m.setAddress("/colorpick/r");
    m.addIntArg(app->cPick.r);
    m.setAddress("/colorpick/g");
    m.addIntArg(app->cPick.g);
    m.setAddress("/colorpick/b");
    m.addIntArg(app->cPick.b);
    app->sender.sendMessage(m);
    app->feedbackFlash = app->cPick;
    
    
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


//UITextField char limit
//from http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 50) ? NO : YES;
}

@end