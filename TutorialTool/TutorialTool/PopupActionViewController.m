//
//  PopupActionViewController.m
//  TutorialTool
//
//  Created by User on 11/7/12.
//
//

#import "PopupActionViewController.h"
#import "PopUpActionView.h"

@interface PopupActionViewController ()

@end

@implementation PopupActionViewController
@synthesize actionName;
@synthesize actionIndex;
@synthesize sequenceHandle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWith:(TutorialAnimationTimeLine *)_handle {
    self = [super initWithNibName:@"PopupActionViewController" bundle:nil];
    
    if(self) {
        
        sequenceHandle = _handle;
        PopUpActionView *actionView = (PopUpActionView *)self.view;
        actionView.controller = self;
        
//-->   display frame border, used to debug frame bug.        
//      [actionView setWantsLayer:YES];
//      actionView.layer.borderWidth = 1.0;
        
    }
    
    return self;
}

-(void)moveArrowImageToBottomLeft{
    [arrowImage setFrameOrigin:NSMakePoint(-15, arrowImage.frame.origin.y)];
}

@end
