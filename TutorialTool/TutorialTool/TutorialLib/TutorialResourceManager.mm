//
//  TutorialResourceManager.m
//  LibGame
//
//  Created by User on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialResourceManager.h"
#import "cocos2d.h"
#import "TutorialLibDefine.h"
#import "TutorialSpriteLib.h"

@implementation TutorialResourceManager

+(void)loadTextureFromFile:(NSString *)_textureFileName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:_textureFileName];
}

+(void)loadTextureFromArrayFile:(NSMutableArray *)_listTextureFileName {
    for (NSString *fileName in _listTextureFileName) {
        [self loadTextureFromFile:[NSString stringWithFormat:@"%@%@", tutorialResourcePath, fileName]];
    }
}

+(void)removeTextureFromFile:(NSString *)_textureFileName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:_textureFileName];
}

+(void)removeTextureFromArrayFile:(NSMutableArray *)_listTextureFileName {
    for (NSString *fileName in _listTextureFileName) {
        [self removeTextureFromFile:fileName];
    }
}

+(void)loadTextureFromImageFile:(NSString *)_imageFileName {
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@%@", tutorialResourcePath, _imageFileName]];
    
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:_imageFileName];
}

+(void)loadTextureFromListImageFiles:(NSMutableArray *)_listImageFile {
    for (NSString *fileName in _listImageFile) {
        [self loadTextureFromImageFile:fileName];
    }
}

@end
