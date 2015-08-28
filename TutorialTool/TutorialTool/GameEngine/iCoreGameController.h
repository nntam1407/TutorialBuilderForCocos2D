//
//  iCoreGameController.h
//  Cocos2dBox2dGameStructure
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "cocos2d.h"
#import "ResourceManager.h"
#import "GameLayer.h"

@interface iCoreGameController : NSObject {
    CCDirector *director;
    ResourceManager *resoucesManager;
    CGSize winSize;
}

-(id)initCoreGameControllerWith:(CCDirector*)_director;
-(void)startUp;
-(void)runWith:(GameLayer*)_gameLayer;

@property (nonatomic, retain)ResourceManager *resoucesManager;
@property (nonatomic, assign)CGSize winSize;


@end
