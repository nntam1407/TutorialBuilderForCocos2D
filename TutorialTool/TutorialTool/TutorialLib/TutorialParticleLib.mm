//
//  TutorialParticleLib.m
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialParticleLib.h"

@implementation TutorialParticleLib

+(CCParticleSystem *)getParticleWithName:(NSString*)_particleName {
    CCParticleSystem* particle;
    
    if([_particleName isEqualToString:TUTORIAL_PARTICLE_SUN]){
        particle=[[CCParticleSun alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_EXPLOSION]){
        particle = [[CCParticleExplosion alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_FLOWER]){
        particle = [[CCParticleFlower alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_FIRE]){
        particle = [[CCParticleFire alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_FIREWORKS]){
        particle = [[CCParticleFireworks alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_GALAXY]){
        particle = [[CCParticleGalaxy alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_METEOR]){
        particle = [[CCParticleMeteor alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_RAIN]){
        particle=[[CCParticleRain alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_SMOKE]){
        particle = [[CCParticleSmoke alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_SNOW]){
        particle = [[CCParticleSnow alloc] init];
        
    }else if([_particleName isEqualToString:TUTORIAL_PARTICLE_SPIRAL]){
        particle = [[CCParticleSpiral alloc] init];
    }
    
    return particle;
}


+(CCParticleSystem *)particleCustomWithFileName:(NSString*)_particleFileName {
    NSString *filePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:_particleFileName];
    CCParticleSystem* particle = [[CCParticleSystemQuad alloc] initWithFile:filePath];
    
    return particle;
}

@end
