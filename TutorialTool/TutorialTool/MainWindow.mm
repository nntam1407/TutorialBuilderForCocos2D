//
//  MainWindow.m
//  TutorialTool
//
//  Created by User on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainWindow.h"
#import "TutorialToolDefine.h"
#import "TutorialData.h"
#import "TutorialXMLExport.h"
#import "MovingInterpolationController.h"
#import "TutorialXMLDataParse.h"
#import "ToolUtil.h"
#import "TutorialAnimationTimeLine.h"
#import "ActionSequencePropertiesViewController.h"
#import "PopupActionViewController.h"
#import "TestTutorialController.h"

int editMouseMode;

@implementation MainWindow

@synthesize mainGLView;
@synthesize tutorialCocosViewController;
@synthesize autoSaveProjectDelayTime;
@synthesize currentDeviceChoosed, currentDeviceViewMode,currentCustomDeviceSize;
@synthesize isCustomMovingPointRecording;
@synthesize currentIndexOfStorySelected;
@synthesize backgroundUrl;
@synthesize txtObjName;
@synthesize timeLineZoomSlider;
@synthesize tutorial;
@synthesize tableViewListObjectInUse;
@synthesize viewEditActionData;
@synthesize viewEditActionSequence;


-(void)awakeFromNib{
    //set current resource path for this storyboard
    tutorialResourcePath = RESOURCE_CACHE_DIR;
    
    //Set default auto save delaytime
    autoSaveProjectDelayTime = 60;
    
    //Set delegate for animation timeline
    animationTimeLine.delegate = self;
    
    //clear cache of previous session
    [ToolUtil clearAllFilesExceptSubFoldersInPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], tutorialResourcePath]];
    
    index = 0;
    isCustomMovingPointRecording = NO;
    isStoryRuning = NO;
    
    currentZoomEditorValue = 1;
    currentDeviceChoosed = DEVICE_TYPE_IPHONE_4;
    currentDeviceViewMode = DEVICE_VIEW_MODE_LANDSCAPE;
    
    //default is size of iphone 4
    currentCustomDeviceSize = DEVICE_SIZE_IPHONE_4_LANDSCAPE; 
    
    //Set scale slider for animationTimeLine
    animationTimeLine.timeLineScaleSlider = timeLineZoomSlider;
    
    listImageResourceAdded = [[NSMutableArray alloc] init];
    listParticleAdded = [[NSMutableArray alloc] init];
    listFontNameAdded = [[NSMutableArray alloc] init];
    
    //get all system fonts from resource
    dictSystemFonts = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FontListTTF" ofType:@"plist"]];
    
    editMouseMode = EDIT_MODE_MOVE_OBJECT;    
    nextIndexOfNewStoryboard = 0;
    
    //Init view edit action sequence rightbar
    viewEditActionSequence = [[ActionSequencePropertiesViewController alloc] initWithMainWindow:self];
    viewEditActionData = [[ActionEditPropertiesViewController alloc] initWithMainWindow:self];
    
    // Fill all particle name is cocos supported
    [self fillListBasicParticleForComboBox];
    
    //set state of comboxBox choose sprite default for Sprite object
    [self setSpriteControlsStateWithObjType:TUTORIAL_OBJECT_TYPE_SPRITE];
    
    //clear all previous cache data
    [ToolUtil clearAllFilesExceptSubFoldersInPath:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:tutorialResourcePath]];
    
    //load list System Font
    [self fillSystemFontComboBox];
    [comboBoxListSystemFont selectItemWithObjectValue:@"Marker Felt"];
    
    //Create default tutorial data for this work session
    [self createDefaultTutorialData];
    
    /** Init for Undo, redo user action control **/
    listDataForUndoUserAction = [[NSMutableArray alloc] init];
    listDataForRedoUserAction = [[NSMutableArray alloc] init];
    
    //Save current data for undo to previous action
    [self saveCurrentStateDataForUndo];
    
    //Hide all control when no story
    [self hideControlsWhenNoStory];
    
    //Set auto save project to cache
    [self performSelector:@selector(autoSave) withObject:nil afterDelay:autoSaveProjectDelayTime];
    
    //Set default for variable index of story, object table, sequences, action
    currentIndexOfStorySelected = -1;
    currentIndexObjectSelected = -1;
    currentIndexSequenceSelected = -1;
    currentIndexActionSelected = -1;
    
    //set default list row index of actions
    listRowIndexOfAction = [[NSMutableArray alloc] init];
    
    // Tabbar controller
    [self setupTabbar];
    
    //Default add one story
    [self createNewStoryboard];
    
    //set list z-index count
    zIndexCounter = 0;
    
    buttonResetBackground.toolTip = @"Remove background!";
    
    [self matrixUseSpriteOrFrameClick:nil];
}

#pragma mark -
#pragma mark GUI Functions

/**
 * This function remove all edit view added to right scrollView toolbar before
 */
-(void)clearRightBar {    
    [viewEditTextProperties removeFromSuperview];
    [viewEditObjectView removeFromSuperview];
    [viewEditObjectProperties removeFromSuperview];
    
    [viewListActionsInSequence removeFromSuperview];
    
    [viewEditActionSequence.view removeFromSuperview];
    [viewEditActionData.view removeFromSuperview];
    
    [viewEditActionData resetValue];
    [viewEditActionSequence resetValue];
    
    //reset scroll ruler to default hieght
    NSRect scrollDocumentFrame = ((NSView *)scrollViewRightBar.documentView).frame;
    scrollDocumentFrame.size.height = RIGHT_BAR_DEFAULT_HEIGHT;
    
    [scrollViewRightBar.documentView setFrame:scrollDocumentFrame];
    [scrollViewRightBar.contentView scrollPoint:CGPointMake(0, RIGHT_BAR_DEFAULT_HEIGHT)];
}

-(void)showEditBarForTextObject {
    if(!viewEditActionData.isMovingPointRecord) {
        [self clearRightBar];
        
        NSRect scrollDocumentFrame = ((NSView *)scrollViewRightBar.documentView).frame;
        
        NSRect textEditRect = viewEditTextProperties.frame;
        textEditRect.origin = CGPointMake(0, scrollDocumentFrame.size.height - textEditRect.size.height);
        [viewEditTextProperties setFrame:textEditRect];
        [scrollViewRightBar.documentView addSubview:viewEditTextProperties];
        
        NSRect standardEditRect = viewEditObjectProperties.frame;
        standardEditRect.origin = CGPointMake(0, scrollDocumentFrame.size.height - standardEditRect.size.height - textEditRect.size.height);
        [viewEditObjectProperties setFrame:standardEditRect];
        [scrollViewRightBar.documentView addSubview:viewEditObjectProperties];
        
        //Show scroll ruler if too height
        float totalHeight = textEditRect.size.height + standardEditRect.size.height;
        
        if(totalHeight > scrollDocumentFrame.size.height)
        {
            scrollDocumentFrame.size.height = totalHeight;
            [scrollViewRightBar.documentView setFrame:scrollDocumentFrame];
            [scrollViewRightBar.contentView scrollPoint:CGPointMake(0, totalHeight)];
        }
    }
}

-(void)showEditBarForObject {    
    if(!viewEditActionData.isMovingPointRecord) {
        [self clearRightBar];
        
        NSRect scrollDocumentFrame = ((NSView *)scrollViewRightBar.documentView).frame;
        
        NSRect objectViewEditRect = viewEditObjectView.frame;
        objectViewEditRect.origin = CGPointMake(0, scrollDocumentFrame.size.height - objectViewEditRect.size.height);
        [viewEditObjectView setFrame:objectViewEditRect];
        [scrollViewRightBar.documentView addSubview:viewEditObjectView];
        
        NSRect standardEditRect = viewEditObjectProperties.frame;
        standardEditRect.origin = CGPointMake(0, scrollDocumentFrame.size.height - standardEditRect.size.height - objectViewEditRect.size.height);
        [viewEditObjectProperties setFrame:standardEditRect];
        [scrollViewRightBar.documentView addSubview:viewEditObjectProperties];
        
        //Show scroll ruler if too height
        float totalHeight = objectViewEditRect.size.height + standardEditRect.size.height;
        
        if(totalHeight > scrollDocumentFrame.size.height)
        {
            scrollDocumentFrame.size.height = totalHeight;
            [scrollViewRightBar.documentView setFrame:scrollDocumentFrame];
            [scrollViewRightBar.contentView scrollPoint:CGPointMake(0, totalHeight)];
        }
    }
}

-(void)showSequenceActionEditRightBar {
    [self clearRightBar];
    
    NSRect scrollDocumentFrame = ((NSView *)scrollViewRightBar.documentView).frame;
    
    NSRect actionSequenceViewEditRect = viewEditActionSequence.view.frame;
    actionSequenceViewEditRect.origin = CGPointMake(0, scrollDocumentFrame.size.height - actionSequenceViewEditRect.size.height);
    [viewEditActionSequence.view setFrame:actionSequenceViewEditRect];
    
    NSRect listActionViewEditRect = viewListActionsInSequence.frame;
    listActionViewEditRect.origin = CGPointMake(0, scrollDocumentFrame.size.height - actionSequenceViewEditRect.size.height - listActionViewEditRect.size.height - 20);
    [viewListActionsInSequence setFrame:listActionViewEditRect];
    
    [scrollViewRightBar.documentView addSubview:viewEditActionSequence.view];
    //[scrollViewRightBar.documentView addSubview:viewListActionsInSequence];
}

-(void)showActionEditRightBar {
    //If call it again to redaw in case change action type, we should remove it first
    [viewEditActionData.view removeFromSuperview];
    
    NSRect sequenceEditGUI = viewEditActionSequence.view.frame;
    
    NSRect actionViewEditRect = viewEditActionData.view.frame;
    actionViewEditRect.origin = CGPointMake(0, sequenceEditGUI.origin.y - actionViewEditRect.size.height);
    
    [viewEditActionData.view setFrame:actionViewEditRect];
    [scrollViewRightBar.documentView addSubview:viewEditActionData.view];
    
    //Show scroll ruler if too height
    NSRect scrollDocumentFrame = ((NSView *)scrollViewRightBar.documentView).frame;
    float totalHeight = sequenceEditGUI.size.height + actionViewEditRect.size.height;
    
    if(totalHeight > scrollDocumentFrame.size.height)
    {
        scrollDocumentFrame.size.height = totalHeight;
        [scrollViewRightBar.documentView setFrame:scrollDocumentFrame];
        [scrollViewRightBar.contentView scrollPoint:CGPointMake(0, totalHeight)];
    }
}

-(void)hideControlsWhenNoStory {
    [self clearRightBar];
    
    [segmentedAddObject setEnabled:false];
    [segmentedManager setEnabled:false];
    
    //disable segment run-stop story
    [segmentedRunStoryboard setEnabled:false];
    
    [tableViewListActionSequence setEnabled:false];
    [tableViewListObjectInUse setEnabled:false];
    
    [buttonDeleteActionSequence setEnabled:false];
    [buttonNewActionSequence setEnabled:false];
    [buttonEXportToXmlFile setEnabled:false];
}

-(void)showControlWhenChooseStory {
    [segmentedAddObject setEnabled:true];
    [segmentedManager setEnabled:true];
    
    //enable segment run-stop story
    [segmentedRunStoryboard setEnabled:true];
    
    [tableViewListActionSequence setEnabled:true];
    [tableViewListObjectInUse setEnabled:true];
    
    [buttonDeleteActionSequence setEnabled:true];
    [buttonNewActionSequence setEnabled:true];
    [buttonEXportToXmlFile setEnabled:true];
}

-(void)redrawAnimationTimeLine {
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    [animationTimeLine drawActionSequenceDataWithTutorialData:tutorial withStoryIndex:storyIndex withListRowIndex:[listRowIndexOfAction objectAtIndex:storyIndex]];
}

#pragma mark -
#pragma mark Called by cocosScene Functions

/**
 * This function show position value of mouse when it moving on Cocos Scene
 */
-(void)updateTrackingMousePos:(CGPoint)_pos {
    
}

-(void)updateTimeRunning:(float)_timeValue {
    //Update ruler of timeLine
    [animationTimeLine updateLineRulerPosWithTime:_timeValue];
    
    NSString *timeRunning = [ToolUtil getFormatTimeString:_timeValue];
    
    textFieldTimeRunning.stringValue = timeRunning;
}

#pragma mark -
#pragma mark Panel Controls

-(void)showAlertMessageWith:(NSWindow *)_window title:(NSString *)_title message:(NSString *)_message {
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:_title];
    [alert setInformativeText:_message];
    [alert beginSheetModalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
    
    [alert release];
}

