//
//  ToolUtil.m
//  TutorialTool
//
//  Created by User on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToolUtil.h"
#import "TutorialData.h"

@implementation ToolUtil

+(BOOL)copyFileFromSrc:(NSString *)_srcFileName toDes:(NSString *)_desFileName {
    BOOL copyResult = true;
    
    //file manager instance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //check source file is exist on disk
    BOOL fileExist = [fileManager fileExistsAtPath:_srcFileName];
    
    if(fileExist) {
        //remove old file if has
        BOOL desFileExist = [fileManager fileExistsAtPath:_desFileName];
        
        if(desFileExist) {
            [fileManager removeItemAtPath:_desFileName error:NULL];
        }
        
        //copy file to des
        copyResult = [fileManager copyItemAtPath:_srcFileName toPath:_desFileName error:NULL];
        
    } else {
        copyResult = false;
    }
    
    return copyResult;
}

+(void)clearAllFilesInPath:(NSString *)_path{
    
    //file manager instance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //get all files'name in path
    NSArray *files = [fileManager contentsOfDirectoryAtPath:_path error:NULL];
    
    for (NSString *fileName in files){
        NSString *filePath = [_path stringByAppendingPathComponent:fileName];
        //check if file exists
        BOOL fileExists = [fileManager fileExistsAtPath:filePath];
        
        //delete file if exists
        if (fileExists){
            [fileManager removeItemAtPath:filePath error:NULL];
        }
        
    }
}

+(void)clearAllFilesExceptSubFoldersInPath:(NSString *)_path {
    
    //file manager instance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //get all files'name in path
    NSArray *files = [fileManager contentsOfDirectoryAtPath:_path error:NULL];
    
    for (NSString *fileName in files){
        //check if the filename is file or folder based on the charater "." in its name
        NSString *filePath = [_path stringByAppendingPathComponent:fileName];
        
        BOOL isDir;
            //check if file exists and is a directory
        BOOL fileExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        
        if (fileExists && !isDir){    
            //delete file if exists and not a directory
                [fileManager removeItemAtPath:filePath error:NULL];
        }
    }
}


+(BOOL)deleteFileWithPath:(NSString *)_path{
    
    //file manager instance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileExists = [fileManager fileExistsAtPath:_path];
    
    //check if file exists
    if (fileExists){
        //delete if file exists
        BOOL result = [fileManager removeItemAtPath:_path error:NULL];
        if (result)
            return YES;
    }
    
    return NO;
}

+(NSString *)setString:(NSString *)_string{
    
    if (_string != nil){
        return  _string;
    }
    
    return @"";
}


+(float)durationTimeFromActionData:(NSMutableDictionary *)_actionData{
    
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


+(float)getHeightFromSequenceData:(NSMutableDictionary *)_sequenceData{
    
    float oldHeight = 0;
    
    float newHeight = 0;
    
    NSMutableArray *listTutorialActions = [_sequenceData objectForKey:@"ActionSequence"];
    if (listTutorialActions.count > 0){
        for (NSMutableDictionary *actionData in listTutorialActions){
            
            //get duration time from data
            float durationTime = [self durationTimeFromActionData:actionData];
            if (durationTime == 0){
                oldHeight ++;
            }else{
                if (newHeight < oldHeight){
                    newHeight = oldHeight;
                    oldHeight = 0;
                }
            }
            
        }
        if (newHeight < oldHeight){
            newHeight = oldHeight;
        }
    }
    if (newHeight > 0)
        return newHeight * 12 + 10; //old: newHeight * 32 + 10
    return 22; //old 42
}


+(float)getTotalHeightFromTutorialData:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex{
    
    float totalHeight = 0;
    
    NSMutableArray *listActions = nil;
    
    //check to see if there is any story
    if(_storyIndex >= 0)
        listActions = [TutorialData getListActionsWithStoryIndex:_storyIndex ofData:_tutorialData];
    
    
    if (listActions.count > 0){
        
        for (int i = 0; i < listActions.count; i++){
            NSMutableDictionary *sequenceData = [listActions objectAtIndex:i];
            
            totalHeight +=[self getHeightFromSequenceData:sequenceData];
        }
    }
    return totalHeight;
}

+(int)checkTypeActionSequenceSelected:(NSString *)_actionSequenceName {
    if([_actionSequenceName isEqualToString:@"MovingEaseIn"] || [_actionSequenceName isEqualToString:@"MovingEaseOut"] || [_actionSequenceName isEqualToString:@"MovingEaseInOut"] || [_actionSequenceName isEqualToString:@"MovingEaseOutIn"] || [_actionSequenceName isEqualToString:@"MovingSequence"]) {
        
        return ACTION_TYPE_MOVING;
        
    } else {
        return ACTION_TYPE_COCOS_2D;
    }
}

+(int)checkTypeActionSelected:(NSString *)_actionName {
    if([_actionName rangeOfString:@"Moving"].location !=NSNotFound) {
        
        return ACTION_TYPE_MOVING;
        
    } else {
        return ACTION_TYPE_COCOS_2D;
    }
}

+(void)registerUserFont:(NSString *)_fontPath{
    if ([[_fontPath lowercaseString] hasSuffix:@".ttf"])
    {
        // This is a file, register font with font manager
        NSString* fontFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:_fontPath];
        NSURL* fontURL = [NSURL fileURLWithPath:fontFile];
        CTFontManagerRegisterFontsForURL((CFURLRef)fontURL, kCTFontManagerScopeProcess, NULL);
    }
}

+(NSString*) getFormatTimeString:(float)time
{
    int mins = floorf(time / 60);
    int secs = ((int)time) % 60;
    int frames = roundf((time - floorf(time)) * 99);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", mins,secs,frames];
}

+(void)expandView:(NSView*)_view withWidh:(float)_width andHeight:(float)_height{
    if (_view.frame.size.width < _width){
        [_view setFrameSize:NSMakeSize(_width , _view.frame.size.height)];
    }
    
    if (_view.frame.size.height < _height){
        [_view setFrameSize:NSMakeSize(_view.frame.size.width, _height)];
    }
}

+(BOOL)isRect:(NSRect)_1stRect hasPartsInRect:(NSRect)_2ndRect{
    
    float _1stRectLeft = _1stRect.origin.x;
    float _1stRectRight = _1stRect.origin.x + _1stRect.size.width;
    float _1stRectTop = _1stRect.origin.y + _1stRect.size.height;
    float _1stRectBottom = _1stRect.origin.y;
    
    float _2ndRectLeft = _2ndRect.origin.x;
    float _2ndRectRight = _2ndRect.origin.x+ _2ndRect.size.width;
    float _2ndRectTop = _2ndRect.origin.y + _2ndRect.size.height;
    float _2ndRectBottom = _2ndRect.origin.y;
    
//    if (_1stRectLeft >= _2ndRectLeft && _1stRectLeft <= _2ndRectRight)
//        return YES;
//    
//    if (_1stRectRight >= _2ndRectLeft && _1stRectRight <= _2ndRectRight)
//        return YES;
//    
//    if (_1stRectTop >= _2ndRectBottom && _1stRectTop <= _2ndRectTop)
//        return YES;
//    
//    if (_1stRectBottom >= _2ndRectBottom && _1stRectLeft <= _2ndRectTop)
//        return YES;
    
    if (_1stRectLeft <= _2ndRectRight && _2ndRectLeft <= _1stRectRight && _1stRectBottom <= _2ndRectTop && _2ndRectBottom <= _1stRectTop){
        return YES;
    }
    
    return NO;  
}

@end
