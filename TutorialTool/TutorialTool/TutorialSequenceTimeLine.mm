//
//  TutorialSequenceTimeLine.m
//  TutorialTool
//
//  Created by k3 on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialSequenceTimeLine.h"
#import "TutorialActionTimeLine.h"
#import "TutorialAnimationTimeLine.h"
#import "TutorialData.h"
#import "PopupActionViewController.h"

@implementation TutorialSequenceTimeLine
@synthesize sequenceIndex;
@synthesize handler;
@synthesize listActionViews;

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        listActionViews = [[NSMutableArray alloc]init];
    }
    
    return self;
}


- (id)initWithFrame:(NSRect)frame withActionSequenceData:(NSMutableDictionary *)_actionSequenceData withTimeLine:(TutorialAnimationTimeLine *)_handler{
    self = [self initWithFrame:frame];
    if (self) {
        handler = _handler;
        
//-->    display frame border, used to debug frame bug.
//      [self setWantsLayer:YES];
//      self.layer.borderWidth = 1.0;
        
        [self drawActionTimeLineWithActionSequenceData:_actionSequenceData];
    }
    
    return self;
}

-(void)drawActionTimeLineWithActionSequenceData:(NSMutableDictionary *)_actionSequenceData{
    
    //get all actions in sequence data
    NSMutableArray *listTutorialActions = [_actionSequenceData objectForKey:@"ActionSequence"];
    
    float newHeight = [ToolUtil getHeightFromSequenceData:_actionSequenceData];
    
    if (newHeight > self.frame.size.height){
        [self setFrameSize:NSMakeSize(self.frame.size.width, newHeight)];
    }
    
    float totalWidth = 0;
    
    if (listTutorialActions.count > 0){
        
        for (int i = 0; i < listTutorialActions.count; i++){
            
            NSMutableDictionary *actionData = [listTutorialActions objectAtIndex:i];
            
            //get duration time from data
            float durationTime = [self durationTimeFromActionData:actionData];
            
            //create rect for action timeline view
            int extra = 0;
            if (durationTime == 0){

                PopupActionViewController *actionViewController = [[PopupActionViewController alloc]initWith:nil];
                
                [self addSubview:actionViewController.view];
                
                actionViewController.actionName.stringValue = [actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
                
                id previousAction = nil;
                
                if (i > 0){
                    previousAction =[listActionViews objectAtIndex:i-1] ;
                }
                
                float x = totalWidth - actionViewController.view.frame.size.width/2;
                
                if (x < self.frame.origin.x){
                    
                    x = self.frame.origin.x;
                    
                    [actionViewController moveArrowImageToBottomLeft];
                }

                if ([previousAction isKindOfClass:[PopupActionViewController class]]){
                    
                    PopupActionViewController *actionController = previousAction;
                    
                    [actionViewController.view setFrameOrigin:NSMakePoint(x, actionController.view.frame.origin.y + actionController.view.frame.size.height)];
                                                                            
                }else{
                    [actionViewController.view setFrameOrigin:NSMakePoint(x, 10)];
                }

                
                [listActionViews addObject:actionViewController];
                
                actionViewController.actionIndex = i;
                
                extra = actionViewController.view.frame.size.width;
            }
            else {
                NSRect actionRect = NSMakeRect(totalWidth, 0, durationTime * roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue) , 10);
                
                //calculate the total width of all created action timeline view
                totalWidth += durationTime * roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue);
                
                //create an action timeline view
                TutorialActionTimeLine *action = [[TutorialActionTimeLine alloc]initWithFrame:actionRect withActionData:actionData withSequenceTimeLine:nil];
                
                action.actionIndex = i;
                
                [handler.documentView addSubview:action];
                
                [listActionViews addObject:action];
            }
            
            
            if (self.frame.size.width < totalWidth + extra){
                //expand the width of the sequence time line view to fit the new action timeline view
                [self setFrameSize:NSMakeSize(totalWidth + extra, self.frame.size.height)];
            }
        }
    }
    
}

- (void)drawRect:(NSRect)dirtyRect{
    // Drawing code here.
}

//move the sequence time line view by deltaX
-(void)moveSequenceTimeLineBy:(float)_deltaX{
    
    NSPoint newPosition;
    
    if (self.frame.origin.x + _deltaX >= 0){
        
        newPosition = NSMakePoint(self.frame.origin.x + _deltaX, self.frame.origin.y );
        
        float width = self.frame.origin.x + self.frame.size.width;
            
        //expand the width of the mainview view to fit the sequence timeline view
        [self expandAnimationTimeLineWithWidth:width];
        
    }else{
        newPosition = NSMakePoint(0 , self.frame.origin.y );
        
    }
    
    //NSLog(@"x=%f, y=%f",newPosition.x, newPosition.y);
    
    [self setFrameOrigin:newPosition];
}


//move all action views after the specific view in the sequence time line view by deltaX
-(void)moveAllActionsAfterAction:(int)_actionIndex by:(float)_deltaX{
    
    for (int i = _actionIndex + 1; i < listActionViews.count; i++){
        id view = [listActionViews objectAtIndex:i];
        
        if ([view isKindOfClass:[TutorialActionTimeLine class]]){
            TutorialActionTimeLine *actionTimeline = view;
            
            [actionTimeline moveTimeLineBy:_deltaX];
        }else{
            PopupActionViewController *popup = view;
            [popup.view setFrameOrigin:NSMakePoint(popup.view.frame.origin.x + _deltaX, popup.view.frame.origin.y)];
        }
       
    }
    
    [self setFrameSize:NSMakeSize(self.frame.size.width + _deltaX, self.frame.size.height)];
    
    float width = self.frame.origin.x + self.frame.size.width + _deltaX;
    
    [self expandAnimationTimeLineWithWidth:width];
}

-(float)durationTimeFromActionData:(NSMutableDictionary *)_actionData{
    
    float duration = 0;
    NSString *actionType = [_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    //check if action is not animation
    if (![actionType isEqualToString:TUTORIAL_ACTION_RUN_ANIMATION]){
        //if the action is CCShow or CCHide, then return duration = 0
        if ([actionType isEqualToString:TUTORIAL_ACTION_SHOW] ||            
            [actionType isEqualToString:TUTORIAL_ACTION_HIDE] || [actionType isEqualToString:TUTORIAL_ACTION_CALL_FUNCTION_IN_GAME]){
            
            duration = 0;
            
        }else{
            duration = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DURATION] floatValue];
        }
        
    } else {
        // return duration for animation action
        NSMutableArray *animationFrames = [TutorialData getListFramesFromAnimationData:_actionData];
        
        float frameDelay = [[_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY] floatValue];
        
        duration = frameDelay * animationFrames.count;
    }
    
    return duration;
}


//<--expand the timeline view if the width is too wide
-(void)expandAnimationTimeLineWithWidth:(float)_width{
    if (handler.animationView.frame.size.width < _width){
        [handler.animationView setFrameSize:NSMakeSize(_width , handler.animationView.frame.size.height)];
    }
}

//scroll content view horizontally by a delta x
-(void)moveScrollBarBy:(float)_delta{
    [handler scrollAnimationViewWithDeltaX:_delta withDeltaY:0];
}

@end
