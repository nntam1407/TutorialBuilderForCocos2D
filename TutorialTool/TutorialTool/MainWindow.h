//
//  MainWindow.h
//  TutorialTool
//
//  Created by User on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TutorialSpriteLib.h"
#import "TutorialAnimationTimeLine.h"
#import "ActionSequencePropertiesViewController.h"
#import "ActionEditPropertiesViewController.h"
#import "ReferenceWindowController.h"
#import "PSMTabBarControl.h"

enum {
    EDIT_MODE_MOVE_OBJECT = 0,
    EDIT_MODE_MOVE_DEVICE,
    EDIT_MODE_MOVE_BACKGROUND
};

enum {
    COPY_OBJECT = 0,
    COPY_SEQUENCE,
    COPY_ACTION
};

@class TestTutorialController;

@interface MainWindow : NSObject <NSTableViewDataSource,NSTableViewDelegate, NSComboBoxDelegate, NSApplicationDelegate, NSTextViewDelegate, NSMenuDelegate, NSWindowDelegate, TutorialAnimationTimeLineDelegate, NSSplitViewDelegate>{
    
    TestTutorialController *tutorialCocosViewController;

    IBOutlet NSWindow *mainWindow;
    IBOutlet CCGLView	*mainGLView;
    
    //Panel control
    IBOutlet NSPanel *resoureManagerPanel;
    IBOutlet NSPanel *closeWarningMessagePanel;
    ReferenceWindowController *referenceWindowController;
    
    //Tool controls
    IBOutlet NSButton *buttonOpenXmlFile;
    IBOutlet NSButton *buttonEXportToXmlFile;
    IBOutlet NSButton *buttonBrowseBackground;
    IBOutlet NSButton *buttonResetBackground;
    
    //Tabbar controller
    IBOutlet PSMTabBarControl *mainTabbarControl;
    NSTabView* tabView;
    
    //-- Controls for iPhoneEdit area
    IBOutlet NSMenuItem *menuItemiPhone4_land;
    IBOutlet NSMenuItem *menuItemiPhone4_por;
    IBOutlet NSMenuItem *menuItemiPhone5_land;
    IBOutlet NSMenuItem *menuItemiPhone5_por;
    IBOutlet NSMenuItem *menuItemiPad_land;
    IBOutlet NSMenuItem *menuItemiPad_por;
    IBOutlet NSMenuItem *menuItemDeviceCustom;
    IBOutlet NSSegmentedControl *segmentZoomiPhone;
    IBOutlet NSTextField *textFieldTimeRunning;

    IBOutlet NSPanel *panelSetCustomDeviceResolution;
    IBOutlet NSTextField *textFieldCustomDeviceWidth;
    IBOutlet NSTextField *textFieldCustomDeviceHeight;
    
    //-- controls on toolbar
    IBOutlet NSToolbar *mainToolBar;
    IBOutlet NSToolbarItem *toolBarItemRunStoryboard;
    IBOutlet NSToolbarItem *toolBarItemAddObject;
    IBOutlet NSSegmentedControl *segmentedMouseTools;
    IBOutlet NSSegmentedControl *segmentedStoryboardTool;
    IBOutlet NSSegmentedControl *segmentedRunStoryboard;
    IBOutlet NSSegmentedControl *segmentedAddObject;
    IBOutlet NSSegmentedControl *segmentedManager;
    
    //-- control for right bar
    IBOutlet NSScrollView *scrollViewRightBar;
    IBOutlet NSView *viewEditObjectProperties;
    IBOutlet NSView *viewEditTextProperties;
    IBOutlet NSView *viewEditObjectView;
    IBOutlet NSView *viewListActionsInSequence;
    ActionSequencePropertiesViewController *viewEditActionSequence;
    ActionEditPropertiesViewController *viewEditActionData;
    
