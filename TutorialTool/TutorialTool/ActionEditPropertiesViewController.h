//
//  ActionEditPropertiesViewController.h
//  TutorialTool
//
//  Created by User on 11/9/12.
//
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_VIEW_FRAME_HEIGHT       55 //old 55

@class MainWindow;

@interface ActionEditPropertiesViewController : NSViewController <NSTableViewDataSource,NSTableViewDelegate, NSComboBoxDelegate, NSTextFieldDelegate> {
    
    MainWindow *mainWindow;
    
    NSMutableDictionary *currentActionData;
    int currentActionIndex;
    int currentSequenceIndex;
    int currentStoryIndex;
    
    BOOL isMovingPointRecord;
    NSMutableArray *listPointRecorded;
    
    int typeOfCurrentListActionsInComboBox;
    
    BOOL isChoosePoint;
    
    //All NSView
    IBOutlet NSView *viewFunctionName;
    IBOutlet NSView *viewDuration;
    IBOutlet NSView *viewJumps;
    IBOutlet NSView *viewOpacity;
    IBOutlet NSView *viewHeight;
    IBOutlet NSView *viewDestination;
    IBOutlet NSView *viewScale;
    IBOutlet NSView *viewAngle;
    IBOutlet NSView *viewRecordListPoint;
    IBOutlet NSView *viewAmlitututeStartEnd;
    IBOutlet NSView *viewAmlitute;
    IBOutlet NSView *viewMovingLoop;
    IBOutlet NSView *viewPositive;
    IBOutlet NSView *viewClockwise;
    IBOutlet NSView *viewInscrease;
    IBOutlet NSView *viewDistInterval;
    IBOutlet NSView *viewNumSpring;
    IBOutlet NSView *viewAnimationConfig;
    
    ////New Ease View    
    IBOutlet NSView *viewEaseType;
    IBOutlet NSView *viewPropertyEaseRate;
    IBOutlet NSView *viewPropertyEasePeriod;
    
    //all controll
    IBOutlet NSComboBox *comboBoxChooseActionType;
    IBOutlet NSTextField *textFieldDuration;
    IBOutlet NSTextField *textFieldDestination_X;
    IBOutlet NSTextField *textFieldDestination_Y;
    IBOutlet NSTextField *textFieldAngle;
    IBOutlet NSTextField *textFieldScaleX;
    IBOutlet NSTextField *textFieldScaleY;
    IBOutlet NSTextField *textFieldHeight;
    IBOutlet NSTextField *textFieldJumps;
    IBOutlet NSTextField *textFieldOpacity;
    IBOutlet NSTextField *textFieldCallFunctionName;
    
    IBOutlet NSTextField *textFieldStartAmlitute;
    IBOutlet NSTextField *textFieldEndAmlitute;
    IBOutlet NSTextField *textFieldAmlitute;
    IBOutlet NSTextField *textFieldMovingLoop;
    IBOutlet NSTextField *textFieldDistanceInterval;
    IBOutlet NSTextField *textFieldNumberSpring;
    IBOutlet NSComboBox *comboBoxPositive;
    IBOutlet NSComboBox *comboBoxClockwise;
    IBOutlet NSComboBox *comboBoxInscrease;
    
    IBOutlet NSButton *buttonRecordPoint;
    IBOutlet NSButton *buttonChoosePoint;
    
    IBOutlet NSTextField *textFieldFrameDelay;
    IBOutlet NSTableView *tableViewListFrameOfTexture;
    IBOutlet NSTextField *textFieldAnimationLoop;
    IBOutlet NSTextField *textFieldAnimationLoopDelay;
    IBOutlet NSTableView *tableViewFrameUsed;
    IBOutlet NSButton *checkBoxRestoreOriginalFrame;
    IBOutlet NSButton *buttonAddFrameToUsed;
    IBOutlet NSButton *buttonRemoveFrameFromUsed;
    
////New Ease Component
    IBOutlet NSComboBox *comboBoxEaseType;
    IBOutlet NSTextField *textFieldEaseRate;
    IBOutlet NSTextField *textFieldEasePeriod;
}

@property (nonatomic) BOOL isMovingPointRecord;
@property (nonatomic) BOOL isChoosePoint;
@property (nonatomic, retain) IBOutlet NSTextField *textFieldDuration;

-(id)initWithMainWindow:(MainWindow *)_mainWindow;

-(void)resetToDefaultView;
-(void)addNSViewControl:(NSView *)_view;
-(void)showControllWithActionName:(NSString *)_actionName;

-(void)resetValue;
-(void)bindDataWith:(NSMutableDictionary *)_actionData actionIndex:(int)_actionIndex sequenceIndex:(int)_seqIndex storyIndex:(int)_storyIndex;
-(void)updateDataFromGUI;
-(void)fillListActionNameForComboBox;
-(void)fillListEaseTypeForComboBox:(int)_actionType;
-(NSMutableDictionary *)getDefaultDataConfigs;
-(void)objectWithName:(NSString *)_objectName isMovingToPoint:(CGPoint)_point;

-(IBAction)restoreOriginalFrameChange:(id)sender;
-(IBAction)buttonRecordPointClicked:(id)sender;
-(IBAction)addFrameToListFrameUsed:(id)sender;
-(IBAction)removeFrameFromListFrameUsed:(id)sender;

-(void)changeDurationWith:(float)_delta;
-(void)updateDurationWith:(float)_durationTime;

-(void)changeSelectedActionType;
-(void)changeSelectedEaseType;

-(IBAction)buttonChoosePointClick:(id)sender;
-(void)setPointOfMouseClickedOnCocosView:(CGPoint)_point;

@end
