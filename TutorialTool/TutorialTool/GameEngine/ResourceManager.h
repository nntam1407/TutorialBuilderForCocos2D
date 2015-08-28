//
//  ResourceManager.h
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "cocos2d.h"

@class iCoreGameController;

@interface ResourceManager : NSObject {
    iCoreGameController *mainGameController;
}

-(id)initResourceManagerWith:(iCoreGameController*)_mainGameController;

@end
