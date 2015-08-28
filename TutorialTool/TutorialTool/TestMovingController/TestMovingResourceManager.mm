//
//  TestMovingResourceManager.m
//  LibGame
//
//  Created by VienTran on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestMovingResourceManager.h"

@implementation TestMovingResourceManager

-(void)loadAllResources {
    CCTexture2D *imagesTexture = [[CCTextureCache sharedTextureCache] addImage:@"TestMovingControllerResources/Images/ImagesPlist.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TestMovingControllerResources/Images/ImagesPlist.plist" texture:imagesTexture];
}

@end

