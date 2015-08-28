//
//  ResourceManager.m
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "ResourceManager.h"

@implementation ResourceManager
    
-(id)initResourceManagerWith:(iCoreGameController*)_mainGameController {
    self = [super init];
    mainGameController = _mainGameController;
    return self;
}

@end
