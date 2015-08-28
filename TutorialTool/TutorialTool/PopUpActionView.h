//
//  PopUpActionView.h
//  TutorialTool
//
//  Created by k3 on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopupActionViewController.h"


@interface PopUpActionView : NSView{
    
    PopupActionViewController *controller;
    
    IBOutlet NSTextFieldCell *actionName;
    
    NSPoint oldMousePosition;

}

@property (nonatomic,retain) PopupActionViewController *controller;

@end
