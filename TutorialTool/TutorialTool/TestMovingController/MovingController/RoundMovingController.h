//
//  RoundMovingController.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingController.h"

@interface RoundMovingController : MovingController{
    float radius;
    CGPoint endPos;
    CGPoint startPos;
    float cycle;
    float totalTime;
    CGPoint center;
    float iniPhase;
    BOOL clockwise;
}

+(id)roundMovingWithDuration:(ccTime)_duration position:(CGPoint)_p clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate;
-(id)initRoundMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p clockwise:(BOOL)_clockwise andRotateTarget:(BOOL)_isRotate;

@end

////Lấy trục từ đi từ điểm xuất phát đến điểm kết thúc làm trục đứng hướng lên trên làm trục tâm
//enum RoundMoveDirection {
//    Direction1 = 1, //Tâm đường tròn năm ở bên phải trục tâm và quay theo chiều kim đồng hồ
//    Direction2 = 2, //Tâm đường tròn nằm ở bên phải trục tâm và quay ngược chiều kim đồng hồ
//    Direction3 = 3, //Tâm đường tròn năm ở bên trái trục tâm và quay theo chiều kim đồng hồ
//    Direction4 = 4  //Tâm đường tròn năm ở bên trái trục tâm và quay ngược chiều kim đồng hồ
//    };
//
//@interface RoundMovingController : MovingController{
//    float radius;
//    CGPoint endPos;
//    CGPoint startPos;
//    float cycle;
//    float totalTime;
//    RoundMoveDirection roundDirection;
//    
//    CGPoint center;
//    float iniPhase;
//    float amplitudeX;
//    float amplitudeY;
//}
//
//+(id)roundMovingWithDuration:(ccTime)_duration position:(CGPoint)_p radius:(float)_radius roundDirection:(RoundMoveDirection)_roundDirection ;
//-(id)initRoundMovingControllerWithDuration:(ccTime)_duration position:(CGPoint)_p radius:(float)_radius roundDirection:(RoundMoveDirection)_roundDirection;
//
//@end