    //-- Variables control for object in use
    IBOutlet NSColorWell *colorViewObject;
    IBOutlet NSTextField *txtObjName;
    IBOutlet NSTextField *txtObjPosX;
    IBOutlet NSTextField *txtObjPosY;
    IBOutlet NSTextField *txtObjAnchorX;
    IBOutlet NSTextField *txtObjAnchorY;
    IBOutlet NSTextField *txtObjScaleX;
    IBOutlet NSTextField *txtObjScaleY;
    IBOutlet NSTextField *txtObjRotation;
    IBOutlet NSTextField *txtObjColorR;
    IBOutlet NSTextField *txtObjColorG;
    IBOutlet NSTextField *txtObjColorB;
    IBOutlet NSTextField *txtObjOpacity;
    IBOutlet NSTextField *txtObjZ_index;
    IBOutlet NSTextField *txtObjTextWidth;
    IBOutlet NSTextField *txtObjTextHeight;
    IBOutlet NSComboBox *comboBoxListSystemFont;
    IBOutlet NSTextField *txtObjFontSize;
    IBOutlet NSTextField *txtObjTextContent;
    IBOutlet NSMatrix *radioObjVisible;
    
    IBOutlet NSTableView *tableViewListObjectInUse;
    
    IBOutlet NSMatrix *matrixUseSpriteOfFrameForObject;
    IBOutlet NSComboBox *comboBoxListObjectSprite;
    IBOutlet NSComboBox *comboBoxListObjectFrame;
    IBOutlet NSComboBox *comboBoxListNormalButtonSprite;
    IBOutlet NSComboBox *comboBoxListActiveButtonSprite;
    IBOutlet NSComboBox *comboBoxListNormalButtonFrame;
    IBOutlet NSComboBox *comboBoxListActiveButtonFrame;
    
    IBOutlet NSTextField *labelListObjectSprite;
    IBOutlet NSTextField *labelListObjectFrame;
    IBOutlet NSTextField *labelListNormalButtonSprite;
    IBOutlet NSTextField *labelListActiveButtonSprite;
    IBOutlet NSTextField *labelListNormalButtonFrame;
    IBOutlet NSTextField *labelListActiveButtonFrame;
    
    IBOutlet NSMatrix *matrixUseParticleName;
    IBOutlet NSComboBox *comboBoxListBasicParticle;
    IBOutlet NSComboBox *comboBoxListParticleFileName;
    
    IBOutlet NSTextField *labelListBasicParticleName;
    IBOutlet NSTextField *labelListParticleFile;
    
    // --Variable for resource manager
    IBOutlet NSImageView *imageViewAddImagePreview;
    IBOutlet NSTableView *tableViewListImageAdded;
    IBOutlet NSTextField *textFieldPlistFile;
    IBOutlet NSTableView *tableViewListPlistTextureAdded;
    
    IBOutlet NSTextField *textFieldParticleAdd;
    IBOutlet NSTableView *tableViewListParticleAdded;
    NSMutableArray *listParticleAdded;
        
    IBOutlet NSTextField *textFieldFontName;
    IBOutlet NSTableView *tableViewListFontName;
    NSMutableDictionary *dictSystemFonts;
    NSMutableArray *listFontNameAdded;

    IBOutlet NSButton *buttonBrowseImageFile;
    IBOutlet NSButton *buttonBrowseTexturePlistFile; 
    IBOutlet NSButton *buttonBrowseParticleFile;
    IBOutlet NSButton *buttonBrowseFontFile;
    
    //-- Variables control for Action squence view
    IBOutlet NSButton *buttonNewActionSequence;
    IBOutlet NSButton *buttonDeleteActionSequence;
    IBOutlet NSTableView *tableViewListActionSequence;
    
    //-- Variables control for Action view
    IBOutlet NSButton *buttonNewAction;
    IBOutlet NSButton *buttonDeleteAction;
    IBOutlet NSTableView *tableViewListActions;
    
    //-- Variables control for timeline view
    IBOutlet TutorialAnimationTimeLine *animationTimeLine;
    IBOutlet NSSlider *timeLineZoomSlider;
    
    /** Control for proccess undo, redo user action **/
    IBOutlet NSMenuItem *menuItemRedoAction;
    IBOutlet NSMenuItem *menuItemUedoAction;
    
