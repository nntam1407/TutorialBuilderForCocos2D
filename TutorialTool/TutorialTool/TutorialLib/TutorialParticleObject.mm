//
//  TutorialParticleObject.m
//  LibGame
//
//  Created by k3 on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialParticleObject.h"
#import "TutorialSpriteLib.h"

@implementation TutorialParticleObject

-(id)initTutorialParticleObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData
{
    self=[super initTutorialObjectWith:_tutorialStorboardHandler withData:_objectData];    
    [self loadParticle];
    return self;
}

-(void)loadParticle {
    
    if(spriteBody) {
        [spriteBody removeFromParentAndCleanup:YES];
        [spriteBody release];
        spriteBody = nil;
    }
    
    //get properties for particle type
    NSString *particleName = [objectData objectForKey:TUTORIAL_OBJECT_PARTICLE_NAME];
    NSString *customParticleFileName = [objectData objectForKey:TUTORIAL_OBJECT_PARTICLE_CUSTOM_FILE_NAME];
    
    int isUseParticleFileName = [[objectData objectForKey:TUTORIAL_OBJECT_IS_USE_PARTICLE_FILE] intValue];
    
    if(isUseParticleFileName == 1 && customParticleFileName != nil && ![customParticleFileName isEqualToString:@""]) {
        
        spriteBody = (CCSprite *)[self particleCustomWithFileName:[NSString stringWithFormat:@"%@%@", tutorialResourcePath, customParticleFileName]];
        
    } else {
        spriteBody = (CCSprite *)[self getParticleWithName:particleName];
    }
}

-(void)applyObjectBodyProperties{
    //since the particle is released when the story's released, we have to reload it
    [self loadParticle];
    [super applyObjectBodyProperties];
    
    float rotation = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY] floatValue];
    spriteBody.rotation = rotation;
}

-(CCParticleSystem *)getParticleWithName:(NSString*)_particleName{
    CCParticleSystem* particle;
    if([_particleName isEqualToString:TUTORIAL_PARTICLE_SUN]){
        particle=[[CCParticleSun alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_EXPLOSION]){
        particle=[[CCParticleExplosion alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_FLOWER]){
        particle=[[CCParticleFlower alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_FIRE]){
        particle=[[CCParticleFire alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_FIREWORKS]){
        particle=[[CCParticleFireworks alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_GALAXY]){
        particle=[[CCParticleGalaxy alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_METEOR]){
        particle=[[CCParticleMeteor alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_RAIN]){
        particle=[[CCParticleRain alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_SMOKE]){
        particle=[[CCParticleSmoke alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_SNOW]){
        particle=[[CCParticleSnow alloc]init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_SPIRAL]){
        particle=[[CCParticleSpiral alloc]init];
    }
    return particle;
}

-(CCParticleSystem *)particleCustomWithFileName:(NSString*)_particleFileName{
    CCParticleSystem* particle = [[CCParticleSystemQuad alloc] initWithFile:_particleFileName];
    return particle;
}


-(BOOL)isPointInSpriteRectWithPoint:(CGPoint)_point{	
    CCNode *tempNode = [CCNode node];
    
    [tempNode setContentSize:CGSizeMake(32, 32)];
    tempNode.rotation = spriteBody.rotation;
    tempNode.scale = spriteBody.scale;
    tempNode.anchorPoint = spriteBody.anchorPoint;
    tempNode.position = spriteBody.position;
    
    return [Helpers isPoint:_point insideNode:tempNode];
}

-(void)dealloc {
    
    [((CCParticleSystem *)spriteBody) stopSystem];
    [spriteBody removeAllChildrenWithCleanup:YES];
    [spriteBody removeFromParentAndCleanup:YES];
    [spriteBody release];
    spriteBody = nil;

    [super dealloc];
}

@end