-(void)showPanelSetCustomDeviceResolution {
    //Show current size on textfields
    [textFieldCustomDeviceWidth setStringValue:[NSString stringWithFormat:@"%d", (int)currentCustomDeviceSize.width]];
    
    [textFieldCustomDeviceHeight setStringValue:[NSString stringWithFormat:@"%d", (int)currentCustomDeviceSize.height]];
    
    [NSApp beginSheet:panelSetCustomDeviceResolution modalForWindow:mainWindow modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
}

-(void)closePanelSetCustomDeviceResolution {
    [NSApp endSheet:panelSetCustomDeviceResolution];
    [panelSetCustomDeviceResolution orderOut:self];
}

-(IBAction)panelCustomDeviceCancelButtonClicked:(id)sender {
    [self closePanelSetCustomDeviceResolution];
}

-(IBAction)showCloseWarningMessage:(id)sender {
    [NSApp beginSheet:closeWarningMessagePanel modalForWindow:mainWindow modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
}

-(IBAction)showReferenceWindow:(id)sender {
    if(!referenceWindowController) {
        referenceWindowController = [[ReferenceWindowController alloc] initWithMainWindow:self];
    }
    
    [referenceWindowController setGUIValue];
    
    [NSApp beginSheet:referenceWindowController.window modalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

-(void)closeReferenceWindow {
    [NSApp endSheet:referenceWindowController.window];
    [referenceWindowController.window orderOut:self];
}

#pragma GUI - Device Functions

-(IBAction)changeDevice:(id)sender {    
    int menuItemTag = (int)[(NSMenuItem *)sender tag];
    
    switch (menuItemTag) {
        case 0:
            [tutorialCocosViewController updateDevideWithType:DEVICE_TYPE_IPHONE_4 viewMode:DEVICE_VIEW_MODE_LANDSCAPE];
            
            currentDeviceChoosed = DEVICE_TYPE_IPHONE_4;
            currentDeviceViewMode = DEVICE_VIEW_MODE_LANDSCAPE;
            
            break;
        case 1:
            [tutorialCocosViewController updateDevideWithType:DEVICE_TYPE_IPHONE_4 viewMode:DEVICE_VIEW_MODE_PORTRAIL];
            
            currentDeviceChoosed = DEVICE_TYPE_IPHONE_4;
            currentDeviceViewMode = DEVICE_VIEW_MODE_PORTRAIL;
            
            break;
        case 2:
            [tutorialCocosViewController updateDevideWithType:DEVICE_TYPE_IPHONE_5 viewMode:DEVICE_VIEW_MODE_LANDSCAPE];
            
            currentDeviceChoosed = DEVICE_TYPE_IPHONE_5;
            currentDeviceViewMode = DEVICE_VIEW_MODE_LANDSCAPE;
            
            break;
        case 3:
            [tutorialCocosViewController updateDevideWithType:DEVICE_TYPE_IPHONE_5 viewMode:DEVICE_VIEW_MODE_PORTRAIL];
            
            currentDeviceChoosed = DEVICE_TYPE_IPHONE_5;
            currentDeviceViewMode = DEVICE_VIEW_MODE_PORTRAIL;
            
            break;
        case 4:
            [tutorialCocosViewController updateDevideWithType:DEVICE_TYPE_IPAD viewMode:DEVICE_VIEW_MODE_LANDSCAPE];
            
            currentDeviceChoosed = DEVICE_TYPE_IPAD;
            currentDeviceViewMode = DEVICE_VIEW_MODE_LANDSCAPE;
            
            break;
        case 5:
            [tutorialCocosViewController updateDevideWithType:DEVICE_TYPE_IPAD viewMode:DEVICE_VIEW_MODE_PORTRAIL];
            
            currentDeviceChoosed = DEVICE_TYPE_IPAD;
            currentDeviceViewMode = DEVICE_VIEW_MODE_PORTRAIL;
            
            break;
        case 6:
            [self showPanelSetCustomDeviceResolution];
            
            currentDeviceChoosed = DEVICE_TYPE_CUSTOM_RESOLUTION;
            currentDeviceViewMode = DEVICE_VIEW_MODE_PORTRAIL;
            break;
    }
    
    if(menuItemTag != DEVICE_TYPE_CUSTOM_RESOLUTION) {
        //Set check menuitem
        [self setcheckedMenuItemWithDeviceType:currentDeviceChoosed withViewMode:currentDeviceViewMode];
    }
}

-(void)setcheckedMenuItemWithDeviceType:(int)_deviceType withViewMode:(int)_viewMode {
    [menuItemiPhone4_land setState:0];
    [menuItemiPhone4_por setState:0];
    [menuItemiPhone5_land setState:0];
    [menuItemiPhone5_por setState:0];
    [menuItemiPad_land setState:0];
    [menuItemiPad_por setState:0];
    [menuItemDeviceCustom setState:0];
    
    if(_viewMode == DEVICE_VIEW_MODE_LANDSCAPE) {
        switch (_deviceType) {
            case DEVICE_TYPE_IPHONE_4:
                [menuItemiPhone4_land setState:1];
                break;
            case DEVICE_TYPE_IPHONE_5:
                [menuItemiPhone5_land setState:1];
                break;
            case DEVICE_TYPE_IPAD:
                [menuItemiPad_land setState:1];
                break;
            case DEVICE_TYPE_CUSTOM_RESOLUTION:
                [menuItemDeviceCustom setState:1];
                break;
        }
    } else {
        switch (_deviceType) {
            case DEVICE_TYPE_IPHONE_4:
                [menuItemiPhone4_por setState:1];
                break;
            case DEVICE_TYPE_IPHONE_5:
                [menuItemiPhone5_por setState:1];
                break;
            case DEVICE_TYPE_IPAD:
                [menuItemiPad_por setState:1];
                break;
            case DEVICE_TYPE_CUSTOM_RESOLUTION:
                [menuItemDeviceCustom setState:1];
                break;
        }
    }
    
}

-(IBAction)segmentZoomiPhoneClick:(id)sender {
    int segmentCellIndexClicked = (int)segmentZoomiPhone.selectedSegment;
    
    switch (segmentCellIndexClicked) {
        case 0:
            currentZoomEditorValue -= EDITOR_ZOOM_UNIT;
            if(currentZoomEditorValue < EDITOR_MIN_ZOOM)
                currentZoomEditorValue = EDITOR_MIN_ZOOM;
            
            break;
        case 1:
            currentZoomEditorValue = 1;
            
            break;
            
        case 2:
            currentZoomEditorValue += EDITOR_ZOOM_UNIT;
            
            if(currentZoomEditorValue > EDITOR_MAX_ZOOM)
                currentZoomEditorValue = EDITOR_MAX_ZOOM;
            
            break;
    }
    
    [tutorialCocosViewController zoomEditorWithValue:currentZoomEditorValue];
}

-(IBAction)createCustomDeviceClick:(id)sender {
    int width = (int)[textFieldCustomDeviceWidth.stringValue floatValue];
    int height = (int)[textFieldCustomDeviceHeight.stringValue floatValue];
    
    if(width != 0 && height != 0) {
        currentCustomDeviceSize = CGSizeMake(width, height);
    }
    
    [tutorialCocosViewController updateDevideType:DEVICE_TYPE_CUSTOM_RESOLUTION];
    
    //Close panel
    [self closePanelSetCustomDeviceResolution];
    
    //Set check menuitem
    [self setcheckedMenuItemWithDeviceType:currentDeviceChoosed withViewMode:currentDeviceViewMode];
}

-(IBAction)closeWarningMessagePanel:(id)sender {
    //hide close warning  message panel
    [NSApp endSheet:closeWarningMessagePanel];
    [closeWarningMessagePanel orderOut:sender];
}

-(IBAction)closeResoureManagerPanel:(id)sender {
    [NSApp endSheet:resoureManagerPanel];
    [resoureManagerPanel orderOut:sender];
}

#pragma mark -
#pragma mark Tutorial Data Functions

-(void)createDefaultTutorialData {
    tutorial = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *resource = [[NSMutableDictionary alloc] init];
    
    [TutorialData addResources:resource intoTutorialData:tutorial];
    
    NSMutableArray *listTextureResource = [[NSMutableArray alloc] init];
    [TutorialData addListTexturePlist:listTextureResource intoResourcesOfTutorialData:tutorial];
    
    NSMutableArray *storyboard = [[NSMutableArray alloc] init];
    [TutorialData addStoryboard:storyboard intoTutorialData:tutorial];
}

-(NSMutableDictionary *)createDeaultDataActionSequence {
    NSMutableDictionary *defaultData = [[NSMutableDictionary alloc] init];
    
    [defaultData setObject:[ToolUtil setString:txtObjName.stringValue] forKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    
    [defaultData setObject:listSequenceAction[0] forKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    [defaultData setObject:@"0" forKey:TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME];
    
    [defaultData setObject:@"1" forKey:TUTORIAL_ACTION_DATA_KEY_REPEAT];
    
    [defaultData setObject:@"0" forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_RATE];
    
    [defaultData setObject:@"0" forKey:TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD];
    
    NSMutableArray *listActionsData = [[NSMutableArray alloc] init];
    [defaultData setObject:listActionsData forKey:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
    
    return defaultData;
}

#pragma mark -
#pragma mark Resource Manager, Background Functions

-(IBAction)addTexturePlist:(id)sender {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *plistPath = textFieldPlistFile.stringValue;
    
    NSMutableDictionary *listFrameValue = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    if(listFrameValue) {            
        NSString *fileDir = [NSString stringWithFormat:@"%@/", [plistPath stringByDeletingLastPathComponent]];
        
        NSString *fileName = [plistPath stringByReplacingOccurrencesOfString:fileDir withString:@""];
        
        fileDir = [fileDir stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        
        NSString *desFilePath = [NSString stringWithFormat:@"%@/%@%@", resourcePath, RESOURCE_CACHE_DIR, fileName];
        
        //copy plist file into cache resource
        BOOL result =[ToolUtil copyFileFromSrc:plistPath toDes:desFilePath];
        
        if(result) {            
            //copy texture image of this plist to des
            NSString *textureImageName = nil;
            
            int plistTextureFormat = [[[listFrameValue objectForKey:@"metadata"] objectForKey:@"format"] intValue];
            
            if(plistTextureFormat == 2) {
                textureImageName = [[listFrameValue objectForKey:@"metadata"] objectForKey:@"realTextureFileName"];
            } else if(plistTextureFormat == 3) {
                
                textureImageName = [NSString stringWithFormat:@"%@.png", [fileName stringByDeletingPathExtension]];
            } else {
                NSString *textureFileName = [[[listFrameValue objectForKey:@"metadata"] objectForKey:@"target"] objectForKey:@"textureFileName"];
                
                NSString *textureFileExt = [[[listFrameValue objectForKey:@"metadata"] objectForKey:@"target"] objectForKey:@"textureFileExtension"];
                
                textureImageName = [NSString stringWithFormat:@"%@%@", textureFileName, textureFileExt];
            }
            
            NSString *srcTextureImage = [NSString stringWithFormat:@"%@%@", fileDir, textureImageName];
            
            NSString *desTextureImagePath = [NSString stringWithFormat:@"%@/%@%@", resourcePath, RESOURCE_CACHE_DIR, textureImageName];
            
            //copy plist file into cache resource
            result =[ToolUtil copyFileFromSrc:srcTextureImage toDes:desTextureImagePath];
            
            if(result) {
                [textFieldPlistFile setStringValue:@""];
                
                [TutorialData addTexturePath:fileName intoTextureListOfTutorialData:tutorial];
                
                [tableViewListPlistTextureAdded reloadData];
                
                [self fillObjectSpriteComboBoxs];
            } else {
                [self showAlertMessageWith:mainWindow title:@"Add resource fail!" message:@"Texture image file not found"];
            }
        }
    } else {
        [self showAlertMessageWith:mainWindow title:@"Add resource fail!" message:@"Texture plist file not found"];
    }
}

-(IBAction)removeTexturePlist:(id)sender {
    int textureIndex = (int)tableViewListPlistTextureAdded.selectedRow;
    
    if(textureIndex >= 0) {
        [TutorialData removeTexturePlistatIndex:textureIndex fromTutorialData:tutorial];
        
        [tableViewListPlistTextureAdded reloadData];
        
        [self fillObjectSpriteComboBoxs];
    }
}

-(IBAction)addImageResource:(id)sender {
    if(fullPathOfImageBrowsedCacheBeforAdded) {
        
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        
        NSString *fileDir = [NSString stringWithFormat:@"%@/", [fullPathOfImageBrowsedCacheBeforAdded stringByDeletingLastPathComponent]];
        
        fileDir = [fileDir stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        
        NSString *fileName = [fullPathOfImageBrowsedCacheBeforAdded stringByReplacingOccurrencesOfString:fileDir withString:@""];
        
        NSString *desFilePath = [NSString stringWithFormat:@"%@/%@%@", resourcePath, RESOURCE_CACHE_DIR, fileName];
        
        //copy file into cache resource
        BOOL result =[ToolUtil copyFileFromSrc:fullPathOfImageBrowsedCacheBeforAdded toDes:desFilePath];
        
        if(result) {            
            //remove image preview
            [imageViewAddImagePreview setImage:nil];
            
            //set null for full image path
            fullPathOfImageBrowsedCacheBeforAdded = nil;
            
            //add image name for list image resource
            [listImageResourceAdded addObject:fileName];
            
            [tableViewListImageAdded reloadData];
            
            [self fillObjectSpriteComboBoxs];
        }
    }
}

-(IBAction)addParticleFile:(id)sender {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *plistPath = textFieldParticleAdd.stringValue;
    
    NSString *fileDir = [NSString stringWithFormat:@"%@/", [plistPath stringByDeletingLastPathComponent]];
    
    fileDir = [fileDir stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    NSString *fileName = [plistPath stringByReplacingOccurrencesOfString:fileDir withString:@""];
    
    NSString *desFilePath = [NSString stringWithFormat:@"%@/%@%@", resourcePath, RESOURCE_CACHE_DIR, fileName];
    
    //copy plist file into cache resource
    BOOL result =[ToolUtil copyFileFromSrc:plistPath toDes:desFilePath];
    
    if(result) {            
        
        [textFieldParticleAdd setStringValue:@""];
        
        [listParticleAdded addObject:fileName];
        
        [tableViewListParticleAdded reloadData];
        
        [self fillParticleFileComboBox];
        
    }  else {
        [self showAlertMessageWith:mainWindow title:@"Add resource fail!" message:@"Particle file file not found"];
    }
}

-(IBAction)addCustomFont:(id)sender {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *fontPath = textFieldFontName.stringValue;
    
    NSString *fileDir = [NSString stringWithFormat:@"%@/", [fontPath stringByDeletingLastPathComponent]];
    
    fileDir = [fileDir stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    NSString *fileName = [fontPath stringByReplacingOccurrencesOfString:fileDir withString:@""];
    
    NSString *desFilePath = [NSString stringWithFormat:@"%@/%@%@", resourcePath, RESOURCE_CACHE_DIR, fileName];
    
    //copy plist file into cache resource
    BOOL result =[ToolUtil copyFileFromSrc:fontPath toDes:desFilePath];
    
    if(result) {            
        
        [textFieldFontName setStringValue:@""];
        
        [listFontNameAdded addObject:fileName];
        
        [tableViewListFontName reloadData];
        
        [comboBoxListSystemFont addItemWithObjectValue:[NSString stringWithFormat:@"(Custom)%@",fileName]];
        
        [self fillSystemFontComboBox];
        
        [ToolUtil registerUserFont:desFilePath];
        
    }  else {
        [self showAlertMessageWith:mainWindow title:@"Add resource fail!" message:@"Font file not found"];
    }
}

-(void)registerAllFontAdded {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    //file manager instance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for(int i = 0; i < listFontNameAdded.count; i++) {
        NSString *desFilePath = [NSString stringWithFormat:@"%@/%@%@", resourcePath, RESOURCE_CACHE_DIR, [listFontNameAdded objectAtIndex:i]];
        
        if([fileManager fileExistsAtPath:desFilePath]) {
            [ToolUtil registerUserFont:desFilePath];
        }
    }
}

-(IBAction)browseSpriteFile:(id)sender {
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    
    if(sender != buttonBrowseTexturePlistFile && sender != buttonBrowseParticleFile)
        fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", @"bmp", nil];
    else {
        fileTypesArray = [NSArray arrayWithObjects:@"plist", nil];
    }
    
    if(sender == buttonBrowseBackground) {
        fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", @"bmp", @"tmx", nil];
    }
    
    if(sender == buttonBrowseFontFile) {
        fileTypesArray = [NSArray arrayWithObjects:@"ttf", nil];
    }
    
    [openDlg setCanChooseFiles:YES];   
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:TRUE];
    [openDlg setAllowsMultipleSelection:NO]; //only choose 1 file
    
    [openDlg setDirectoryURL:[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0]];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    
    if ( [openDlg runModal] == NSOKButton ) {
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        // Loop through the files and process them.
        for(int i = 0; i < [files count]; i++ ) {      
            
            if(sender == buttonBrowseBackground) {
                backgroundUrl = [[NSString alloc] initWithString:[[files objectAtIndex:i] path]];
                
                [tutorialCocosViewController updateBackground];
                
            } else if(sender == buttonBrowseTexturePlistFile) {
                
                textFieldPlistFile.stringValue = [[files objectAtIndex:i] path];
                
            } else if(sender == buttonBrowseImageFile) {
                
                NSString *fullFilePath = [[files objectAtIndex:i] path];
                
                //save full path before add
                fullPathOfImageBrowsedCacheBeforAdded = [[NSString alloc] initWithString:fullFilePath];
                
                //preview image
                NSImage *imagePreview = [[NSImage alloc] initWithContentsOfFile:fullFilePath];
                [imageViewAddImagePreview setImage:imagePreview];
                [imagePreview release];
                
            } else if(sender == buttonBrowseParticleFile) {
                
                textFieldParticleAdd.stringValue = [[files objectAtIndex:i] path];
                
            } else if(sender == buttonBrowseFontFile) {
                textFieldFontName.stringValue = [[files objectAtIndex:i] path];
            }
        }
    }
}

-(void)fillListBasicParticleForComboBox {    
    for(int i = 0; i < LIST_BASIC_PARTICLE_COUNT; i++) {
        [comboBoxListBasicParticle addItemWithObjectValue:[NSString stringWithFormat:@"%@", listBasicParticle[i]]];
    }
    
    //set default is first action in list
    [comboBoxListBasicParticle selectItemAtIndex:0];
}

/**
 * copy all resources in the file path to cache folder
 */
-(void)copyAllResourceToCacheInPath:(NSString *)_filePath {
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *resourceCachePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:RESOURCE_CACHE_DIR];
    
    //clear all cache before copy
    [ToolUtil clearAllFilesExceptSubFoldersInPath:resourceCachePath];
    
    NSString *filePath = [_filePath stringByDeletingLastPathComponent];
    
    filePath = [filePath stringByAppendingPathComponent:@"Resource"];
    
    BOOL isDirExists = [fileManager fileExistsAtPath:filePath];
    
    if (isDirExists){
        [ToolUtil copyFileFromSrc:filePath toDes:resourceCachePath];
    }
}

-(NSMutableArray *)getAllFrameNameOfListTexturePlistAdded {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSMutableArray *listTextureFile = [TutorialData getListTexturePlistFromTutorialData:tutorial];
    
    for(int i = 0; i < listTextureFile.count; i++) {
        NSString *resourceFilePathInCache = [NSString stringWithFormat:@"%@/%@%@", [[NSBundle mainBundle] resourcePath], RESOURCE_CACHE_DIR, [listTextureFile objectAtIndex:i]];
        
        NSMutableDictionary *dataValue = [NSMutableDictionary dictionaryWithContentsOfFile:resourceFilePathInCache];
        
        
        
        NSArray *listFrameKey = [[[dataValue objectForKey:@"frames"] allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        for(NSString *keyName in listFrameKey) {
            [result addObject:keyName];
        }
    }
    
    return result;
}

-(void)fillParticleFileComboBox {
    [comboBoxListParticleFileName removeAllItems];
    
    [comboBoxListParticleFileName addItemsWithObjectValues:listParticleAdded];
}

-(void)fillSystemFontComboBox {
    [comboBoxListSystemFont removeAllItems];
    
    [comboBoxListSystemFont addItemsWithObjectValues: [dictSystemFonts objectForKey:@"supportedFonts"]];
    
    //Add all font added by user
    for(int i = 0; i < (int)listFontNameAdded.count; i++) {
        NSString *fileName = [[listFontNameAdded objectAtIndex:i] stringByDeletingPathExtension];
        
        [comboBoxListSystemFont addItemWithObjectValue:[NSString stringWithFormat:@"(Custom)%@", fileName]];
    }
}

- (IBAction)resetBackground:(id)sender {
    backgroundUrl = nil;
    [tutorialCocosViewController updateBackground];
}

#pragma mark -
#pragma mark PSMTabbar controller functions, delegate

-(void)setupTabbar {
    // Create tabView
    tabView = [[NSTabView alloc] initWithFrame:NSMakeRect(0, 0, 500, 30)];
    [mainTabbarControl setTabView:tabView];
    [tabView setDelegate:mainTabbarControl];
    [mainTabbarControl setDelegate:self];
    
    // Settings for tabBar
    [mainTabbarControl setShowAddTabButton:YES];
    [mainTabbarControl setSizeCellsToFit:YES];
    [mainTabbarControl setUseOverflowMenu:YES];
    [mainTabbarControl setHideForSingleTab:NO];
    [mainTabbarControl setAllowsResizing:YES];
    [mainTabbarControl setAlwaysShowActiveTab:YES];
    [mainTabbarControl setAllowsScrubbing:YES];
    [mainTabbarControl setCanCloseOnlyTab:YES];
    
    [mainWindow setShowsToolbarButton:NO];
    
    NSButton *newTabButton = (NSButton *)[mainTabbarControl addTabButton];
    [newTabButton setTarget:self];
    [newTabButton setAction:@selector(createNewStoryboard)];
    [newTabButton setToolTip:@"Create new screen"];
}

-(void)addNewTabWithName:(NSString *)_tabName {
    NSTabViewItem *newTab = [[[NSTabViewItem alloc] initWithIdentifier:nil] autorelease];
    [newTab setLabel:_tabName];
    [tabView addTabViewItem:newTab];
    [tabView selectTabViewItem:newTab]; // this is optional, but expected behavior
}

-(void)removeAllTabItem {
    for(NSTabViewItem *tabItem in tabView.tabViewItems)
    {
        [tabView removeTabViewItem:tabItem];
    }
    
    [self changeSelectedStoryboard];
}

-(BOOL)tabView:(NSTabView *)aTabView shouldCloseTabViewItem:(NSTabViewItem *)tabViewItem {
    [self deleteStoryboardAtIndex:(int)[tabView indexOfTabViewItem:tabViewItem]];
    
    return NO;
}

-(void)tabView:(NSTabView*)tv didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    [self changeSelectedStoryboard];
}

- (BOOL)tabView:(NSTabView *)aTabView shouldDragTabViewItem:(NSTabViewItem *)tabViewItem fromTabBar:(PSMTabBarControl *)tabBarControl {
    return YES;
}

#pragma mark -
#pragma mark TableView Get - Set Data, Click, Event Functions

-(int)tableViewRowCountOfTextureResource {
    int rowCount = 0;
    
    rowCount = (int)[TutorialData getListTexturePlistFromTutorialData:tutorial].count;
    
    return rowCount;
}

-(NSString *)valueOfTableViewTextureResourceAtRow:(int)_rowIndex {
    NSString *value = @"";
    
    value = [TutorialData getTexturePlistFromTutorialData:tutorial atIndex:_rowIndex];
    
    return value;
}

-(int)tableViewRowCountOfImageAdded {
    int rowCount = 0;
    
    rowCount = (int)listImageResourceAdded.count;
    
    return rowCount;
}

-(NSString *)valueOfTableViewImageAddedAtRow:(int)_rowIndex {
    NSString *value = @"";
    
    value = [listImageResourceAdded objectAtIndex:_rowIndex];
    
    return value;
}

-(int)tableViewRowCountOfFontAdded {
    int rowCount = 0;
    
    rowCount = (int)listFontNameAdded.count;
    
    return rowCount;
}

-(NSString *)valueOfTableViewFontAddedAtRow:(int)_rowIndex {
    NSString *value = @"";
    
    value = [listFontNameAdded objectAtIndex:_rowIndex];
    
    return value;
}

-(int)tableViewRowCountOfParticleAdded {
    int rowCount = 0;
    
    rowCount = (int)listParticleAdded.count;
    
    return rowCount;
}

-(NSString *)valueOfParticleAddedAtRow:(int)_rowIndex {
    NSString *value = @"";
    
    value = [listParticleAdded objectAtIndex:_rowIndex];
    
    return value;
}

-(IBAction)tableViewListActionClicked:(id)sender {
    currentIndexActionSelected = (int)tableViewListActions.selectedRow;
    
    if(currentIndexOfStorySelected >= 0 && currentIndexActionSelected >= 0 && currentIndexSequenceSelected >= 0) {
        NSMutableDictionary *actionData = [TutorialData getActionDataAtIndex:currentIndexActionSelected withActionSequenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
        
        actionData = [[NSMutableDictionary alloc] initWithDictionary:actionData];
        
        //[self loadTextFieldOfActionWith:[actionData retain]];
        //[tableViewFrameUsed reloadData];
        
        [viewEditActionData bindDataWith:actionData actionIndex:currentIndexActionSelected sequenceIndex:currentIndexSequenceSelected storyIndex:currentIndexOfStorySelected];
        
        [self showActionEditRightBar];
    } else {
        //Just hide edit action. Still show edit action sequence and list action view
        [viewEditActionData.view removeFromSuperview];
    }
}

-(int)tableViewRowCountOfListFrame {
    return (int)[self getAllFrameNameOfListTexturePlistAdded].count;
}

-(NSString *)valueOfTableViewListFrameAtRow:(int)_rowIndex {
    NSMutableArray *allFrameName = [self getAllFrameNameOfListTexturePlistAdded];
    
    return [allFrameName objectAtIndex:_rowIndex];
}

-(int)tableViewRowCountOfFramesUsed {    
    if(currentIndexOfStorySelected >= 0 && currentIndexActionSelected >= 0 && currentIndexSequenceSelected >= 0) {
        NSMutableDictionary *actionData = [TutorialData getActionDataAtIndex:currentIndexActionSelected withActionSequenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
        
        NSMutableArray *listFrameUsed = [TutorialData getListFramesFromAnimationData:actionData];
        
        return (int)listFrameUsed.count;
    }
    
    return 0;
}

-(NSString *)valueOfTableViewFramesUsed:(int)_rowIndex {    
    if(currentIndexOfStorySelected >= 0 && currentIndexActionSelected >= 0 && currentIndexSequenceSelected >= 0) {
        NSMutableDictionary *actionData = [TutorialData getActionDataAtIndex:currentIndexActionSelected withActionSequenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
        
        NSMutableArray *listFrameUsed = [TutorialData getListFramesFromAnimationData:actionData];
        
        if(listFrameUsed.count > 0)
            return [listFrameUsed objectAtIndex:_rowIndex];
    }
    
    return nil;
}

-(IBAction)tableViewListObjectInUsedClick:(id)sender {
    currentIndexObjectSelected = (int)tableViewListObjectInUse.selectedRow;
    
    if (currentIndexObjectSelected >=0){
        int storySelectedIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        NSMutableDictionary *listObjectInUse = [TutorialData getListObjectsWithStoryIndex:storySelectedIndex ofData:tutorial];
        
        NSArray *keyValue = [[listObjectInUse allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSString *string = [keyValue objectAtIndex:currentIndexObjectSelected];
        
        txtObjName.stringValue = string;
        
        NSMutableDictionary *selectedObjectData = [TutorialData getObjectDataFrom:tutorial withStoryIndex:storySelectedIndex withObjectName:string];
        
        //Check type of object to show edit control on rightbar
        NSString *objectSelectedType = [selectedObjectData objectForKey:TUTORIAL_OBJECT_TYPE_KEY];
        
        if([objectSelectedType isEqualToString:TUTORIAL_OBJECT_TYPE_TEXT]) {
            [self showEditBarForTextObject];
        } else {
            [self showEditBarForObject];
        }
        
        [self updateObjectTextFieldsValueWithData:selectedObjectData];
        
        [tutorialCocosViewController showSelectedTutorialObjectWithName:txtObjName.stringValue fromData:tutorial atStoryIndex:storySelectedIndex];
        
        [animationTimeLine selectActionTimelineWithTargetName:string];
        animationTimeLine.selectingObjectName = string;
        
    } else {
        [self clearRightBar];
        [animationTimeLine unselectAllActionTimeline];
        
        //deselect object
        [tutorialCocosViewController showSelectedTutorialObjectWithName:nil fromData:tutorial atStoryIndex:currentIndexOfStorySelected];
    }
}

#pragma mark -
#pragma mark Toolbar And More Functions

-(IBAction)segmentRunStoryboardClicked:(id)sender {
    //run storyboard
    [self runCurrentStoryboard];
}

-(IBAction)segmentAddObjectClicked:(id)sender {
    //Clear rightbar
    [self clearRightBar];
    
    //Set all sprite and frame comboBox to default
    [comboBoxListObjectFrame setStringValue:@""];
    [comboBoxListNormalButtonFrame setStringValue:@""];
    [comboBoxListActiveButtonFrame setStringValue:@""];
    [comboBoxListObjectSprite setStringValue:@""];
    [comboBoxListActiveButtonSprite setStringValue:@""];
    [comboBoxListNormalButtonSprite setStringValue:@""];
    [comboBoxListBasicParticle setStringValue:@""];
    [comboBoxListParticleFileName setStringValue:@""];
    
    int segmentCellIndexClicked = (int)segmentedAddObject.selectedSegment;
    
//    int storyIndex = (int)comboBoxListStoryboard.indexOfSelectedItem;
    
    NSString *path;
    
    switch (segmentCellIndexClicked) {
        case 0:
            
            //sprite default data path
            path =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",RESOURCE_CACHE_DIR ,DEFAULT_PLIST_DATA_SPRITE]];
            break;
        case 1:
            
            //add button object
            path =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",RESOURCE_CACHE_DIR ,DEFAULT_PLIST_DATA_BUTTON]];
            break;
        case 2:
            
            //particle default data path
            path =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",RESOURCE_CACHE_DIR ,DEFAULT_PLIST_DATA_PARTICLE]];
            
            break;
        case 3:
            
            //text default data path
            path =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",RESOURCE_CACHE_DIR ,DEFAULT_PLIST_DATA_TEXT]];
            
            break;
    }
    
    NSMutableDictionary *objectDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [objectDictionary setValue:[NSString stringWithFormat:@"%d", zIndexCounter] forKey:TUTORIAL_OBJECT_PARAMETER_Z_INDEX];
    zIndexCounter++;
    
    [self addNewObjectWithObjectData:objectDictionary];
}

-(IBAction)segmentChangeMouseEditMode:(id)sender {
    int segmentSelectedIndex = (int)segmentedMouseTools.selectedSegment;
    
    if(segmentSelectedIndex == 0) {
        editMouseMode = EDIT_MODE_MOVE_OBJECT;
    } else if(segmentSelectedIndex == 1) {
        editMouseMode = EDIT_MODE_MOVE_DEVICE;
    } else if(segmentSelectedIndex == 2) {
        editMouseMode = EDIT_MODE_MOVE_BACKGROUND;
    }
}

-(IBAction)segmentManagerClicked:(id)sender {
    int segmentSelectedIndex = (int)segmentedManager.selectedSegment;
    
    if(segmentSelectedIndex == 0) {        
        [NSApp beginSheet:resoureManagerPanel modalForWindow:mainWindow modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
    }
}

-(IBAction)timeLineScaleUpdate:(id)sender {
    NSLog(@"%f", timeLineZoomSlider.doubleValue);
    
    [self redrawAnimationTimeLine];
}

-(void)runCurrentStoryboard {
    if(isStoryRuning) {
        isStoryRuning = NO;
        [segmentedRunStoryboard setSelectedSegment:1];
        
        [tutorialCocosViewController stopStoryboardIsRuning];
    } else {
        isStoryRuning = YES;
        [segmentedRunStoryboard setSelectedSegment:0];
        
        int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        if(storyIndex >= 0) {
            [tutorialCocosViewController runStoryboardWithTutorialData:tutorial atIndex:storyIndex];
        } else {
            isStoryRuning = NO;
            [segmentedRunStoryboard setSelectedSegment:1];
        }
    }
}

#pragma mark -
#pragma mark Reload Data And GUI Functions

-(void)reloadStoryboardFromData:(NSMutableDictionary *)_data {
    //[comboBoxListStoryboard removeAllItems];
    //[comboBoxListStoryboard setStringValue:@""];
    
    [self removeAllTabItem];
    
    NSMutableArray *listStorys = [TutorialData getListStoryboardFromData:_data];
    for(int i = 0; i < listStorys.count; i++) {
        //[comboBoxListStoryboard addItemWithObjectValue:[NSString stringWithFormat:@"Story %d", i]];
        [self addNewTabWithName:[NSString stringWithFormat:@"Screen %d", i]];
    }
    
    if(listStorys.count > 0) {
        nextIndexOfNewStoryboard = (int)listStorys.count;
        //[comboBoxListStoryboard selectItemAtIndex:0];
        [tabView selectTabViewItemAtIndex:0];
    }
}

-(void)reloadPlistTextureFromData:(NSMutableDictionary *)_data {
    NSMutableArray *listTextureFiles = [TutorialData getListTexturePlistFromTutorialData:_data];
    
    for(int i = 0; i < listTextureFiles.count; i++) {
        NSString *plistPath = [NSString stringWithFormat:@"%@%@",RESOURCE_CACHE_DIR, [listTextureFiles objectAtIndex:i]];
        
        NSMutableDictionary *listFrameValue = [NSMutableDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistPath]];
        
        if(listFrameValue) {
            
            [tableViewListPlistTextureAdded reloadData];
            
            [self fillObjectSpriteComboBoxs];
        } else {
            [self showAlertMessageWith:mainWindow title:@"Add resource fail!" message:[NSString stringWithFormat:@"Texture %@ not found", plistPath]];
        }
    }
}

#pragma mark -
#pragma mark Object GUI functions

-(IBAction)updateVisibleState:(id)sender{
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    NSArray *keyNames = [[TutorialData getListObjectsWithStoryIndex:storyIndex ofData:tutorial] allKeys];
    
    
    if ([self isObjectName:txtObjName.stringValue inArray:keyNames]){
        NSMutableDictionary *selectedObjectData = [self getDataFromSelectedGUIObjectProperties];
        
        //        [selectedObjectData setValue:txtObjName.stringValue forKey:@"Name"];
        
        [TutorialData updateObjectDataIn:tutorial byObjectData:selectedObjectData atStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
        
        //Save current state of data for undo
        [self saveCurrentStateDataForUndo];
        
        //update design view with storyboard selected
        [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
        
        //[self performSelector:@selector(test:) onThread:[[CCDirector sharedDirector] runningThread] withObject:tutorial waitUntilDone:YES];
    }
}

-(IBAction)deleteSelectedObject:(id)sender{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSWarningAlertStyle;
    [alert addButtonWithTitle:@"NO"];
    [alert addButtonWithTitle:@"YES"];
    alert.messageText = @"Want to Continue? All data will be deleted!";
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            NSLog (@"NO clicked");
            break;
        case NSAlertSecondButtonReturn: {
            if (![txtObjName.stringValue isEqualToString:@""]){
                
                //Clear rightbar
                [self clearRightBar];
                
                int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
                
                //int indexObject = tableViewListObjectInUse.selectedRow;
                [tutorialCocosViewController deselectedObject];
                
                [TutorialData removeObjectDataIn:tutorial atStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
                
                //Change all name of target in all seuqence which reference to
                [self changeAllActionTargetName:txtObjName.stringValue byName:@"None target"];
                
                [tableViewListObjectInUse reloadData];
                
                
                [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
                
                //Save current state of data for undo
                [self saveCurrentStateDataForUndo];
            }
            
            break;
        }
        default:
            break;
    }
    [alert release];
}

-(void)changeColor:(id)sender {
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    
    NSLog(@"%@", colorPanel.color);
}

// update textfield properties when an object is selected
- (void)updateObjectTextFieldsValueWithData:(NSMutableDictionary *)_objectData
{    
    txtObjPosX.stringValue = [NSString stringWithFormat:@"%d", [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY]].intValue];
    
    txtObjPosY.stringValue = [NSString stringWithFormat:@"%d", [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY]].intValue];
    
    txtObjAnchorX.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_X]];
    
    txtObjAnchorY.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_Y]];
    
    txtObjRotation.stringValue = [ToolUtil setString:[NSString stringWithFormat:@"%0.2f", [[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY] floatValue]]];
    
    NSString *visible = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_VISIBLE]];
    
    if ([visible isEqualToString:@"YES"])
    {
        [radioObjVisible selectCellAtRow:0 column:0];
    }
    else
    {
        [radioObjVisible selectCellAtRow:0 column:1];
    }
    
    txtObjScaleX.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY]];
    
    txtObjScaleY.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY]];
    
    txtObjColorR.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_R]];
    
    txtObjColorG.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_G]];
    
    txtObjColorB.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_B]];
    
    //set color for color picker
    float r = [txtObjColorR.stringValue intValue] / 255.0f;
    float g = [txtObjColorG.stringValue intValue] / 255.0f;
    float b = [txtObjColorB.stringValue intValue] / 255.0f;
    [colorViewObject setColor:[NSColor colorWithDeviceRed:r green:g blue:b alpha:1.0f]];
    
    txtObjOpacity.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_OPACITY]];
    
    txtObjZ_index.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_Z_INDEX]];
    
    //txtObjFont.stringValue = [self setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME]];
    //Check is it custom font
    //If it is custom font, we'll add (custom) prefix in to fontName get from objectData
    NSString *fontName = [_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME];
    
    for(int i = 0; i < listFontNameAdded.count; i++)
    {
        
        NSString *fontNameInListWithoutExt = [[listFontNameAdded objectAtIndex:i] stringByReplacingOccurrencesOfString:@".ttf" withString:@""];
        
        if([fontName isEqualToString:fontNameInListWithoutExt])
        {
            fontName = [NSString stringWithFormat:@"(Custom)%@", fontName];
            
            break;
        }
    }
    
    [comboBoxListSystemFont selectItemWithObjectValue:fontName];
    
    
    txtObjFontSize.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_SIZE]];
    
    txtObjTextContent.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_TEXT_CONTENT]];
    
    txtObjTextWidth.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY]];
    
    txtObjTextHeight.stringValue = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY]];
    
    NSString *objectType = [ToolUtil setString:[_objectData objectForKey:TUTORIAL_OBJECT_TYPE_KEY]];
    [self setSpriteControlsStateWithObjType: objectType];
    
    int isUseSpriteImageFile = [[_objectData objectForKey:TUTORIAL_OBJECT_IS_USE_SPRITE_FRAME] intValue];
    [matrixUseSpriteOfFrameForObject selectCellAtRow:0 column:isUseSpriteImageFile];
    
    int isUseParticleFile = [[_objectData objectForKey:TUTORIAL_OBJECT_IS_USE_PARTICLE_FILE] intValue];
    [matrixUseParticleName selectCellAtRow:0 column:isUseParticleFile];
    
    if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_SPRITE])
    {
        [comboBoxListObjectSprite selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_SPRITE_FILE_NAME]];
        
        [comboBoxListObjectFrame selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_SPRITE_FRAME_NAME]];
        
    }
    else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_BUTTON])
    {
        
        [comboBoxListNormalButtonSprite selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FILE_NAME]];
        
        [comboBoxListActiveButtonSprite selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FILE_NAME]];
        
        [comboBoxListNormalButtonFrame selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FRAME_NAME]];
        
        [comboBoxListActiveButtonFrame selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FRAME_NAME]];
        
    }
    else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_PARTICLE])
    {
        [comboBoxListBasicParticle selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_PARTICLE_NAME]];
        
        [comboBoxListParticleFileName selectItemWithObjectValue:[_objectData objectForKey:TUTORIAL_OBJECT_PARTICLE_CUSTOM_FILE_NAME]];
        
    }
    
    [self setEnableControlWhenMatrixUseSpriteOrFrameClick];
}