    // -- All global varialble
    int autoSaveProjectDelayTime;
    
    int currentDeviceChoosed;
    int currentDeviceViewMode;
    CGSize currentCustomDeviceSize;
    float currentZoomEditorValue;
    
    NSString *backgroundUrl;
    
    BOOL isStoryRuning;
    
    int copyView;
    NSMutableDictionary *copyObject;
    NSMutableDictionary *copySequence;
    NSMutableDictionary *copyAction;
    
    NSMutableArray *listPlistResource;
    NSMutableDictionary *tutorial;
    
    NSString *oldObjectName;
    
    int index;
    int nextIndexOfNewStoryboard;
    
    NSMutableArray *listImageResourceAdded;
    NSString *fullPathOfImageBrowsedCacheBeforAdded;
    
    NSMutableArray *listDataForUndoUserAction;
    NSMutableArray *listDataForRedoUserAction;
    
    //variables for select story, action sequence, action and object
    int currentIndexOfStorySelected;
    int currentIndexObjectSelected;
    int currentIndexSequenceSelected;
    int currentIndexActionSelected;
    
    //global variables for timeLineView
    //Each member is a array list index for each screen
    NSMutableArray *listRowIndexOfAction;
    
    //Count z-index when new object will be added
    int zIndexCounter;
}

@property (nonatomic, retain) IBOutlet CCGLView	*mainGLView;
@property (retain, nonatomic) TestTutorialController *tutorialCocosViewController;
@property (nonatomic) int autoSaveProjectDelayTime;
@property (nonatomic) int currentDeviceChoosed;
@property (nonatomic) int currentDeviceViewMode;
@property (nonatomic) CGSize currentCustomDeviceSize;
@property (nonatomic) int currentIndexOfStorySelected;
@property (nonatomic) BOOL isCustomMovingPointRecording;
@property (nonatomic,retain) IBOutlet NSTextField *txtObjName;
@property (nonatomic,retain) NSString *backgroundUrl;
@property (nonatomic,retain) NSMutableDictionary *tutorial;
@property (nonatomic,retain) NSTableView *tableViewListObjectInUse;
@property (nonatomic, retain) IBOutlet NSSlider *timeLineZoomSlider;

@property (nonatomic, retain) ActionSequencePropertiesViewController *viewEditActionSequence;
@property (nonatomic, retain) ActionEditPropertiesViewController *viewEditActionData;
//@property (nonatomic) int editModeMouse;

#pragma mark -
#pragma mark GUI Functions

- (void) clearRightBar;
- (void) showEditBarForTextObject;
- (void) showEditBarForObject;
- (void) showSequenceActionEditRightBar;
- (void) showActionEditRightBar;
- (void) hideControlsWhenNoStory;
- (void) showControlWhenChooseStory;
- (void) redrawAnimationTimeLine;

#pragma mark -
#pragma mark Called by cocosScene Functions

- (void) updateTrackingMousePos:(CGPoint)_pos;
- (void) updateTimeRunning:(float)_timeValue;

#pragma mark -
#pragma mark Panel Controls

- (void) showAlertMessageWith:(NSWindow *)_window title:(NSString *)_title message:(NSString *)_message;
- (void) showPanelSetCustomDeviceResolution;
- (void) closePanelSetCustomDeviceResolution;
- (IBAction) panelCustomDeviceCancelButtonClicked:(id)sender;
- (IBAction) showCloseWarningMessage:(id)sender;
- (IBAction) showReferenceWindow:(id)sender;
- (void) closeReferenceWindow;

#pragma mark -
#pragma GUI - Device Functions

- (IBAction) changeDevice:(id)sender;
- (void) setcheckedMenuItemWithDeviceType:(int)_deviceType withViewMode:(int)_viewMode;
- (IBAction) segmentZoomiPhoneClick:(id)sender;
- (IBAction) createCustomDeviceClick:(id)sender;
- (IBAction) closeWarningMessagePanel:(id)sender;
- (IBAction) closeResoureManagerPanel:(id)sender;

