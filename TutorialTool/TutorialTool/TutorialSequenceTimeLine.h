//
//  TutorialSequenceTimeLine.h
//  TutorialTool
//
//  Created by k3 on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TutorialLibDefine.h"
#import "Helpers.h"

@class TutorialAnimationTimeLine;

@interface TutorialSequenceTimeLine : NSView{
    
    int sequenceIndex;
    
    NSMutableArray *listActionViews;
    
    TutorialAnimationTimeLine *handler;
    
    NSPoint oldMousePosition;
    
    BOOL dragMode;
}

@property (nonatomic) int sequenceIndex;

@property (nonatomic, retain) TutorialAnimationTimeLine *handler;
@property (nonatomic, retain) NSMutableArray *listActionViews;

- (id)initWithFrame:(NSRect)frame withActionSequenceData:(NSMutableDictionary *)_actionSequenceData withTimeLine:(TutorialAnimationTimeLine *)_handler;

-(void)drawActionTimeLineWithActionSequenceData:(NSMutableDictionary *)_actionSequenceData;

-(float)durationTimeFromActionData:(NSMutableDictionary *)_actionData;

-(void)moveSequenceTimeLineBy:(float)_deltaX;

-(void)expandAnimationTimeLineWithWidth:(float)_width;

-(void)moveAllActionsAfterAction:(int)_actionIndex by:(float)_deltaX;

-(void)moveScrollBarBy:(float)_delta;

@end
