//
//  ActionInfoPopupViewController.h
//  TutorialTool
//
//  Created by User on 11/28/12.
//
//

#import <Cocoa/Cocoa.h>

@class TutorialAnimationTimeLine;

@interface ActionInfoPopupViewController : NSViewController {
    TutorialAnimationTimeLine *handler;
    
    IBOutlet NSTextField *textFieldActionName;
    IBOutlet NSTextField *textFieldTarget;
    IBOutlet NSTextField *textFieldStartAt;
    IBOutlet NSTextField *textFieldDuration;
}

- (id)initWithAnimationTimeLine:(TutorialAnimationTimeLine *)_animationTimeline;
- (void)bindData:(NSMutableDictionary *)_actionData;

@end
