//
//  Test01ResourceManager.m
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "TestTutorialResourceManager.h"

@implementation TestTutorialResourceManager

@synthesize ballSpriteBatchNote;

-(void)loadAllResources {
    [self loadBallResources]; 

}

-(void)loadBallResources {
    CCSpriteBatchNode *bathNoteTemp = [[CCSpriteBatchNode alloc]initWithFile:@"TestTutorialLib/Images/soccer-ball1.png" capacity:1];
    CCSpriteFrame *frame = [[CCSpriteFrame alloc]initWithTexture:bathNoteTemp.texture rect:CGRectMake(0, 0, bathNoteTemp.texture.contentSize.width, bathNoteTemp.texture.contentSize.height)];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:@"Bee_01.png"];
}

@end
