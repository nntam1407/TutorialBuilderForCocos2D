//
//  PopupActionViewController.h
//  TutorialTool
//
//  Created by User on 11/7/12.
//
//

#import <Cocoa/Cocoa.h>
#import "TutorialSequenceTimeLine.h"
#import "Helpers.h"
#import "TutorialAnimationTimeLine.h"

@class TutorialAnimationTimeLine;

@interface PopupActionViewController : NSViewController {
    TutorialSequenceTimeLine *sequenceHandle;
    
    IBOutlet NSTextFieldCell *actionName;
    IBOutlet NSImageView *arrowImage;
    
    NSPoint oldMousePosition;
    
    int mode;
    
    int actionIndex;
}

@property (nonatomic,retain) NSTextFieldCell *actionName;
@property (nonatomic) int actionIndex;
@property (nonatomic, retain) TutorialSequenceTimeLine *sequenceHandle;

-(id)initWith:(TutorialAnimationTimeLine *)_handle;
-(void)moveArrowImageToBottomLeft;
@end
