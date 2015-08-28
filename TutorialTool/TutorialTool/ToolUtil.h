//
//  ToolUtil.h
//  TutorialTool
//
//  Created by User on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ACTION_TYPE_COCOS_2D = 0,
    ACTION_TYPE_MOVING
};

@interface ToolUtil : NSObject

+(BOOL)copyFileFromSrc:(NSString *)_srcFileName toDes:(NSString *)_desFileName;

+(void)clearAllFilesInPath:(NSString *)_path;

+(void)clearAllFilesExceptSubFoldersInPath:(NSString *)_path;

+(BOOL)deleteFileWithPath:(NSString *)_path;

+(NSString *)setString:(NSString *)_string;

+(float)durationTimeFromActionData:(NSMutableDictionary *)_actionData;

+(float)getHeightFromSequenceData:(NSMutableDictionary *)_sequenceData;

+(float)getTotalHeightFromTutorialData:(NSMutableDictionary *)_tutorialData withStoryIndex:(int)_storyIndex;

+(int)checkTypeActionSequenceSelected:(NSString *)_actionSequenceName;

+(int)checkTypeActionSelected:(NSString *)_actionName ;

+(void)registerUserFont:(NSString *)_fontPath;

+(NSString*) getFormatTimeString:(float)time;

+(void)expandView:(NSView*)_view withWidh:(float)_width andHeight:(float)_height;

+(BOOL)isRect:(NSRect)_1stRect hasPartsInRect:(NSRect)_2ndRect;
@end
