//
//  TutorialAnimationTimeLine.h
//  TutorialTool
//
//  Created by k3 on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "TutorialToolDefine.h"
#import "ToolUtil.h"
#import "Helpers.h"
#import "LineRuler.h"
#import "CustomRuler.h"
#import "TutorialAnimationView.h"
#import "TutorialActionTimeLine.h"
#import "ActionInfoPopupViewController.h"

@protocol TutorialAnimationTimeLineDelegate <NSObject>

-(void)selectAction:(int)_actionIndex inSequence:(int)sequenceIndex;

-(void)changeActionDurationBy:(float)_deltaTime;
-(void)updateActionDurationWith:(float)_durationTime;

-(void)changeSequenceStartAfterTimeBy:(float)_deltaTime;

-(void)updateSequenceStartAfterTimeWith:(float)_value;

-(void)actionTimeLineMouseEnter:(int)_sequenceIndex actionIndex:(int)_actionIndex;
-(void)actionTimeLineMouseExit:(int)_sequenceIndex actionIndex:(int)_actionIndex;

@end

@interface TutorialAnimationTimeLine : NSScrollView {
    
    id<TutorialAnimationTimeLineDelegate> delegate;    
    
    TutorialAnimationView *animationView;
    
    NSMutableArray *listActionSequenceView;
    NSMutableArray *listSelectedActionsIndexes;
    NSMutableArray *sequenceYOffset;
    NSMutableDictionary *tutorialData;
    int currentStoryIndex;
    
    int selectingSequenceIndex;
    int selectingActionIndex;
    NSString* selectingObjectName;
    CustomRuler *customRuler;
    LineRuler *lineOfRuler;
    NSSlider *timeLineScaleSlider;
    
    
    float oldPosXOfRulerLineWhenRun;
    
    /*
     * Array contain row index of sequence will be drawed on Time line
     * Each object value of array is row index, and index of object in array is index of seuqence in tutorial data
     */
    NSMutableArray *listRowIndexOfSequences;

    ActionInfoPopupViewController *actionInfoPopup;
}

@property (nonatomic, retain) id<TutorialAnimationTimeLineDelegate> delegate;
@property (nonatomic, retain) NSView *animationView;
@property (nonatomic, retain) NSMutableDictionary *tutorialData;
@property (nonatomic, retain) NSMutableArray *listActionSequenceView;
@property (nonatomic, retain) NSMutableArray *listSelectedActionsIndexes;
@property (nonatomic, retain) NSMutableArray *sequenceYOffset;
@property (nonatomic) int currentStoryIndex;
@property (nonatomic) int selectingSequenceIndex;
@property (nonatomic) int selectingActionIndex;
@property (nonatomic,retain) NSString* selectingObjectName;
@property (nonatomic, retain) NSSlider *timeLineScaleSlider;
@property (nonatomic, retain) NSMutableArray *listRowIndexOfSequences;

- (void)drawActionSequenceDataWithTutorialData:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex withListRowIndex:(NSMutableArray *)_listRowIndex;

-(void)clearTimeLine;

-(void)scrollAnimationViewWithDeltaX:(float)_deltaX withDeltaY:(float)_deltaY;

-(void)select:(int)_actionIndex inSequence:(int)sequenceIndex;

-(void)changeSelectActionDurationTimeBy:(float)_deltaTime;
-(void)updateSelectActionDurationTimeWith:(float)_durationTime;

-(void)changeSelectSequenceStartAfterTimeBy:(float)_deltaTime;
-(void)updateSequenceStartAfterTimeWith:(float)_value;

-(void)updateLineRulerPosition:(NSPoint)_point;
-(void)updateLineRulerPosWithTime:(float)_time;

-(void)changeSelectSequenceStartAfterTimeBy:(float)_deltaTime;

-(TutorialActionTimeLine *)actionTimeLineViewCollideWith:(TutorialActionTimeLine *)_actionView;

//Show popup info of action
-(void)showPopupInfoOfAction:(TutorialActionTimeLine *)_action withMouseEvent:(NSEvent *)theEvent;
-(void)hidePopupInfoOfAction:(TutorialActionTimeLine *)_action;


-(void)updateActionPositionWithActionSequenceIndex:(int)_actionIndex;

-(void)reorderOnRowAfterUpdatePos:(TutorialActionTimeLine *)_actionView;

//Select state of action
-(void)selectActionTimelineWithTargetName:(NSString *)_targetName;
-(void)unselectAllActionTimeline;

-(void)createListSequenceOffset;

-(void)selectAllActionInRect:(NSRect)_rect;

/*****************************************
 * Proccess after edit action
 ****************************************/
-(void)doneEditAction:(TutorialActionTimeLine *)_action;

-(int)pointAtSequenceOffset:(NSPoint)_point;

@end
