//
//  textView.h
//  textOSC
//
//  Created by Firm Read on 7/4/14.
//
//
#pragma once
#import <UIKit/UIKit.h>

class ofApp;

@interface textView : UIViewController
@property(retain, nonatomic) IBOutlet UITextField *textField;
@end



//--------------------------------------------------------------


@interface textInput : UIViewController <UITextFieldDelegate>
@end