#pragma mark -
#pragma mark Tutorial Data Functions

- (void) createDefaultTutorialData;
- (NSMutableDictionary *) createDeaultDataActionSequence;

#pragma mark -
#pragma mark Resource Manager, Background Functions

- (IBAction) addTexturePlist:(id)sender;
- (IBAction) removeTexturePlist:(id)sender;
- (IBAction) addImageResource:(id)sender;
- (IBAction) addParticleFile:(id)sender;
- (IBAction) addCustomFont:(id)sender;
- (void) registerAllFontAdded;
- (IBAction) browseSpriteFile:(id)sender;
- (void) fillListBasicParticleForComboBox;
- (void) copyAllResourceToCacheInPath:(NSString *)_filePath;
- (NSMutableArray *) getAllFrameNameOfListTexturePlistAdded;
- (void) fillParticleFileComboBox;
- (void) fillSystemFontComboBox;
- (IBAction)resetBackground:(id)sender;

#pragma mark -
#pragma mark PSMTabbar controller functions, delegate

- (void) setupTabbar;
- (void) addNewTabWithName:(NSString *)_tabName;
- (void) removeAllTabItem;

#pragma mark -
#pragma mark TableView Get - Set Data, Click, Event Functions

- (int) tableViewRowCountOfTextureResource;
- (NSString *) valueOfTableViewTextureResourceAtRow:(int)_rowIndex;
- (int) tableViewRowCountOfImageAdded;
- (NSString *) valueOfTableViewImageAddedAtRow:(int)_rowIndex;
- (int) tableViewRowCountOfFontAdded;
- (NSString *) valueOfTableViewFontAddedAtRow:(int)_rowIndex;
- (int) tableViewRowCountOfParticleAdded;
- (NSString *) valueOfParticleAddedAtRow:(int)_rowIndex;
- (IBAction) tableViewListActionClicked:(id)sender;
- (int) tableViewRowCountOfListFrame;
- (NSString *) valueOfTableViewListFrameAtRow:(int)_rowIndex;
- (int) tableViewRowCountOfFramesUsed;
- (NSString *) valueOfTableViewFramesUsed:(int)_rowIndex;
- (IBAction) tableViewListObjectInUsedClick:(id)sender;

/*
 *  Function call by AnimationTimeLine view controller, when right click on action
 *  Used in copy, paste, delete action functions on timeline
 */
- (void) timeLineSelectActionAtIndex:(int)_actIndex atSequenceIndex:(int)_seqIndex;

#pragma mark -
#pragma mark Toolbar And More Functions

- (IBAction) segmentRunStoryboardClicked:(id)sender;
- (IBAction) segmentAddObjectClicked:(id)sender;
- (IBAction) segmentChangeMouseEditMode:(id)sender;
- (IBAction) segmentManagerClicked:(id)sender;
- (IBAction) timeLineScaleUpdate:(id)sender;
- (void) runCurrentStoryboard;

#pragma mark -
#pragma mark Reload Data And GUI Functions

- (void) reloadStoryboardFromData:(NSMutableDictionary *)_data;
- (void) reloadPlistTextureFromData:(NSMutableDictionary *)_data;

#pragma mark -
#pragma mark Object GUI functions

- (IBAction) updateVisibleState:(id)sender;
- (IBAction) deleteSelectedObject:(id)sender;
- (void) changeColor:(id)sender;
- (void) updateObjectTextFieldsValueWithData:(NSMutableDictionary *)_objectData;
- (IBAction) changeObjectColor:(id)sender;
- (NSMutableDictionary*) getDataFromSelectedGUIObjectProperties;
- (BOOL) isObjectName:(NSString *)_name inArray:(NSArray *)_array;
- (void) selectObjectWithName:(NSString*)_name;
- (void) objectWithName:(NSString *)_objectName isMovingToPoint:(CGPoint)_point;
- (void) fillObjectSpriteComboBoxs;
- (void)setEnableControlWhenMatrixUseSpriteOrFrameClick;
- (IBAction) matrixUseSpriteOrFrameClick:(id)sender;
- (void) setSpriteControlsStateWithObjType:(NSString *)_objType;
- (IBAction) spriteComboBoxChangeSelected:(id)sender;
- (void) updateCurrentObjectSelectedWithPoint:(CGPoint)_point;
- (void) addNewObjectWithObjectData:(NSMutableDictionary *)_objectDictionary;
- (NSMutableArray *) getListObjectNameInStory:(int)_storyIndex;

