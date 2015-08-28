//
//  Test01ResourceManager.h
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "ResourceManager.h"

@interface TestTutorialResourceManager : ResourceManager {
    CCSpriteBatchNode *ballSpriteBatchNote;
}

-(void)loadAllResources;

@property (nonatomic, retain) CCSpriteBatchNode *ballSpriteBatchNote;

@end