-(IBAction)changeObjectColor:(id)sender {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    [colorViewObject.color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSLog(@"%f, %f, %f, %f", red, green, blue, alpha);
    
    //Change GUI value
    txtObjColorR.stringValue = [NSString stringWithFormat:@"%d", (int)(red * 255)];
    txtObjColorG.stringValue = [NSString stringWithFormat:@"%d", (int)(green * 255)];
    txtObjColorB.stringValue = [NSString stringWithFormat:@"%d", (int)(blue * 255)];
    
    //update value of object data from GUI
    [self controlTextDidChange:nil];
}

- (NSMutableDictionary*) getDataFromSelectedGUIObjectProperties{
    
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    NSMutableDictionary *objectData = [TutorialData getObjectDataFrom:tutorial withStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
    
    [objectData setObject:[ToolUtil setString:txtObjPosX.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjPosY.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjAnchorX.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_X];
    
    [objectData setObject:[ToolUtil setString:txtObjAnchorY.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_Y];
    
    [objectData setObject:[ToolUtil setString:txtObjRotation.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjScaleX.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjScaleY.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjColorR.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_COLOR_R];
    
    [objectData setObject:[ToolUtil setString:txtObjColorG.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_COLOR_G];
    
    [objectData setObject:[ToolUtil setString:txtObjColorB.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_COLOR_B];
    
    [objectData setObject:[ToolUtil setString:txtObjOpacity.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_OPACITY];
    
    [objectData setObject:[ToolUtil setString:txtObjZ_index.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_Z_INDEX];
    
    //[objectData setObject:txtObjFont.stringValue forKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME];
    NSString *fontName = comboBoxListSystemFont.objectValueOfSelectedItem;
    
    if ([fontName rangeOfString:@"(Custom)"].location != NSNotFound){
        fontName = [fontName stringByReplacingOccurrencesOfString:@"(Custom)" withString:@""];
    }
    
    [objectData setObject:fontName forKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME];
    
    [objectData setObject:[ToolUtil setString:txtObjFontSize.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_FONT_SIZE];
    
    [objectData setObject:[ToolUtil setString:txtObjTextWidth.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjTextHeight.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY];
    
    [objectData setObject:[ToolUtil setString:txtObjTextContent.stringValue] forKey:TUTORIAL_OBJECT_PARAMETER_TEXT_CONTENT];
    
    if (radioObjVisible.selectedColumn == 0){
        [objectData setObject:@"YES" forKey:TUTORIAL_OBJECT_PARAMETER_VISIBLE];
    }else{
        [objectData setObject:@"NO" forKey:TUTORIAL_OBJECT_PARAMETER_VISIBLE];
    }
    
    NSString *objectType = [objectData objectForKey:TUTORIAL_OBJECT_TYPE_KEY];
    int useSpriteType = (int)matrixUseSpriteOfFrameForObject.selectedColumn;
    int isUseParticleName = (int)matrixUseParticleName.selectedColumn;
    
    [objectData setObject:[NSNumber numberWithInt:useSpriteType] forKey:TUTORIAL_OBJECT_IS_USE_SPRITE_FRAME];
    
    [objectData setObject:[NSNumber numberWithInt:isUseParticleName] forKey:TUTORIAL_OBJECT_IS_USE_PARTICLE_FILE];
    
    if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_SPRITE]) {
        
        if(comboBoxListObjectSprite.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListObjectSprite.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_SPRITE_FILE_NAME];
        
        if(comboBoxListObjectFrame.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListObjectFrame.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_SPRITE_FRAME_NAME];
        
    } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_BUTTON]) {
        
        if(comboBoxListNormalButtonSprite.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListNormalButtonSprite.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FILE_NAME];
        
        if(comboBoxListActiveButtonSprite.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListActiveButtonSprite.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FILE_NAME];
        
        if(comboBoxListNormalButtonFrame.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListNormalButtonFrame.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FRAME_NAME];
        
        if(comboBoxListActiveButtonFrame.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListActiveButtonFrame.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FRAME_NAME];
        
    } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_PARTICLE]) {
        
        if(comboBoxListBasicParticle.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListBasicParticle.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_PARTICLE_NAME];
        
        if(comboBoxListParticleFileName.objectValueOfSelectedItem)
            [objectData setObject:comboBoxListParticleFileName.objectValueOfSelectedItem forKey:TUTORIAL_OBJECT_PARTICLE_CUSTOM_FILE_NAME];
        
    }
    
    return objectData;
}

-(BOOL)isObjectName:(NSString *)_name inArray:(NSArray *)_array{
    for (NSString *_nameInArray in _array){
        if ([_name isEqualToString:_nameInArray]){
            return YES;
        }
    }
    return NO;
}

-(void)selectObjectWithName:(NSString*)_name{
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    NSMutableDictionary *listObjectInUse = [TutorialData getListObjectsWithStoryIndex:storyIndex ofData:tutorial];
    
    NSArray *keyValue = [[listObjectInUse allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (int i = 0; i < keyValue.count; i++){
        NSString *value = [keyValue objectAtIndex:i];
        if ([value isEqualToString:_name]){
            
            [tableViewListObjectInUse selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
            
            [self tableViewListObjectInUsedClick:nil];
            
            break;
        }
    }
}

-(void)objectWithName:(NSString *)_objectName isMovingToPoint:(CGPoint)_point {
    // first we check this program is staying record point mode
    // then check name of object which is moving is object name of action
    
    [viewEditActionData objectWithName:_objectName isMovingToPoint:_point];
}

-(void)fillObjectSpriteComboBoxs {
    [comboBoxListObjectFrame removeAllItems];
    [comboBoxListNormalButtonFrame removeAllItems];
    [comboBoxListActiveButtonFrame removeAllItems];
    
    [comboBoxListObjectSprite removeAllItems];
    [comboBoxListNormalButtonSprite removeAllItems];
    [comboBoxListActiveButtonSprite removeAllItems];
    
    NSMutableArray *listFrame = [self getAllFrameNameOfListTexturePlistAdded];
    
    [comboBoxListObjectFrame addItemsWithObjectValues:listFrame];
    [comboBoxListNormalButtonFrame addItemsWithObjectValues:listFrame];
    [comboBoxListActiveButtonFrame addItemsWithObjectValues:listFrame];
    
    [comboBoxListObjectSprite addItemsWithObjectValues:listImageResourceAdded];
    [comboBoxListNormalButtonSprite addItemsWithObjectValues:listImageResourceAdded];
    [comboBoxListActiveButtonSprite addItemsWithObjectValues:listImageResourceAdded];
}

- (void)setEnableControlWhenMatrixUseSpriteOrFrameClick
{
    int useSpriteType = (int)matrixUseSpriteOfFrameForObject.selectedColumn;
    int isUseParticleName = (int)matrixUseParticleName.selectedColumn;
    
    [comboBoxListObjectFrame setEnabled:YES];
    [comboBoxListNormalButtonFrame setEnabled:YES];
    [comboBoxListActiveButtonFrame setEnabled:YES];
    [comboBoxListObjectSprite setEnabled:YES];
    [comboBoxListActiveButtonSprite setEnabled:YES];
    [comboBoxListNormalButtonSprite setEnabled:YES];
    [comboBoxListBasicParticle setEnabled:YES];
    [comboBoxListParticleFileName setEnabled:YES];
    
    if(useSpriteType == 0) {
        [comboBoxListObjectFrame setEnabled:NO];
        [comboBoxListNormalButtonFrame setEnabled:NO];
        [comboBoxListActiveButtonFrame setEnabled:NO];
    } else {
        [comboBoxListObjectSprite setEnabled:NO];
        [comboBoxListActiveButtonSprite setEnabled:NO];
        [comboBoxListNormalButtonSprite setEnabled:NO];
    }
    
    if(isUseParticleName == 0) {
        [comboBoxListParticleFileName setEnabled:NO];
    } else {
        [comboBoxListBasicParticle setEnabled:NO];
    }
}

- (IBAction)matrixUseSpriteOrFrameClick:(id)sender
{
    [self setEnableControlWhenMatrixUseSpriteOrFrameClick];
    
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    if(storyIndex >= 0) {
        NSMutableDictionary *selectedObjectData = [self getDataFromSelectedGUIObjectProperties];
        
        [TutorialData updateObjectDataIn:tutorial byObjectData:selectedObjectData atStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
        
        //Save current state of data for undo
        [self saveCurrentStateDataForUndo];
        
        //update design view with storyboard selected
        [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
    }
}

-(void)setSpriteControlsStateWithObjType:(NSString *)_objType {
    [matrixUseSpriteOfFrameForObject setHidden:YES];
    
    [comboBoxListActiveButtonFrame setHidden:YES];
    [comboBoxListNormalButtonFrame setHidden:YES];
    [comboBoxListObjectFrame setHidden:YES];
    [comboBoxListActiveButtonSprite setHidden:YES];
    [comboBoxListNormalButtonSprite setHidden:YES];
    [comboBoxListObjectSprite setHidden:YES];
    
    [labelListActiveButtonFrame setHidden:YES];
    [labelListNormalButtonFrame setHidden:YES];
    [labelListActiveButtonSprite setHidden:YES];
    [labelListNormalButtonSprite setHidden:YES];
    [labelListObjectFrame setHidden:YES];
    [labelListObjectSprite setHidden:YES];
    
    [matrixUseParticleName setHidden:YES];
    [labelListParticleFile setHidden:YES];
    [labelListBasicParticleName setHidden:YES];
    [comboBoxListParticleFileName setHidden:YES];
    [comboBoxListBasicParticle setHidden:YES];
    
    if([_objType isEqualToString:TUTORIAL_OBJECT_TYPE_SPRITE]) {
        [matrixUseSpriteOfFrameForObject setHidden:NO];
        
        [comboBoxListObjectFrame setHidden:NO];
        [comboBoxListObjectSprite setHidden:NO];
        
        [labelListObjectFrame setHidden:NO];
        [labelListObjectSprite setHidden:NO];
        
        //Set smaller size button type
        [viewEditObjectView setFrame:CGRectMake(viewEditObjectView.frame.origin.x, viewEditObjectView.frame.origin.y, viewEditObjectView.frame.size.width, 110)];
        
    } else if([_objType isEqualToString:TUTORIAL_OBJECT_TYPE_BUTTON]) {
        [matrixUseSpriteOfFrameForObject setHidden:NO];
        
        [comboBoxListActiveButtonFrame setHidden:NO];
        [comboBoxListNormalButtonFrame setHidden:NO];
        [comboBoxListActiveButtonSprite setHidden:NO];
        [comboBoxListNormalButtonSprite setHidden:NO];
        
        [labelListActiveButtonFrame setHidden:NO];
        [labelListNormalButtonFrame setHidden:NO];
        [labelListActiveButtonSprite setHidden:NO];
        [labelListNormalButtonSprite setHidden:NO];
        
        //Set larger size sprite and particle type
        [viewEditObjectView setFrame:CGRectMake(viewEditObjectView.frame.origin.x, viewEditObjectView.frame.origin.y, viewEditObjectView.frame.size.width, 170)];
        
    } else if([_objType isEqualToString:TUTORIAL_OBJECT_TYPE_PARTICLE]) {
        [matrixUseParticleName setHidden:NO];
        [labelListParticleFile setHidden:NO];
        [labelListBasicParticleName setHidden:NO];
        [comboBoxListParticleFileName setHidden:NO];
        [comboBoxListBasicParticle setHidden:NO];
        
        //Set smaller size button type
        [viewEditObjectView setFrame:CGRectMake(viewEditObjectView.frame.origin.x, viewEditObjectView.frame.origin.y, viewEditObjectView.frame.size.width, 110)];
    }
}

-(IBAction)spriteComboBoxChangeSelected:(id)sender {
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    NSMutableDictionary *selectedObjectData = [self getDataFromSelectedGUIObjectProperties];
    /*if (comboBoxListObjectFrame == sender){
     [selectedObjectData setValue:@"" forKey:TUTORIAL_OBJECT_SPRITE_FILE_NAME];
     }*/
    [TutorialData updateObjectDataIn:tutorial byObjectData:selectedObjectData atStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];
    
    //update design view with storyboard selected
    [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
}

-(void)updateCurrentObjectSelectedWithPoint:(CGPoint)_point {
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    txtObjPosX.stringValue = [NSString stringWithFormat:@"%.02f", _point.x];
    txtObjPosY.stringValue = [NSString stringWithFormat:@"%.02f", _point.y];
    
    NSMutableDictionary *selectedObjectData = [self getDataFromSelectedGUIObjectProperties];
    [selectedObjectData setObject:txtObjName.stringValue forKey:@"Name"];
    
    [TutorialData updateObjectDataIn:tutorial byObjectData:selectedObjectData atStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];
    
    //update design view with storyboard selected
    [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
}

-(void)addNewObjectWithObjectData:(NSMutableDictionary *)_objectDictionary{
    
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    NSString *name = [_objectDictionary objectForKey:TUTORIAL_OBJECT_TYPE_KEY];
    
    NSMutableDictionary *object = nil;
    NSString *newObjectName = [NSString stringWithFormat:@"%@_%d", name, index];
    
    do {
        newObjectName = [NSString stringWithFormat:@"%@_%d", name, index];
        
        object = [TutorialData getObjectDataFrom:tutorial withStoryIndex:storyIndex withObjectName:newObjectName];
        
        index++;
        
    } while (object);
    
    [_objectDictionary setValue:newObjectName forKey:TUTORIAL_OBJECT_NAME_KEY];
    
    if(currentDeviceChoosed == DEVICE_TYPE_CUSTOM_RESOLUTION) {
        CGPoint startPosition = CGPointMake(currentCustomDeviceSize.width/2, currentCustomDeviceSize.height/2);
        
        [_objectDictionary setValue:[NSNumber numberWithFloat:startPosition.x] forKey:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY];
        
        [_objectDictionary setValue:[NSNumber numberWithFloat:startPosition.y] forKey:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY];
    }
    
    [TutorialData addObject:_objectDictionary intoStoryAtIndex:storyIndex ofTutorialData:tutorial];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];
    
    [tableViewListObjectInUse reloadData];
    
    [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
    
    //save current data to undo to previous action
    [self saveCurrentStateDataForUndo];
}

- (NSMutableArray *) getListObjectNameInStory:(int)_storyIndex
{
    NSMutableArray *result = nil;
    
    int listStoryboardCount = (int)[TutorialData getListStoryboardFromData:tutorial].count;
    
    if (_storyIndex >= 0 && _storyIndex < listStoryboardCount)
    {
        NSMutableDictionary *listObjectInUse = [TutorialData getListObjectsWithStoryIndex:_storyIndex ofData:tutorial];
        
        result = (NSMutableArray *)[[listObjectInUse allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return result;
}

#pragma mark -
#pragma mark Storyboard functions

-(IBAction)newStoryboardMenuClicked:(id)sender {
    [self createNewStoryboard];
}

-(void)createNewStoryboard {
    NSMutableDictionary *storyDictionary = [[NSMutableDictionary alloc] init];
    [TutorialData addStory:storyDictionary intoStoryboardOfTutorialData:tutorial];
    
    NSMutableDictionary *objects = [[NSMutableDictionary alloc] init];
    [TutorialData addObjects:objects intoLastStoryOfTutorialData:tutorial];
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [TutorialData addActions:actions intoLastStoryOfTutorialData:tutorial];
    
    //Add list row index of timeline for this story
    NSMutableArray *listRowIndexOfTimeLine = [[NSMutableArray alloc] init];
    [listRowIndexOfAction addObject:listRowIndexOfTimeLine];
    
    NSString *item = [NSString stringWithFormat:@"Screen %d", nextIndexOfNewStoryboard];
    [self addNewTabWithName:item];
    
    nextIndexOfNewStoryboard++;
}

-(void)deleteStoryboardAtIndex:(int)_deleteIndex {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSWarningAlertStyle;
    [alert addButtonWithTitle:@"NO"];
    [alert addButtonWithTitle:@"YES"];
    alert.messageText = @"Want to delete this Screen?\nAll data will be deleted!";
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            NSLog (@"NO clicked");
            break;
        case NSAlertSecondButtonReturn: {            
            if(_deleteIndex >= 0) {
                [TutorialData removeStoryboardAtIndex:_deleteIndex intoTutorialData:tutorial];
                
                [tabView removeTabViewItem:[tabView tabViewItemAtIndex:_deleteIndex]];
                
                //remove list row index of timeline for this story
                [listRowIndexOfAction removeObjectAtIndex:_deleteIndex];
                
                [self changeSelectedStoryboard];
                
                //Save current state of data for undo
                [self saveCurrentStateDataForUndo];
            }
            
            if([[tabView tabViewItems] count] > 0) {
                [tabView selectTabViewItemAtIndex:0];
                [self changeSelectedStoryboard];
            } else {
                //[comboBoxListStoryboard setStringValue:@""];
            }
            
            break;
        }
        default:
            break;
    }
    [alert release];
}

-(void)changeSelectedStoryboard {
    [self clearRightBar];
    
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    currentIndexOfStorySelected = storyIndex;
    
    currentIndexSequenceSelected = -1;
    currentIndexActionSelected = -1;
    
    NSMutableArray *listStoryData = [TutorialData getListStoryboardFromData:tutorial];
    
    if(storyIndex < 0 || listStoryData.count <= 0) {
        
        //disable tool bar item control on toolbar
        /*if(mainToolBar.items.count > 3) {
         [mainToolBar removeItemAtIndex:3];
         [mainToolBar removeItemAtIndex:3];
         [mainToolBar removeItemAtIndex:3];
         }*/
        
        storyIndex = -1;
        
        [self hideControlsWhenNoStory];
    } else {
        
        //enable tool bar item control on toolbar
        /*if(mainToolBar.items.count <= 3) {
         [mainToolBar insertItemWithItemIdentifier:@"toolbarItemRunStoryboard" atIndex:3];
         [mainToolBar insertItemWithItemIdentifier:@"toolbarItemAddObject" atIndex:4];
         [mainToolBar insertItemWithItemIdentifier:@"toolbarItemResourceManager" atIndex:5];
         }*/
        
        [self showControlWhenChooseStory];
        
        //[tableViewListActionSequence reloadData];
        //[tableViewListActions reloadData];
        [tableViewListObjectInUse reloadData];
    }
    
    //update design view with storyboard selected
    [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
    
    //[tableViewListActionSequence reloadData];
    //[self timeLineActionClickedProccess];
    
    NSMutableArray *tempRowIndexArray = (storyIndex >= 0) ? [listRowIndexOfAction objectAtIndex:storyIndex] : nil;
    
    [animationTimeLine drawActionSequenceDataWithTutorialData:tutorial withStoryIndex:storyIndex withListRowIndex:tempRowIndexArray];
}

#pragma mark -
#pragma mark Action Sequences Function

-(IBAction)createNewActionSequence:(id)sender {    
    NSMutableDictionary *actionSequence = [self createDeaultDataActionSequence];
    
    //Default add just 1 action into sequence
    NSMutableDictionary *action = [viewEditActionData getDefaultDataConfigs];
    [TutorialData addAction:action intoSequenceData:actionSequence];
    
    int indexOfStorySelected = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    [TutorialData addAction:actionSequence intoStoryAtIndex:indexOfStorySelected ofTutorialData:tutorial];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];
    
    [self clearRightBar];
    
    //Update GUI value
    [self updateGUIWhenChangedSequence];
}

-(IBAction)deleteActionSequence:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSWarningAlertStyle;
    [alert addButtonWithTitle:@"NO"];
    [alert addButtonWithTitle:@"YES"];
    alert.messageText = @"Want to Continue? All data will be deleted!";
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            NSLog (@"NO clicked");
            break;
        case NSAlertSecondButtonReturn: {
            /*if (animationTimeLine.listSelectedActionsIndexes.count > 0){
                for (int i = (int)animationTimeLine.listSelectedActionsIndexes.count - 1; i >= 0; i--){
                    int selectedIndex = [[animationTimeLine.listSelectedActionsIndexes objectAtIndex:i] intValue];
                    
                    [TutorialData removeActionDataIn:tutorial atStoryIndex:currentIndexOfStorySelected atActionIndex:selectedIndex];
                }
                [animationTimeLine.listSelectedActionsIndexes removeAllObjects];
            }else{
                [TutorialData removeActionDataIn:tutorial atStoryIndex:currentIndexOfStorySelected atActionIndex:currentIndexSequenceSelected];
                
            } */
            
            if(currentIndexOfStorySelected >= 0 && currentIndexSequenceSelected >= 0)
            {
                [self clearRightBar];
                
                [TutorialData removeActionDataIn:tutorial atStoryIndex:currentIndexOfStorySelected atActionIndex:currentIndexSequenceSelected];
            }

            //Save current state of data for undo
            [self saveCurrentStateDataForUndo];
            
            //Update GUI value
            [self updateGUIWhenChangedSequence];
            
            break;
        }
        default:
            break;
    }
    [alert release];
}

-(void)updateActionSequenceConfig:(NSMutableDictionary *)_actionSequenceData sequenceIndex:(int)_sequenceIndex storyIndex:(int)_storyIndex {
    NSLog(@"Update sequence index: %d, in story index: %d", _sequenceIndex, _storyIndex);
    
    if(_storyIndex >= 0 && _sequenceIndex >= 0) {
        [TutorialData updateActionDataIn:tutorial byActionData:_actionSequenceData atStoryIndex:_storyIndex atActionIndex:_sequenceIndex];
        
        //[self updateGUISequenceWhenChangeConfig];
        
        //Save current state of data for undo
        [self saveCurrentStateDataForUndo];
    }
}

-(void)updateGUIWhenChangedSequence {
    [tableViewListActionSequence reloadData];
    [self redrawAnimationTimeLine];
}

-(void)updateGUISequenceWhenChangeConfig {    

}

- (void) changeAllActionTargetName:(NSString *)_oldName byName:(NSString *)_newName
{
    //get list sequence
    NSMutableArray *listSequence = [TutorialData getListActionsWithStoryIndex:currentIndexOfStorySelected ofData:tutorial];
    
    for(int i = 0; i < listSequence.count; i++)
    {
        NSMutableDictionary *sequenceData = [listSequence objectAtIndex:i];
        
        NSString *targetName = [sequenceData objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
        
        if([targetName isEqualToString:_oldName])
        {
            [sequenceData setObject:_newName forKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
            
            [TutorialData updateActionDataIn:tutorial byActionData:sequenceData atStoryIndex:currentIndexOfStorySelected atActionIndex:i];
        }
    }
}

#pragma mark -
#pragma mark Action Function

-(IBAction)createNewAction:(id)sender {
    //[self setDefaultValueForTextfieldOfAction];
    
    NSMutableDictionary *action = [viewEditActionData getDefaultDataConfigs];
    
    
    [TutorialData addAction:action intoSequenceActionOfActionAtIndex:currentIndexSequenceSelected ofStoryAtIndex:currentIndexOfStorySelected ofTutorialData:tutorial];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];
    
    //Update GUI value
    [self updateGUIWhenChangedAction];
}

-(IBAction)deleteAction:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSWarningAlertStyle;
    [alert addButtonWithTitle:@"NO"];
    [alert addButtonWithTitle:@"YES"];
    alert.messageText = @"Want to Continue? All data will be deleted!";
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            NSLog (@"NO clicked");
            break;
        case NSAlertSecondButtonReturn: {
            
            [TutorialData removeActionDataAtIndex:currentIndexActionSelected inActionSequenceIndex:currentIndexSequenceSelected ofStoryIndex:currentIndexOfStorySelected inTutorialData:tutorial];
            
            //Save current state of data for undo
            [self saveCurrentStateDataForUndo];
            
            //Update GUI value
            [self updateGUIWhenChangedAction];
            
            break;
        }
        default:
            break;
    }
    [alert release];
}

-(IBAction)moveUpActionRow:(id)sender {
    NSLog(@"Move action row up");
    
    if(currentIndexActionSelected > 0 && currentIndexOfStorySelected >= 0 && currentIndexSequenceSelected >= 0) {
        int previousActionIndex = currentIndexActionSelected - 1;
        
        [TutorialData swapActionDataBetweenIndexA:currentIndexActionSelected andIndexB:previousActionIndex inSequenceIndex:currentIndexSequenceSelected inStory:currentIndexOfStorySelected inTutorialData:tutorial];
        
        //Save current state of data for undo
        [self saveCurrentStateDataForUndo];
        
        //Update GUI value
        [self updateGUIWhenChangedAction];
        
        //reselect current index of action
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:previousActionIndex];
        [tableViewListActions selectRowIndexes:indexSet byExtendingSelection:NO];
    }
}

-(IBAction)moveDownActionRow:(id)sender {
    NSLog(@"Move action row down");
    
    if(currentIndexActionSelected >= 0 && currentIndexOfStorySelected >= 0 && currentIndexSequenceSelected >= 0) {
        int countListActionInSequence = (int)[TutorialData getListActionInSequenceIndex:currentIndexSequenceSelected atStoryIndex:currentIndexOfStorySelected ofTutorialData:tutorial].count;
        
        //Check if it not last action index
        if(currentIndexActionSelected < countListActionInSequence - 1) {
            int nextActionIndex = currentIndexActionSelected + 1;
            
            [TutorialData swapActionDataBetweenIndexA:currentIndexActionSelected andIndexB:nextActionIndex inSequenceIndex:currentIndexSequenceSelected inStory:currentIndexOfStorySelected inTutorialData:tutorial];
            
            //Save current state of data for undo
            [self saveCurrentStateDataForUndo];
            
            //Update GUI value
            [self updateGUIWhenChangedAction];
            
            //reselect current index of action
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:nextActionIndex];
            [tableViewListActions selectRowIndexes:indexSet byExtendingSelection:NO];
        }
    }
}

-(void)updateActionWithData:(NSMutableDictionary *)_actData atIndex:(int)_actIndex atSeqIndex:(int)_seqIndex atStoryIndex:(int)_storyIndex {
    NSLog(@"Update action index: %d, in seq index: %d, in story index: %d", _actIndex, _seqIndex, _storyIndex);
    
    if(_storyIndex >= 0 && _seqIndex >= 0 && _actIndex >= 0) {
        [TutorialData updateActionData:_actData atIndex:_actIndex inActionSequenceIndex:_seqIndex ofStoryIndex:_storyIndex inTutorialData:tutorial];
        
        //Save current state of data for undo
        [self saveCurrentStateDataForUndo];
    }
}

-(void)updateGUIWhenChangedAction {
    //update GUI
    [tableViewListActions reloadData];
    
    //update totalTime of sequence if changed duration time of action
    [viewEditActionSequence updateTotalTimeToRunSequence];
    
    //update timeline
    [self redrawAnimationTimeLine];
}

-(void)updateGUIWhenChangedActionConfig {
    //update totalTime of sequence if changed duration time of action
    [viewEditActionSequence updateTotalTimeToRunSequence];
    
    //update timeline
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    [animationTimeLine drawActionSequenceDataWithTutorialData:tutorial withStoryIndex:storyIndex withListRowIndex:[listRowIndexOfAction objectAtIndex:storyIndex]];
}

#pragma mark -
#pragma mark Timeline Delegates Implement

-(void)changeSequenceStartAfterTimeBy:(float)_deltaTime{
    float afterTime = viewEditActionSequence.txtStartAfetrTime.stringValue.floatValue / 1000.0f + _deltaTime;
    
    if(afterTime < 0)
        afterTime = 0;
    
    viewEditActionSequence.txtStartAfetrTime.stringValue = [NSString stringWithFormat:@"%.0f", afterTime * 1000];
    
    if(currentIndexSequenceSelected >= 0) {
        [viewEditActionSequence updateActionSequenceDataFromGUI];
    }
}

-(void)updateSequenceStartAfterTimeWith:(float)_value {
    if(_value < 0)
        _value = 0;
    
    viewEditActionSequence.txtStartAfetrTime.stringValue = [NSString stringWithFormat:@"%.0f", _value * 1000];
    
    if(currentIndexSequenceSelected >= 0) {
        [viewEditActionSequence updateActionSequenceDataFromGUI];
    }
}


-(void)selectAction:(int)_actionIndex inSequence:(int)sequenceIndex {
    currentIndexSequenceSelected = sequenceIndex;
    currentIndexActionSelected = _actionIndex;
    
    if(sequenceIndex < 0) {
        [tableViewListActionSequence reloadData];
    } else {
        [tableViewListActionSequence  selectRowIndexes:[NSIndexSet indexSetWithIndex:sequenceIndex] byExtendingSelection:NO];
    }
    
    [self timeLineActionClickedProccess];
    
    //[tableViewListActions selectRowIndexes:[NSIndexSet indexSetWithIndex:_actionIndex] byExtendingSelection:NO];
    
    //[self tableViewListActionClicked:nil];
}

- (void) timeLineActionClickedProccess {
    //currentIndexSequenceSelected = (int)tableViewListActionSequence.selectedRow;
    
    if(currentIndexOfStorySelected >= 0 && currentIndexSequenceSelected >= 0) {
        NSMutableDictionary *sequenceData = [TutorialData getActionDataFrom:tutorial withStoryIndex:currentIndexOfStorySelected withActionIndex:currentIndexSequenceSelected];
        
        //[tableViewListActions reloadData];
        //[self loadTextFieldOfActionSequenceWith:sequenceData];
        
        //Show data in edit at rightBar
        [self showSequenceActionEditRightBar];
        [viewEditActionSequence bindActionSequenceData:sequenceData withSeqenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected];
        
        //show edit area of action 0
        currentIndexActionSelected = 0;
        if(currentIndexOfStorySelected >= 0 && currentIndexActionSelected >= 0 && currentIndexSequenceSelected >= 0) {
            NSMutableDictionary *actionData = [TutorialData getActionDataAtIndex:currentIndexActionSelected withActionSequenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
            
            actionData = [[NSMutableDictionary alloc] initWithDictionary:actionData];
            
            //[self loadTextFieldOfActionWith:[actionData retain]];
            //[tableViewFrameUsed reloadData];
            
            [viewEditActionData bindDataWith:actionData actionIndex:currentIndexActionSelected sequenceIndex:currentIndexSequenceSelected storyIndex:currentIndexOfStorySelected];
            
            [self showActionEditRightBar];
        } else {
            //Just hide edit action. Still show edit action sequence and list action view
            [viewEditActionData.view removeFromSuperview];
        }
    }
    
    //hide tab view list action ofsequence if not choose
    if(currentIndexSequenceSelected >= 0) {
        
        //show total time to run this action sequence
        [viewEditActionSequence updateTotalTimeToRunSequence];
    } else {
        //Clear sequence index on right bar
        [self clearRightBar];
        
        //show total time to run this action sequence
        [viewEditActionSequence updateTotalTimeToRunSequence];
    }
}

-(void)changeActionDurationBy:(float)_deltaTime{
    [viewEditActionData changeDurationWith:_deltaTime];
}

-(void)updateActionDurationWith:(float)_durationTime {
    [viewEditActionData updateDurationWith:_durationTime];
}

-(void)actionTimeLineMouseEnter:(int)_sequenceIndex actionIndex:(int)_actionIndex {
    NSMutableDictionary *sequeneData = [TutorialData getActionDataFrom:tutorial withStoryIndex:currentIndexOfStorySelected withActionIndex:_sequenceIndex];
    
    NSMutableDictionary *actionData = [TutorialData getActionDataAtIndex:_actionIndex withActionSequenceIndex:_sequenceIndex withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
    
    NSString *targetName = [sequeneData objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
    
    float desX = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_X] floatValue];
    float desY = [[actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y] floatValue];
    
    CGPoint desPoint = CGPointMake(desX, desY);
    
    NSString *actionType = [actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
    
    if([actionType isEqualToString:TUTORIAL_ACTION_MOVE_TO] ||
       [actionType isEqualToString:TUTORIAL_ACTION_JUMP_TO] ||
       [actionType isEqualToString:TUTORIAL_ACTION_PLACE] ||
       [actionType isEqualToString:TUTORIAL_ACTION_ZICZAC_MOVING] ||
       [actionType isEqualToString:TUTORIAL_ACTION_SPRING_MOVING] ||
        [actionType isEqualToString:TUTORIAL_ACTION_WAVY_SIN_MOVING] ||
       [actionType isEqualToString:TUTORIAL_ACTION_CUSTOM_SPRING_MOVING])
    {
        [tutorialCocosViewController showDestinationSpriteWhenHover:targetName desPoint:desPoint storyIndex:currentIndexOfStorySelected];
    }
}

-(void)actionTimeLineMouseExit:(int)_sequenceIndex actionIndex:(int)_actionIndex {
    [tutorialCocosViewController hideDestinationSprite];
}

#pragma mark -
#pragma mark Window Delegate

// just returns the item for the right row
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    //NSLog(@"Table View row");
    
    NSString *value = nil;
    
    if(tableView == tableViewListObjectInUse) { 
        int storySelectedIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        int listStoryboardCount = (int)[TutorialData getListStoryboardFromData:tutorial].count;
        if (storySelectedIndex >= 0 && storySelectedIndex < listStoryboardCount){
            NSMutableDictionary *listObjectInUse = [TutorialData getListObjectsWithStoryIndex:storySelectedIndex ofData:tutorial];
            
            NSArray *keyValue = [[listObjectInUse allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            if(keyValue.count > 0 && row < keyValue.count)
                value = [keyValue objectAtIndex:row];
        }
        
    }
    
    if(tableView == tableViewListActions) {
        NSLog(@"list action view row object");
        
        if(currentIndexOfStorySelected >= 0 && currentIndexSequenceSelected >= 0) {
            NSMutableDictionary *currentActionData = [TutorialData getActionDataAtIndex:(int)row withActionSequenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
            
            value = [currentActionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];
            NSLog(@"Value = %@", value);
        }
    }
    
    if(tableView == tableViewListActionSequence) {
        int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        if(storyIndex >= 0) {
            NSMutableDictionary *sequenceData = [TutorialData getActionDataFrom:tutorial withStoryIndex:storyIndex withActionIndex:(int)row];
            
            NSString *targetName = [sequenceData objectForKey:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
            
            if([targetName isEqualToString:@""])
                targetName = @"None Target";
            
            value = [NSString stringWithFormat:@"Action - %@", targetName];
        }
    }
    
    if(tableView == tableViewListPlistTextureAdded) {
        NSLog(@"list texture plist row object");
        value = [self valueOfTableViewTextureResourceAtRow:(int)row];  
    }
    
    if(tableView == tableViewListImageAdded) {
        NSLog(@"list image add row object");
        value = [self valueOfTableViewImageAddedAtRow:(int)row];
    }
    
    if(tableView == tableViewListParticleAdded) {
        NSLog(@"list particle row object");
        value = [self valueOfParticleAddedAtRow:(int)row];
    }
    
    if(tableView == tableViewListFontName) {
        NSLog(@"list font row object");
        value = [self valueOfTableViewFontAddedAtRow:(int)row];
    }
    
    return value;
}

// just returns the number of items we have.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    //NSLog(@"Table View row count");
    
    int rowCount = 0;
    
    if(tableView == tableViewListObjectInUse) {
        int storySelectedIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        if (storySelectedIndex >= 0) {
            NSMutableDictionary *listObjectInUse = [TutorialData getListObjectsWithStoryIndex:storySelectedIndex ofData:tutorial];
            rowCount = (int)listObjectInUse.count;
        }
    }
    
    if(tableView == tableViewListActions) {  
        [tableViewListActions deselectRow:tableViewListActions.selectedRow];
        
        rowCount = (int)[TutorialData getListActionInSequenceIndex:currentIndexSequenceSelected atStoryIndex:currentIndexOfStorySelected ofTutorialData:tutorial].count;
    }
    
    if(tableView == tableViewListActionSequence) {
        [tableViewListActionSequence deselectRow:currentIndexSequenceSelected];
        
        int storySelectedIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        rowCount = (int)[TutorialData getListActionsWithStoryIndex:storySelectedIndex ofData:tutorial].count;
    }
    
    if(tableView == tableViewListPlistTextureAdded) {
        [tableViewListPlistTextureAdded deselectRow:tableViewListPlistTextureAdded.selectedRow];
        
        rowCount = [self tableViewRowCountOfTextureResource];  
    }
    
    if(tableView == tableViewListParticleAdded) {
        [tableViewListParticleAdded deselectRow:tableViewListParticleAdded.selectedRow];
        
        rowCount = [self tableViewRowCountOfParticleAdded];  
    }
    
    if(tableView == tableViewListImageAdded) {
        rowCount = [self tableViewRowCountOfImageAdded];
    }
    
    if(tableView == tableViewListFontName) {
        rowCount = [self tableViewRowCountOfFontAdded];
    }
    
    return rowCount;
}

-(CGFloat) tableView:(NSTableView *)tableView 
         heightOfRow:(NSInteger)row{
    NSLog(@"Table View height of row");
    
    float height = 20;
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    if (tableView == tableViewListActionSequence){
        if (storyIndex >= 0){
            NSMutableArray *listSequence = [TutorialData getListActionsWithStoryIndex:storyIndex ofData:tutorial];
            height = [ToolUtil getHeightFromSequenceData:[listSequence objectAtIndex:row]];
        }

    }
    return height;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    //if(notification.object == tableViewListActionSequence) {
        //currentIndexSequenceSelected = (int)tableViewListActionSequence.selectedRow;
    //}
    
    if(notification.object == tableViewListActions) {
        currentIndexActionSelected = (int)tableViewListActions.selectedRow;
    }
}

-(BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor{
    NSLog(@"text should editing");
    if(control == txtObjName){
        if (![txtObjName.stringValue isEqualToString:@""]){
            oldObjectName = [NSString stringWithString:txtObjName.stringValue];
        }
    }
    
    return YES;
}

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    NSLog(@"text should end editing");
    if(control == txtObjName){
        int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        NSArray *keyNames = [[TutorialData getListObjectsWithStoryIndex:storyIndex ofData:tutorial] allKeys];
        
        if(![self isObjectName:txtObjName.stringValue inArray:keyNames] && ![txtObjName.stringValue isEqualToString:@""]){
            
            NSMutableDictionary *selectedObjectData = [[NSMutableDictionary alloc] initWithDictionary:[TutorialData getObjectDataFrom:tutorial withStoryIndex:storyIndex withObjectName:oldObjectName] copyItems:YES];
            
            //get old name and change all taget name of all action reference to
            NSString *oldName = [selectedObjectData objectForKey:TUTORIAL_OBJECT_NAME_KEY];
            [self changeAllActionTargetName:oldName byName:txtObjName.stringValue];
            
            //Set new info
            [selectedObjectData setValue:txtObjName.stringValue forKey:@"Name"];
            
            [TutorialData removeObjectDataIn:tutorial atStoryIndex:storyIndex withObjectName:oldObjectName];
            
            [TutorialData addObject:selectedObjectData intoStoryAtIndex:storyIndex ofTutorialData:tutorial];
            
            //Save current state of data for undo
            [self saveCurrentStateDataForUndo];
            
            [tableViewListObjectInUse reloadData];
            
            [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
            
        }
        else{
            
            NSLog(@"Illegal Name");
            
        }
    }
    
    return YES;
}

-(void)controlTextDidChange:(NSNotification *)objP{
    NSLog(@"control text did change");
    
    //rewrite action data if change config of action
    int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
    
    //update selected GUI Object
    if (objP.object != txtObjName && ![txtObjName.stringValue isEqualToString:@""]){
        if (![txtObjName.stringValue isEqualToString:@""]) {
            
            
            NSMutableDictionary *selectedObjectData = [self getDataFromSelectedGUIObjectProperties];
            
            [selectedObjectData setObject:txtObjName.stringValue forKey:@"Name"];
            [TutorialData updateObjectDataIn:tutorial byObjectData:selectedObjectData atStoryIndex:storyIndex withObjectName:txtObjName.stringValue];
            
            //update GUI
            [self updateObjectTextFieldsValueWithData:selectedObjectData];
            
            //Save current state of data for undo
            [self saveCurrentStateDataForUndo];
            
            //update design view with storyboard selected
            [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:storyIndex];
        }
    }
}

#pragma mark -
#pragma mark Copy - Paste Functions

- (void)copySelectedObject{
    if (currentIndexObjectSelected >= 0){
        int storySelectedIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        
        NSMutableDictionary *listObjectInUse = [TutorialData getListObjectsWithStoryIndex:storySelectedIndex ofData:tutorial];
        
        NSArray *keyValue = [[listObjectInUse allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSString *string = [keyValue objectAtIndex:currentIndexObjectSelected];
        
        txtObjName.stringValue = string;

        copyObject = [[NSMutableDictionary alloc] initWithDictionary:[TutorialData getObjectDataFrom:tutorial withStoryIndex:storySelectedIndex withObjectName:string] copyItems:YES];
    }
}

- (void)copySelectedSequence{
    if (currentIndexSequenceSelected >= 0){
        //int storyIndex = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];
        //int sequenceIndex = (int)tableViewListActionSequence.selectedRow;
        
        if(currentIndexOfStorySelected >= 0 && currentIndexSequenceSelected >= 0) {
            
            copySequence = [TutorialData getActionDataFrom:tutorial withStoryIndex:currentIndexOfStorySelected withActionIndex:currentIndexSequenceSelected];

        }
    }
}

- (void)copySelectedAction {
    if (tableViewListActions.clickedRow >= 0){        
        if(currentIndexOfStorySelected >= 0 && currentIndexActionSelected >= 0 && currentIndexSequenceSelected >= 0) {
            
            copyAction = [TutorialData getActionDataAtIndex:currentIndexActionSelected withActionSequenceIndex:currentIndexSequenceSelected withStoryIndex:currentIndexOfStorySelected fromTutorialData:tutorial];
        }
    }
}

-(void)copyDataFrom:(NSMutableDictionary *)_source toDes:(NSMutableDictionary *)_des {
    NSArray *allKeyValue = [_source allKeys];
    
    for(NSString *keyName in allKeyValue) {
        id data = [[_source objectForKey:keyName] copy];

        [_des setObject:data forKey:keyName];
    }
}

- (void)pasteSelectedObject{
    if (copyObject){
        [self addNewObjectWithObjectData:copyObject];
    }
}

- (void)pasteSelectedSequence{
    int indexOfStorySelected = (int)[tabView indexOfTabViewItem:tabView.selectedTabViewItem];

    [TutorialData addAction:[TutorialData copyActionSequenceData:copySequence] intoStoryAtIndex:indexOfStorySelected ofTutorialData:tutorial];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];

    [self updateGUIWhenChangedSequence];
}

- (void)pasteSelectedAction{    
    [TutorialData addAction:copyAction intoSequenceActionOfActionAtIndex:currentIndexSequenceSelected ofStoryAtIndex:currentIndexOfStorySelected ofTutorialData:tutorial];
    
    //Save current state of data for undo
    [self saveCurrentStateDataForUndo];
    
    [self updateGUIWhenChangedAction];
}

- (IBAction)copy:(id)sender{
    NSMenu *menuSender = ((NSMenuItem *)sender).menu;
    
    if(menuSender == tableViewListObjectInUse.menu) {
        [self copySelectedObject];
    }
    
    if (menuSender == tableViewListActionSequence.menu){
        [self copySelectedSequence];
    }
    
    if (menuSender == tableViewListActions.menu){
        [self copySelectedAction];
    }
    
    if (menuSender == animationTimeLine.menu){
        [self copySelectedSequence];
    }
}

- (IBAction)paste:(id)sender{
    NSMenu *menuSender = ((NSMenuItem *)sender).menu;
    if (copyObject && menuSender == tableViewListObjectInUse.menu){
        [self pasteSelectedObject];
    }
    
    if (copySequence && (menuSender == tableViewListActionSequence.menu || menuSender == animationTimeLine.menu)){
        [self pasteSelectedSequence];
    }

    if (copyAction && menuSender == tableViewListActions.menu){
        [self pasteSelectedAction];
    }    
}

-(IBAction)menuDelete:(id)sender {
    NSMenu *menuSender = ((NSMenuItem *)sender).menu;
    
    if(menuSender == animationTimeLine.menu) {
        [self deleteActionSequence:nil];
    }
}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    BOOL result = false;
    
    if (currentIndexObjectSelected >= 0 || currentIndexSequenceSelected >=0 || tableViewListActions.clickedRow >=0 || currentIndexActionSelected != -1){
        if ([menuItem.title isEqualToString:@"Copy"])
            result = YES;
    }
    
    if([menuItem.title isEqualToString:@"New Action"] && currentIndexObjectSelected != -1)
        result = YES;
    
    if (copyObject && menuItem.menu == tableViewListObjectInUse.menu){
        result = YES;
    }
    
    if (copySequence && (menuItem.menu == tableViewListActionSequence.menu || (menuItem.menu == animationTimeLine.menu && [menuItem.title isEqualToString:@"Paste"]))){
        result = YES;
    }
    
    if (copyAction && (menuItem.menu == tableViewListActions.menu)){
        result = YES;
    }
    
    if(currentIndexSequenceSelected < 0 && menuItem.menu == animationTimeLine.menu && [menuItem.title isEqualToString:@"Copy"]) {
        result = false;
    }

    if(currentIndexSequenceSelected >= 0 && menuItem.menu == animationTimeLine.menu && [menuItem.title isEqualToString:@"Delete"]) {
        result = true;
    }
    
    if(currentIndexObjectSelected >= 0 && menuItem.menu == tableViewListObjectInUse.menu && [menuItem.title isEqualToString:@"Delete"]) {
        result = true;
    }
    
    return result;
}

#pragma mark -
#pragma mark User Undo - Redo And More Functions

// ==================================================================
// Functions for undo, redo user action

-(void)saveCurrentStateDataForUndo {
    [listDataForUndoUserAction addObject:[TutorialData copyTutorialData:tutorial]];
}

-(void)saveCurrentStateDataForRedo {
    [listDataForRedoUserAction addObject:[TutorialData copyTutorialData:tutorial]];
}

-(IBAction)undoUserAction:(id)sender {
    int lastIndex = (int)listDataForUndoUserAction.count - 1;
    
    if(lastIndex >= 0) {
        [self saveCurrentStateDataForRedo];
        
        NSMutableDictionary *previousData = [listDataForUndoUserAction objectAtIndex:lastIndex];
        
        tutorial = [previousData retain];
        [self reloadStoryboardFromData:tutorial];
        
        [listDataForUndoUserAction removeObjectAtIndex:lastIndex];
    }
}

-(IBAction)redoUserAction:(id)sender {
    int lastIndex = (int)listDataForRedoUserAction.count - 1;
    
    if(lastIndex >= 0) {
        [self saveCurrentStateDataForUndo];
        
        NSMutableDictionary *nextData = [listDataForRedoUserAction objectAtIndex:lastIndex];
        
        tutorial = [nextData retain];
        [self reloadStoryboardFromData:tutorial];
        
        [listDataForRedoUserAction removeObjectAtIndex:lastIndex];
    }
}

#pragma mark -
#pragma mark Project Setting, Save, Open... Functions

-(IBAction)closeProject:(id)sender {
    zIndexCounter = 0;
    
    //hide close warning  message panel
    [self closeWarningMessagePanel:nil];
    
    [listRowIndexOfAction removeAllObjects];
    [listRowIndexOfAction release];
    listRowIndexOfAction = [[NSMutableArray alloc] init];
    
    //delete all storybord in current project
    [tutorial removeAllObjects];
    [tutorial release];
    tutorial = nil;
    
    [self createDefaultTutorialData];
    
    nextIndexOfNewStoryboard = 0;
    
    //[comboBoxListStoryboard setStringValue:@""];
    //[comboBoxListStoryboard removeAllItems];
    [self removeAllTabItem];
    
    [listParticleAdded removeAllObjects];
    [listParticleAdded release];
    listParticleAdded = [[NSMutableArray alloc] init];
    
    //refresh control show list particle file added
    [tableViewListParticleAdded reloadData];
    [self fillParticleFileComboBox];
    
    [listImageResourceAdded removeAllObjects];
    [listImageResourceAdded release];
    listImageResourceAdded = [[NSMutableArray alloc] init];
    
    //refresh control show list image added
    [tableViewListImageAdded reloadData];
    [self fillObjectSpriteComboBoxs];
    
    [tableViewListPlistTextureAdded reloadData];
    
    //Hide all control when no story
    [self hideControlsWhenNoStory];
    
    //update design view with storyboard selected
    [tutorialCocosViewController updateDesignViewWith:tutorial atStoryIndex:-1];
    
    [tableViewListActionSequence reloadData];
    
    //Remove all data for undo and redo user action
    [listDataForUndoUserAction removeAllObjects];
    [listDataForRedoUserAction removeAllObjects];
}

-(IBAction)exportXML:(id)sender{
    //save XML data
    [self saveXML];
}

-(IBAction)openXmlDataFile:(id)sender {
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    
    fileTypesArray = [NSArray arrayWithObjects:@"tpproject", nil];
    
    [openDlg setCanChooseFiles:YES];   
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:TRUE];
    [openDlg setAllowsMultipleSelection:NO]; //only choose 1 file
    
    //NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    [openDlg setDirectoryURL:[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0]];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    
    if ( [openDlg runModal] == NSOKButton ) {
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        // Loop through the files and process them.
        for(int i = 0; i < [files count]; i++ ) {      
            //show link in textbox 
            NSString *filePath = [[files objectAtIndex:i] path]; 
            
            [self openProjectFileWithFileName:filePath];
        }
    }
}

-(void)openProjectFileWithFileName:(NSString *)_fileName {
    NSMutableDictionary *projectFileData = [[NSMutableDictionary alloc] initWithContentsOfFile:_fileName];
    
    //if cannot openfile, show message and quit
    if(projectFileData == nil) {
        [self showAlertMessageWith:mainWindow title:@"Open file error!" message:@"No file exist!"];
        
        return;
    }
    
    NSString *projectFileVersion = [projectFileData objectForKey:PROJECT_FILE_VERSION_KEY];
    
    if(([projectFileData objectForKey: PROJECT_FILE_KEY_TUTORIAL_DATA] && [projectFileVersion isEqualToString:PROJECT_FILE_CURRENT_VERSION_VALUE]) || ![projectFileVersion isEqualToString:PROJECT_FILE_CURRENT_VERSION_VALUE]) {
        //Close current project before
        [self closeProject:nil];
        
        //copy all resource to cache
        NSString *fullResourcePath = [[_fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:[projectFileData objectForKey:PROJECT_FILE_KEY_RESOURCE_PATH]];
        
        [self copyAllResourceToCacheInPath:fullResourcePath];
        
        //load max zindex of object added
        zIndexCounter = [[projectFileData objectForKey:PROJECT_FILE_MAX_ZINDEX_OF_OBJECT_ADDED] intValue];
        
        //load list image resource
        listImageResourceAdded = [[projectFileData objectForKey:PROJECT_FILE_KEY_RESOURCE_ELEMENTS] objectForKey:PROJECT_FILE_KEY_RESOURCE_IMAGES];
        
        //refresh control show list image added
        [tableViewListImageAdded reloadData];
        [self fillObjectSpriteComboBoxs];
        
        //load list particle
        listParticleAdded = [[projectFileData objectForKey:PROJECT_FILE_KEY_RESOURCE_ELEMENTS] objectForKey:PROJECT_FILE_KEY_RESOURCE_PARTICLE_PLISTS];
        
        //refresh control show list particle file added
        [tableViewListParticleAdded reloadData];
        [self fillParticleFileComboBox];
        
        //load list fonts
        listFontNameAdded = [[projectFileData objectForKey:PROJECT_FILE_KEY_RESOURCE_ELEMENTS] objectForKey:PROJECT_FILE_KEY_RESOURCE_FONTS];
        
        //refresh control show list particle file added
        [tableViewListFontName reloadData];
        [self fillSystemFontComboBox];
        [self registerAllFontAdded];
        
        //Load project setting
        
        NSMutableDictionary *projectSetting = [projectFileData objectForKey:PROJECT_FILE_KEY_PROJECT_SETTING];
        
        currentDeviceChoosed = [[projectSetting objectForKey:PROJECT_FILE_KEY_PROJECT_SETTING_DEVICE_TYPE] intValue];
        
        currentDeviceViewMode = [[projectSetting objectForKey:PROJECT_FILE_KEY_PROJECT_SETTING_DEVICE_MODE] intValue];
        
        currentCustomDeviceSize.width = [[projectSetting objectForKey:PROJECT_FILE_KEY_PROJECT_SETTING_CUSTOM_DEVICE_WIDTH] floatValue];
        
        currentCustomDeviceSize.height = [[projectSetting objectForKey:PROJECT_FILE_KEY_PROJECT_SETTING_CUSTOM_DEVICE_HEIGHT] floatValue];
        
        //draw device
        [tutorialCocosViewController updateDevideWithType:currentDeviceChoosed viewMode:currentDeviceViewMode];
        
        //Set checked menuitem with device type
        [self setcheckedMenuItemWithDeviceType:currentDeviceChoosed withViewMode:currentDeviceViewMode];
        
        //Load timeLineView informations
        listRowIndexOfAction = [[projectFileData objectForKey:PROJECT_FILE_KEY_TIMELINE_VIEW_INFO] objectForKey:PROJECT_FILE_KEY_TIMELINE_VIEW_INFO_LIST_ROW_INDEX_OF_ACTIONS];
        
        //read xml tutorial data
        //tutorial = [self readDataFromXmlFile:[[_fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:[projectFileData objectForKey:PROJECT_FILE_KEY_XML_DATA]]];
        
        if([projectFileVersion isEqualToString:PROJECT_FILE_CURRENT_VERSION_VALUE])
        {
            tutorial = [projectFileData objectForKey: PROJECT_FILE_KEY_TUTORIAL_DATA];
        }
        else
        {
            tutorial = [self readDataFromXmlFile:[[_fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:[projectFileData objectForKey:PROJECT_FILE_KEY_XML_DATA]]];
        }
        
        //tutorial = [[NSMutableDictionary alloc] initWithContentsOfFile:[[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[projectFileData objectForKey:PROJECT_FILE_KEY_XML_DATA]]];
        
        [self clearRightBar];
        
        [self reloadPlistTextureFromData:tutorial];
        [self reloadStoryboardFromData:tutorial];
        
        //Save current state of data for undo
        //before save, we deleted all data in listDataUndo and listDataRedo
        [listDataForRedoUserAction removeAllObjects];
        [listDataForUndoUserAction removeAllObjects];
        [self saveCurrentStateDataForUndo];
    } else {
        [self showAlertMessageWith:mainWindow title:@"Open file error!" message:@"Data corrupted!"];
    }
}

-(IBAction)loadProjectFromCache:(id)sender {
    NSString *saveFileCache = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"AutoSaveCache/AutoSave.tpproject"];
    
    [self openProjectFileWithFileName:saveFileCache];
}

-(NSMutableDictionary *)readDataFromXmlFile:(NSString *)_xmlFile {
    NSMutableDictionary *resultData;
    
    TutorialXMLDataParse *parse = [[TutorialXMLDataParse alloc] initTutorialXMLDataParse];
    resultData = [parse getTutorialLibDataWithXmlFilePathAbsolute:_xmlFile];
    [parse release];
    
    return resultData;
}

-(void)saveProjectFileWithNameWithoutExt:(NSString *)_fileNameWithoutExt withTutorialData:(NSMutableDictionary *)_data {
    
    NSMutableDictionary *projectData = [NSMutableDictionary dictionary];
    
    //Save project file version
    [projectData setObject:PROJECT_FILE_CURRENT_VERSION_VALUE forKey:PROJECT_FILE_VERSION_KEY];
    
    //Save xml data file path
    NSString *prePath = [NSString stringWithFormat:@"%@/", [_fileNameWithoutExt stringByDeletingLastPathComponent]];
    [projectData setObject:[NSString stringWithFormat:@"%@.xml", [_fileNameWithoutExt stringByReplacingOccurrencesOfString:prePath withString:@""]] forKey:PROJECT_FILE_KEY_XML_DATA];
    
    //Save resource keys
    [projectData setObject:@"Resource" forKey:PROJECT_FILE_KEY_RESOURCE_PATH];
    NSMutableDictionary *resoureElements = [NSMutableDictionary dictionary];
    
    [resoureElements setObject:[[NSMutableArray alloc] initWithArray:listImageResourceAdded] forKey:PROJECT_FILE_KEY_RESOURCE_IMAGES];
    
    [resoureElements setObject:[[NSMutableArray alloc] initWithArray:listParticleAdded] forKey:PROJECT_FILE_KEY_RESOURCE_PARTICLE_PLISTS];
    
    [resoureElements setObject:[[NSMutableArray alloc] initWithArray:listFontNameAdded] forKey:PROJECT_FILE_KEY_RESOURCE_FONTS];
    
    //Set texture resource
    NSMutableArray *listTexturePlist = [TutorialData getListTexturePlistFromTutorialData:_data];
    [resoureElements setObject:listTexturePlist forKey:PROJECT_FILE_KEY_RESOURCE_TEXTURE_PLISTS];
    
    //set resource for dictionary
    [projectData setObject:resoureElements forKey:PROJECT_FILE_KEY_RESOURCE_ELEMENTS];
    
    //Set key for project setting: device, size...
    NSMutableDictionary *projectSettingValue = [NSMutableDictionary dictionary];
    
    [projectSettingValue setObject:[NSNumber numberWithInt:currentDeviceChoosed] forKey:PROJECT_FILE_KEY_PROJECT_SETTING_DEVICE_TYPE];
    
    [projectSettingValue setObject:[NSNumber numberWithInt:currentDeviceViewMode] forKey:PROJECT_FILE_KEY_PROJECT_SETTING_DEVICE_MODE];
    
    [projectSettingValue setObject:[NSNumber numberWithInt:(int)currentCustomDeviceSize.width] forKey:PROJECT_FILE_KEY_PROJECT_SETTING_CUSTOM_DEVICE_WIDTH];
    
    [projectSettingValue setObject:[NSNumber numberWithInt:(int)currentCustomDeviceSize.height] forKey:PROJECT_FILE_KEY_PROJECT_SETTING_CUSTOM_DEVICE_HEIGHT];
    
    [projectData setObject:projectSettingValue forKey:PROJECT_FILE_KEY_PROJECT_SETTING];
    
    //Set key for timeLineView info
    NSMutableDictionary *timeLineViewInfo = [NSMutableDictionary dictionary];
    
    //set list row index of actions in to timeLineView info
    [timeLineViewInfo setObject:listRowIndexOfAction forKey:PROJECT_FILE_KEY_TIMELINE_VIEW_INFO_LIST_ROW_INDEX_OF_ACTIONS];
    [projectData setObject:timeLineViewInfo forKey:PROJECT_FILE_KEY_TIMELINE_VIEW_INFO];
    
    //set project info
    [projectData setObject:tutorial forKey:PROJECT_FILE_KEY_TUTORIAL_DATA];
    
    //set max z-index of object added
    [projectData setObject:[NSString stringWithFormat:@"%d", zIndexCounter] forKey:PROJECT_FILE_MAX_ZINDEX_OF_OBJECT_ADDED];
    
    //Write project data to file
    [projectData writeToFile:[NSString stringWithFormat:@"%@.tpproject", _fileNameWithoutExt] atomically:YES];
}

-(void)saveXML {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    [savePanel setDirectoryURL:[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0]];
    [savePanel setPrompt:NSLocalizedString(@"Save",nil)];
    [savePanel setRequiredFileType:@"tpproject"];
    //[savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"tpproject"]];
    [savePanel setNameFieldStringValue:@"Untitled"];
    
    if([savePanel runModal] == NSOKButton ){
        NSString *fileNameWithoutExt = [[savePanel filename] stringByDeletingPathExtension];
        
        //save project
        [self saveAllProjectFileWithFileNameWithouExt:fileNameWithoutExt];        
    }
}

-(void)saveAllProjectFileWithFileNameWithouExt:(NSString *)fileNameWithoutExt{    
    //copy data to temp
    NSMutableDictionary *tempData = [TutorialData copyTutorialData:tutorial];
    
    //Save project file
    [self saveProjectFileWithNameWithoutExt:fileNameWithoutExt withTutorialData:tempData];
    
    [TutorialXMLExport exportData:tempData toFile:[NSString stringWithFormat:@"%@.xml", fileNameWithoutExt]];
    [tempData release];
    
    //[tutorial writeToFile:[NSString stringWithFormat:@"%@.plist", fileNameWithoutExt] atomically:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *resourceCachePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:RESOURCE_CACHE_DIR];
    
    NSString *filePath = [fileNameWithoutExt stringByDeletingLastPathComponent];
    
    filePath = [filePath stringByAppendingPathComponent:@"Resource"];
    
    BOOL isDir = YES;
    
    BOOL isDirExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if (isDirExists){
        
        [ToolUtil clearAllFilesExceptSubFoldersInPath:filePath];
        
    }else{
        
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
    
    [ToolUtil copyFileFromSrc:resourceCachePath toDes:filePath];
}

-(void)autoSave{
    [self performSelectorInBackground:@selector(saveToAutoSaveCache) withObject:nil];
    
    //recounter timer
    [self performSelector:@selector(autoSave) withObject:nil afterDelay:autoSaveProjectDelayTime];
}

-(void)saveToAutoSaveCache{
    //create an autorelease pool since this func runs on background with no auto release pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    //get list story in current project
    NSMutableArray *listStory = [TutorialData getListStoryboardFromData:tutorial];
    
    //only when the project has at least a story will the autosave func works
    if (listStory.count > 0){
        NSString *saveFileCache = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"AutoSaveCache/AutoSave"];
        
        [self saveAllProjectFileWithFileNameWithouExt:saveFileCache];
    }
    
    [pool release];
}

#pragma mark -
#pragma Dealloc, Clean Functions

- (void)dealloc{
    [tutorial removeAllObjects];
    [tutorial release];
    [super dealloc];
}
@end
