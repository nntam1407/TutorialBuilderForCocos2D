//
//  TutorialAnimationTimeLine.m
//  TutorialTool
//
//  Created by k3 on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialAnimationTimeLine.h"
#import "TutorialData.h"
#import "TutorialLibDefine.h"
#import "TutorialSequenceTimeLine.h"
#import "TutorialActionTimeLine.h"
#import "PopUpActionView.h"

@implementation TutorialAnimationTimeLine

@synthesize delegate;
@synthesize animationView;
@synthesize tutorialData;
@synthesize currentStoryIndex;
@synthesize selectingActionIndex, selectingSequenceIndex,selectingObjectName;
@synthesize timeLineScaleSlider;
@synthesize listActionSequenceView, listSelectedActionsIndexes;
@synthesize sequenceYOffset;
@synthesize listRowIndexOfSequences;

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        NSRect animationFrame = self.frame;
        animationFrame.size.height -= 10;
        animationView = [[TutorialAnimationView alloc]initWithFrame:animationFrame];
        
        listActionSequenceView = [[NSMutableArray alloc] init];
        
        listSelectedActionsIndexes = [[NSMutableArray alloc]init];
        
        sequenceYOffset =[[NSMutableArray alloc]init];
        
        animationView.mainScrollView = self;
        
        [self setDocumentView:animationView];
        
        //[self setHasHorizontalRuler:YES];
        
        //[self setRulersVisible:YES];
        
        [self setScrollsDynamically:YES];
        
        [self setHasHorizontalScroller:YES];
        
        [self setHasVerticalScroller:YES];
        
 
        
        //[[self horizontalRulerView] setMeasurementUnits:@"Centimeters"];
        
        NSArray *upArray;
        
        NSArray *downArray;
        
        upArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0], nil];
        
        downArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.2],
                     nil];
        
        //        [NSRulerView registerUnitWithName:@"NewUnit" abbreviation:@"NU" unitToPointsConversionFactor:24 stepUpCycle:[NSArray arrayWithObject:upArray] stepDownCycle:downArray];
        
        [NSRulerView registerUnitWithName:@"Timeline"
         
                             abbreviation:@"TL"
         
             unitToPointsConversionFactor:TIMELINE_PIXEL_PER_UNIT
         
                              stepUpCycle:upArray stepDownCycle:downArray];
        
        [[self horizontalRulerView] setMeasurementUnits:@"Timeline"];
        
        //Add ruler
        NSRect documentFrame = [(NSView *)self.documentView frame];
        customRuler = [[CustomRuler alloc] initWithFrame:CGRectMake(0, 14, documentFrame.size.width, 14) withTimeLineHandler:self];
        [self addSubview:customRuler];
        
        //Add line ruler
        lineOfRuler = [[LineRuler alloc] initWithFrame:CGRectMake(0, 0, 8, self.frame.size.height)];
        [self addSubview:lineOfRuler];
        
        //Set default position of scrollview
        [[self documentView]scrollPoint:NSMakePoint(0, self.animationView.frame.size.height)];
        
        selectingSequenceIndex = -1;
        selectingActionIndex = -1;
        
        [[self contentView] setCopiesOnScroll:NO];
        
        // init list row index
        listRowIndexOfSequences = [[NSMutableArray alloc] init];
        
        actionInfoPopup = [[ActionInfoPopupViewController alloc] initWithAnimationTimeLine:self];        
    }
    
    return self;
}