#pragma mark -
#pragma mark Storyboard functions

- (IBAction) newStoryboardMenuClicked:(id)sender;
- (void) createNewStoryboard;
- (void) deleteStoryboardAtIndex:(int)_deleteIndex;
- (void) changeSelectedStoryboard;

#pragma mark -
#pragma mark Action Sequences Function

- (IBAction) createNewActionSequence:(id)sender;
- (IBAction) deleteActionSequence:(id)sender;
- (void) updateActionSequenceConfig:(NSMutableDictionary *)_actionSequenceData sequenceIndex:(int)_sequenceIndex storyIndex:(int)_storyIndex;
- (void) updateGUIWhenChangedSequence;
- (void) updateGUISequenceWhenChangeConfig;
- (void) changeAllActionTargetName:(NSString *)_oldName byName:(NSString *)_newName;

#pragma mark -
#pragma mark Action Function

- (IBAction) createNewAction:(id)sender;
- (IBAction) deleteAction:(id)sender;
- (IBAction) moveUpActionRow:(id)sender;
- (IBAction) moveDownActionRow:(id)sender;
- (void) updateActionWithData:(NSMutableDictionary *)_actData atIndex:(int)_actIndex atSeqIndex:(int)_seqIndex atStoryIndex:(int)_storyIndex;
- (void) updateGUIWhenChangedAction;
- (void) updateGUIWhenChangedActionConfig;

#pragma mark -
#pragma Timeline Delegates Implement

- (void) changeSequenceStartAfterTimeBy:(float)_deltaTime;
- (void) updateSequenceStartAfterTimeWith:(float)_value;
- (void) selectAction:(int)_actionIndex inSequence:(int)sequenceIndex inStory:(int)_storyIndex;
- (void) timeLineActionClickedProccess;
- (void) changeActionDurationBy:(float)_deltaTime;
- (void) updateActionDurationWith:(float)_durationTime;

#pragma mark -
#pragma mark Copy - Paste Functions

- (void) copySelectedObject;
- (void) copySelectedSequence;
- (void) copySelectedAction;
- (void) copyDataFrom:(NSMutableDictionary *)_source toDes:(NSMutableDictionary *)_des;
- (void) pasteSelectedObject;
- (void) pasteSelectedSequence;
- (void) pasteSelectedAction;
- (IBAction) copy:(id)sender;
- (IBAction) paste:(id)sender;
- (IBAction) menuDelete:(id)sender;
- (BOOL) validateMenuItem:(NSMenuItem *)menuItem;

#pragma mark -
#pragma mark User Undo - Redo And More Functions

- (void) saveCurrentStateDataForUndo;
- (void) saveCurrentStateDataForRedo;
- (IBAction) undoUserAction:(id)sender;
- (IBAction) redoUserAction:(id)sender;

#pragma mark -
#pragma mark Project Setting, Save, Open... Functions

- (IBAction) closeProject:(id)sender;
- (IBAction) exportXML:(id)sender;
- (IBAction) openXmlDataFile:(id)sender;
- (void) openProjectFileWithFileName:(NSString *)_fileName;
- (IBAction) loadProjectFromCache:(id)sender;
- (NSMutableDictionary *) readDataFromXmlFile:(NSString *)_xmlFile;
- (void) saveProjectFileWithNameWithoutExt:(NSString *)_fileNameWithoutExt withTutorialData:(NSMutableDictionary *)_data;
- (void) saveXML;
- (void) saveAllProjectFileWithFileNameWithouExt:(NSString *)fileNameWithoutExt;
- (void) autoSave;
- (void) saveToAutoSaveCache;

@end
