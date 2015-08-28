//
//  ActionInfoPopupViewController.m
//  TutorialTool
//
//  Created by User on 11/28/12.
//
//

#import "ActionInfoPopupViewController.h"
#import "TutorialLibDefine.h"

@interface ActionInfoPopupViewController ()

@end

@implementation ActionInfoPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithAnimationTimeLine:(TutorialAnimationTimeLine *)_animationTimeline {
    self = [super initWithNibName:@"ActionInfoPopupViewController" bundle:nil];
    
    if(self) {
        handler = _animationTimeline;
    }
    
    return self;
}

- (void)bindData:(NSMutableDictionary *)_actionData {
    NSMutableDictionary *actionData = [[_actionData objectForKey:@"ActionSequence"] objectAtIndex:0];
    
    NSString *actionName = [actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    [textFieldActionName setStringValue:actionName];
    
    NSString *target = [_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    
    if([target isEqualToString:@""] || target == nil) {
        [textFieldTarget setStringValue:@"No target"];
    } else {
        [textFieldTarget setStringValue:target];
    }
    
    float startAt = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME] floatValue];

    float duration = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];

    [textFieldStartAt setStringValue:[NSString stringWithFormat:@"%.0f ms", startAt*1000]];

    if([actionName isEqualToString:TUTORIAL_ACTION_SHOW] || [actionName isEqualToString:TUTORIAL_ACTION_HIDE] || [actionName isEqualToString:TUTORIAL_ACTION_CALL_FUNCTION_IN_GAME] || [actionName isEqualToString:TUTORIAL_ACTION_PLACE])
    {
        [textFieldDuration setStringValue:@"None"];
    }
    else
    {
        if([actionName isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION])
        {
            NSMutableArray *listAnimationFrames = [actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_LIST_FRAMES];
            
            //float frameDelay = [[currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY ] floatValue];
            
            float frameDelay = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue];
            
            duration = frameDelay * (int)listAnimationFrames.count;
        }
        
        [textFieldDuration setStringValue:[NSString stringWithFormat:@"%.0f ms", duration*1000]];
    }
}

@end