- (void)drawActionSequenceDataWithTutorialData:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex withListRowIndex:(NSMutableArray *)_listRowIndex
{
    if(_storyIndex != currentStoryIndex)
    {
        selectingSequenceIndex = -1;
        selectingActionIndex = -1;
    }
    
    //set list row index
    listRowIndexOfSequences = _listRowIndex;
    
    tutorialData = _tutorialData;
    currentStoryIndex = _storyIndex;
    
    //redraw ruler line (in case change scale slider)
    [customRuler setNeedsDisplay:YES];
    
    //Clear old timeline
    [self clearTimeLine];
    [self setNeedsDisplay:YES];

    NSMutableArray *listActions = nil;
    
    //check to see if there is any story
    if(_storyIndex >= 0)
    {
        listActions = [TutorialData getListActionsWithStoryIndex:_storyIndex ofData:_tutorialData];
    
        for(int i = (int)listRowIndexOfSequences.count - 1; i >= 0; i--) {
            if(i >= (int)listActions.count) {
                [listRowIndexOfSequences removeObjectAtIndex:i];
            }
        }
    }
    
    //if listRowIndexOfSequences not have data (incase not open project, or project have no action before), we create default data for it: each sequence index is row index
    for(int i = 0 ;i < listActions.count; i++) {
        if(i >= listRowIndexOfSequences.count) {
            [listRowIndexOfSequences addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    if (listActions.count > 0){
        
        //resize the animation view's height to fit with all actions.
        float totalHeight = [ToolUtil getTotalHeightFromTutorialData:tutorialData withStoryIndex:currentStoryIndex] + 28;
        
        [ToolUtil expandView:animationView withWidh:0 andHeight:totalHeight];
        
        //create list sequence offset
                
        [self createListSequenceOffset];
        
        float sumHeight = 0;

        
        //for each action sequence, draw a sequence action timeline view 
        for (int i = 0; i < listActions.count; i++) {
            
            NSMutableDictionary *sequenceData = [listActions objectAtIndex:i];
            
            //get start after time from tutorial data
            float startTime = [[sequenceData objectForKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME] floatValue];
            
            float startDistance = startTime * roundf(TIMELINE_PIXEL_PER_UNIT * timeLineScaleSlider.doubleValue);
            
            NSMutableArray *listTutorialActions = [sequenceData objectForKey:@"ActionSequence"];
            
            float totalWidth = 0;
            
            sumHeight += [ToolUtil getHeightFromSequenceData:sequenceData];
            
            float startHeight = animationView.frame.size.height - sumHeight - 28;
            
            if (listTutorialActions.count > 0){
                
                NSMutableDictionary *actionData = [listTutorialActions objectAtIndex:0];
                    
                //get duration time from data
                float durationTime = [ToolUtil durationTimeFromActionData:actionData];
                    
                float actionViewWidth = durationTime * roundf(TIMELINE_PIXEL_PER_UNIT * timeLineScaleSlider.doubleValue);
                if (durationTime == 0){
                    actionViewWidth = 10;
                }
                    
                //create rect for action timeline view
                    
                NSRect actionRect = NSMakeRect(totalWidth + startDistance, startHeight, actionViewWidth , 10);
                    
                //calculate the total width of all created action timeline view
                totalWidth += actionViewWidth;
                    
                //create an action timeline view
                TutorialActionTimeLine *action = [[TutorialActionTimeLine alloc]initWithFrame:actionRect withActionData:actionData withSequenceTimeLine:self];
                    
                action.sequenceIndex = i;
//                action.actionIndex = 0;
                    
                [self.animationView addSubview:action];
                    
                [ToolUtil expandView:animationView withWidh:(totalWidth + startDistance) andHeight:0];
                
                [listActionSequenceView addObject:action];
            }
            
            //update postion of action on GUI right with row index
            //for(int i = 0 ;i < listActions.count; i++) {
                [self updateActionPositionWithActionSequenceIndex:i];
            //}
        }
    }
    
    if(actionInfoPopup.view.superview) {
        [actionInfoPopup.view removeFromSuperview];
    }
}

//clear all subviews
-(void)clearTimeLine
{
    
    for (NSView *view in listActionSequenceView){
            [view removeFromSuperview];
    }
    [listActionSequenceView removeAllObjects];
}


//scroll the main view by a deltaX and deltaY
-(void)scrollAnimationViewWithDeltaX:(float)_deltaX withDeltaY:(float)_deltaY
{
    //NSLog(@"abc = %f", self.contentView.bounds.origin.x);
    [[self contentView] scrollPoint:CGPointMake(self.contentView.bounds.origin.x + _deltaX, self.contentView.bounds.origin.y + _deltaY)];
}

- (void)drawRect:(NSRect)dirtyRect{
    
    [super drawRect:dirtyRect];
    // Drawing code here.
    
}


- (void)select:(int)_actionIndex inSequence:(int)sequenceIndex
{
    //Keep index of action is selecting
    selectingActionIndex = _actionIndex;
    selectingSequenceIndex = sequenceIndex;
    
    if([delegate respondsToSelector:@selector(selectAction:inSequence:)])
    {
        [delegate selectAction:_actionIndex inSequence:sequenceIndex];
    }
}

- (void)changeSelectActionDurationTimeBy:(float)_deltaTime
{
    if([delegate respondsToSelector:@selector(changeActionDurationBy:)])
    {
        [delegate changeActionDurationBy:_deltaTime];
    }
}

- (void)updateSelectActionDurationTimeWith:(float)_durationTime
{
    if([delegate respondsToSelector:@selector(updateActionDurationWith:)])
    {
        [delegate updateActionDurationWith:_durationTime];
    }
}

- (void)changeSelectSequenceStartAfterTimeBy:(float)_deltaTime {
    if([delegate respondsToSelector:@selector(changeSequenceStartAfterTimeBy:)])
    {
        [delegate changeSequenceStartAfterTimeBy:_deltaTime];
    }
}

- (void)updateSequenceStartAfterTimeWith:(float)_value
{
    if([delegate respondsToSelector:@selector(updateSequenceStartAfterTimeWith:)])
    {
        [delegate updateSequenceStartAfterTimeWith:_value];
    }
}

- (void)updateLineRulerPosition:(NSPoint)_point
{
    NSRect currentRulerLineFrame = lineOfRuler.frame;
    currentRulerLineFrame.origin.x = _point.x - 4;
    
    [lineOfRuler setFrame:currentRulerLineFrame];
}

- (void)updateLineRulerPosWithTime:(float)_time
{
    float timeLineScaleValue = roundf(TIMELINE_PIXEL_PER_UNIT * timeLineScaleSlider.doubleValue);

    float posX  = _time * timeLineScaleValue;
    
    NSRect scrollViewTimeLineVisibleRect = [self documentVisibleRect];
    NSRect currentRulerLineFrame = lineOfRuler.frame;

    if(posX >= currentRulerLineFrame.origin.x + scrollViewTimeLineVisibleRect.origin.x)
    {
        
        //When rulerLine closet right border of animationTimeLine (100px)
        if(currentRulerLineFrame.origin.x < self.frame.size.width - 100)
        {
            
            currentRulerLineFrame.origin.x = posX - scrollViewTimeLineVisibleRect.origin.x - 4;
            
        }
        else
        {
            
            if([self.documentView frame].size.width - scrollViewTimeLineVisibleRect.origin.x <= self.frame.size.width - self.verticalScroller.frame.size.width)
            {
                
                currentRulerLineFrame.origin.x = posX - scrollViewTimeLineVisibleRect.origin.x - 4;
                
            }
            else
            {
                
                //if the line is close to right border, we scroll animationTimeLine, and keep rulerLine stopping
                [[self contentView] scrollPoint:CGPointMake(self.contentView.bounds.origin.x + (posX - oldPosXOfRulerLineWhenRun), self.contentView.bounds.origin.y)];
            }
            
        }
        
        //set frame for ruler
        if(currentRulerLineFrame.origin.x + 4 <= self.frame.size.width - self.verticalScroller.frame.size.width)
        {
            [lineOfRuler setFrame:currentRulerLineFrame];
        }
        
        oldPosXOfRulerLineWhenRun = posX;
    }
}

/*****************************************
 * Proccess after edit action
 ****************************************/
-(void)doneEditAction:(TutorialActionTimeLine *)_action {
    int actionSequenceIndex = _action.sequenceIndex;
    
    //get the offset Y nearest to the action timeline view
    int index = [self pointAtSequenceOffset:_action.frame.origin];

    //add row index in list
    [listRowIndexOfSequences replaceObjectAtIndex:actionSequenceIndex withObject:[NSNumber numberWithInt:index]];
    
    //update right position of action by index
    [self updateActionPositionWithActionSequenceIndex:actionSequenceIndex];

}

-(int)pointAtSequenceOffset:(NSPoint)_point{
    for (int i = 0; i < sequenceYOffset.count; i ++){
        if (_point.y + 10 > [[sequenceYOffset objectAtIndex:i] floatValue]){
            return i;
        }
    }
    return -1;
}

-(void)updateActionPositionWithActionSequenceIndex:(int)_actionIndex {
    int rowIndex = [[listRowIndexOfSequences objectAtIndex:_actionIndex] intValue];
    
    TutorialActionTimeLine *actionView = [listActionSequenceView objectAtIndex:_actionIndex];
    
    if (rowIndex >= 0){
        [actionView setFrameOrigin:NSMakePoint(actionView.frame.origin.x, [[sequenceYOffset objectAtIndex:rowIndex] floatValue])];
        
        actionView.rowGUIIndex = rowIndex;
        
        //if not, set the action view at the bottom row
    }else{
        [actionView setFrameOrigin:NSMakePoint(actionView.frame.origin.x, [[sequenceYOffset objectAtIndex:sequenceYOffset.count - 1] floatValue])];
        
        actionView.rowGUIIndex = sequenceYOffset.count - 1;
    }
    
    NSMutableDictionary *actionData = [TutorialData getActionDataAtIndex:0 withActionSequenceIndex:actionView.sequenceIndex withStoryIndex:currentStoryIndex fromTutorialData:tutorialData];
    
    [actionData setObject:[NSString stringWithFormat:@"%d", (int)[TutorialData getListActionsWithStoryIndex:currentStoryIndex ofData:tutorialData].count - 1 - actionView.rowGUIIndex] forKey:TUTORIAL_ACTION_DATA_KEY_REORDER_OBJECT_Z_INDEX];
    
    //[TutorialData updateActionData:actionData atIndex:0 inActionSequenceIndex:actionView.sequenceIndex ofStoryIndex:currentStoryIndex inTutorialData:tutorialData];
    
    //Refix
    [self reorderOnRowAfterUpdatePos:actionView];
}

-(void)reorderOnRowAfterUpdatePos:(TutorialActionTimeLine *)_actionView {
    int loop =0;
    while ([self actionTimeLineViewCollideWith:_actionView] != nil){
        TutorialActionTimeLine *action = [self actionTimeLineViewCollideWith:_actionView];
        
        float actionViewRight = _actionView.frame.origin.x + _actionView.frame.size.width;
        
        float newXPosition = action.frame.origin.x - _actionView.frame.size.width;
        
        if (actionViewRight >= action.frame.origin.x + 10 &&
            _actionView.frame.origin.x < action.frame.origin.x && newXPosition > 0 && loop <= 1){
            [_actionView setFrameOrigin:NSMakePoint(newXPosition, _actionView.frame.origin.y)];
        }
        else{
            [_actionView setFrameOrigin:NSMakePoint(action.frame.origin.x + action.frame.size.width, _actionView.frame.origin.y)];
        }
        loop++;
    }

}

-(TutorialActionTimeLine *)actionTimeLineViewCollideWith:(TutorialActionTimeLine *)_actionView{
    float left = _actionView.frame.origin.x;
    
    float right = _actionView.frame.origin.x + _actionView.frame.size.width;
    

    
    for (TutorialActionTimeLine *actionView in listActionSequenceView){
        if (actionView != _actionView){
            float leftActionView = actionView.frame.origin.x;
            
            float rightActionView = actionView.frame.origin.x + actionView.frame.size.width;
            
            if (left < rightActionView && leftActionView < right && actionView.frame.origin.y == _actionView.frame.origin.y)
                return actionView;
        }
    }
    return nil;
}

-(void)showPopupInfoOfAction:(TutorialActionTimeLine *)_action withMouseEvent:(NSEvent *)theEvent {
    if(!actionInfoPopup.view.superview)
        [self addSubview:actionInfoPopup.view];
    
    NSRect popupRect = actionInfoPopup.view.frame;
    
    NSPoint mousePoint = [_action convertPoint:[theEvent locationInWindow] fromView:nil];
    mousePoint.x += _action.frame.origin.x - self.documentVisibleRect.origin.x;
    mousePoint.y = _action.frame.origin.y - self.documentVisibleRect.origin.y;
    mousePoint.y = self.frame.size.height - mousePoint.y - popupRect.size.height - _action.frame.size.height - 20;
    
    if(mousePoint.y - popupRect.size.height < -20) {
        mousePoint.y = mousePoint.y + popupRect.size.height + _action.frame.size.height + 10;
    }
    
    if(mousePoint.x + popupRect.size.width > self.frame.size.width - 10) {
        mousePoint.x = mousePoint.x - popupRect.size.width;
    }
    
    [actionInfoPopup.view setFrameOrigin:mousePoint];

    NSMutableDictionary *sequenceData = [TutorialData getActionDataFrom:tutorialData withStoryIndex:currentStoryIndex withActionIndex:_action.sequenceIndex];
    [actionInfoPopup bindData:sequenceData];
    
    if([delegate respondsToSelector:@selector(actionTimeLineMouseEnter:actionIndex:)]) {
        [delegate actionTimeLineMouseEnter:_action.sequenceIndex actionIndex:_action.actionIndex];
    }
}

-(void)hidePopupInfoOfAction:(TutorialActionTimeLine *)_action {
    [actionInfoPopup.view removeFromSuperview];
    
    if([delegate respondsToSelector:@selector(actionTimeLineMouseExit:actionIndex:)]) {
        [delegate actionTimeLineMouseExit:_action.sequenceIndex actionIndex:_action.actionIndex];
    }
}

-(void)selectActionTimelineWithTargetName:(NSString *)_targetName{
    [self unselectAllActionTimeline];
    NSMutableArray *listActionsIndex = [TutorialData getListIndexOfActionsWithStoryIndex:currentStoryIndex ofData:tutorialData withTargetName:_targetName];
    for (int i = 0; i < listActionsIndex.count; i++){
        int index = [[listActionsIndex objectAtIndex:i] intValue];
        TutorialActionTimeLine *actionView = [listActionSequenceView objectAtIndex:index];
        actionView.selectState = ACTION_TIMELINE_SAME_TARGET_SELECT_STATE;
    }
    [self setNeedsDisplay:YES];
}


-(void)unselectAllActionTimeline{
    for (int i = 0; i < listActionSequenceView.count; i++){
        TutorialActionTimeLine *actionView = [listActionSequenceView objectAtIndex:i];
        actionView.selectState=ACTION_TIMELINE_UNSELECT_STATE;
    }
    [self setNeedsDisplay:YES];
}

-(void)createListSequenceOffset{
    [sequenceYOffset removeAllObjects];
    
    //get list action from tutorial data
    NSMutableArray *listActions = [TutorialData getListActionsWithStoryIndex:currentStoryIndex ofData:tutorialData];
    
    if (listActions.count > 0){
        float sumHeight = 0;
        for(int i = 0; i < listActions.count; i++) {
            
            //get action sequence data
            NSMutableDictionary *sequenceData = [listActions objectAtIndex:i];
            
            sumHeight += [ToolUtil getHeightFromSequenceData:sequenceData];
            
            float startHeight = animationView.frame.size.height - sumHeight - 28;
            
            [sequenceYOffset addObject:[NSNumber numberWithFloat:startHeight]];
        }
    }
}


-(void)selectAllActionInRect:(NSRect)_rect{
    /*[self unselectAllActionTimeline];
    [listSelectedActionsIndexes removeAllObjects];
    for (int i = 0; i < listActionSequenceView.count; i++){
        TutorialActionTimeLine *actionView = [listActionSequenceView objectAtIndex:i];
        
        if ([ToolUtil isRect:actionView.frame hasPartsInRect:_rect]){
            
            actionView.selectState = ACTION_TIMELINE_SELECT_STATE;
            
            [listSelectedActionsIndexes addObject:[NSNumber numberWithInt:actionView.sequenceIndex]];
            
        }
    }
    
    NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"intValue" ascending:YES];
    
     [listSelectedActionsIndexes sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];*/
}


#pragma mark Mouse event

-(void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"Animation time line mouse down");
    
    [self select:0 inSequence:-1];
    [self unselectAllActionTimeline];
    [self selectActionTimelineWithTargetName:selectingObjectName];
}

-(void)rightMouseDown:(NSEvent *)theEvent {
    [super rightMouseDown:theEvent];
    
    NSLog(@"Animation time line right mouse down");
    
    [self select:0 inSequence:-1];
}


-(void)dealloc{
    
    [animationView removeFromSuperview];
    [animationView release];
    animationView = nil;
    
    [super dealloc];
}
@end
