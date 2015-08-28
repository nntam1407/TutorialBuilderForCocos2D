//
//  TutorialLibDefine.h
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef LibGame_TutorialLibDefine_h
#define LibGame_TutorialLibDefine_h


//key to get object dictinary data
#define TUTORIAL_STANDARD_OBJECT_KEY                                     @"ListStandardObjects"

//key from object data dictionary
#define TUTORIAL_OBJECT_TYPE_KEY                                @"ObjectType"
#define TUTORIAL_OBJECT_NAME_KEY                            @"Name"
#define TUTORIAL_OBJECT_TYPE_SPRITE                             @"Sprite"
#define TUTORIAL_OBJECT_TYPE_TEXT                               @"Text"
#define TUTORIAL_OBJECT_TYPE_BUTTON                               @"Button"
#define TUTORIAL_OBJECT_TYPE_PARTICLE                               @"Particle"
#define TUTORIAL_OBJECT_TYPE_MOVING_OBJECT                               @"MovingObject"

#define TUTORIAL_OBJECT_ANIMATION_KEY                           @"Animation"

//define key name of object parameter from plist data file
#define TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY                     @"Width"
#define TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY                    @"Height"
#define TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY                   @"ScaleX"
#define TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY                   @"ScaleY"
#define TUTORIAL_OBJECT_PARAMETER_POS_X_KEY                     @"PosX"
#define TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY                     @"PosY"
#define TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY                  @"Rotation"
#define TUTORIAL_OBJECT_PARAMETER_VISIBLE                       @"Visible"
#define TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_X                @"AnchorPointX"
#define TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_Y                @"AnchorPointY"
#define TUTORIAL_OBJECT_PARAMETER_Z_INDEX                       @"z_index"
#define TUTORIAL_OBJECT_PARAMETER_OPACITY                       @"Opacity"

#define TUTORIAL_OBJECT_PARAMETER_TEXT_CONTENT                  @"TextContent"
#define TUTORIAL_OBJECT_PARAMETER_FONT_NAME                     @"FontName"
#define TUTORIAL_OBJECT_PARAMETER_FONT_SIZE                     @"FontSize"
#define TUTORIAL_OBJECT_PARAMETER_COLOR_R                  @"Color_R"
#define TUTORIAL_OBJECT_PARAMETER_COLOR_G                  @"Color_G"
#define TUTORIAL_OBJECT_PARAMETER_COLOR_B                  @"Color_B"

//define key name of object sprite key from plist data file
#define TUTORIAL_OBJECT_IS_USE_SPRITE_FRAME                           @"IsUseSpriteFrame"
#define TUTORIAL_OBJECT_IS_USE_PARTICLE_FILE                    @"IsUseParticleFile"

#define TUTORIAL_OBJECT_SPRITE_FILE_NAME                        @"FileName"
#define TUTORIAL_OBJECT_SPRITE_FRAME_NAME                       @"FrameName"

#define TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FILE_NAME          @"NormalFileName"
#define TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FILE_NAME          @"ActiveFileName"
#define TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FRAME_NAME          @"NormalFrameName"
#define TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FRAME_NAME          @"ActiveFrameName"

#define TUTORIAL_RESOURCES                                      @"Resources"
#define TUTORIAL_RESOURCES_LIST_TEXTURE_PLIST                   @"TexturePlist"
#define TUTORIAL_RESOURCES_TEXTURE_FILE_PATH                   @"Texture"

#define TUTORIAL_STORYBOARD_ACTIONS_KEY                         @"Actions"
#define TUTORIAL_STORYBOARD_OBJECTS_KEY                         @"Objects"
#define TUTORIAL_STORYBOARD_STORY_KEY                                   @"Story"
#define TUTORIAL_STORYBOARD_ACTION_KEY                                   @"Action"
#define TUTORIAL_STORYBOARD_ACTION_SEQUENCE_ITEM_KEY                                   @"ActionSequenceItem"

//define key name of storyboard key from plist data file
#define TUTORIAL_STORYBOARD                                     @"Storyboard"
#define TUTORIAL_STORYBOARD_ACTIONS_KEY                         @"Actions"
#define TUTORIAL_STORYBOARD_OBJECTS_KEY                         @"Objects"
#define TUTORIAL_STORY_PREFIX                                   @"Story_"

#define TUTORIAL_RESOURCES                                      @"Resources"
#define TUTORIAL_RESOURCES_LIST_TEXTURE_PLIST                   @"TexturePlist"

//define key name of object particle from plist file data
#define TUTORIAL_OBJECT_PARTICLE_NAME               @"ParticleName"
#define TUTORIAL_OBJECT_PARTICLE_CUSTOM_FILE_NAME          @"CustomParticleFileName"
#define TUTORIAL_PARTICLE_SUN                           @"ParticleSun"
#define TUTORIAL_PARTICLE_EXPLOSION                 @"ParticleExplosion"
#define TUTORIAL_PARTICLE_FIRE                      @"ParticleFire"
#define TUTORIAL_PARTICLE_FIREWORKS                     @"ParticleFireworks"
#define TUTORIAL_PARTICLE_FLOWER                    @"ParticleFlower"
#define TUTORIAL_PARTICLE_GALAXY                    @"ParticleGalaxy"
#define TUTORIAL_PARTICLE_METEOR                    @"ParticleMeteor"
#define TUTORIAL_PARTICLE_RAIN                      @"ParticleRain"
#define TUTORIAL_PARTICLE_SMOKE                         @"ParticleSmoke"
#define TUTORIAL_PARTICLE_SNOW                      @"ParticleSnow"
#define TUTORIAL_PARTICLE_SPIRAL                    @"ParticleSpiral"

//define key name for action data
#define TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME                    @"Object"
#define TUTORIAL_ACTION_DATA_KEY_REORDER_OBJECT_Z_INDEX                    @"zOrder"
#define TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE                    @"ActionType"
#define TUTORIAL_ACTION_DATA_KEY_DURATION                       @"Duration"
#define TUTORIAL_ACTION_DATA_KEY_DESTINATION_X                  @"Destination_X"
#define TUTORIAL_ACTION_DATA_KEY_DESTINATION_Y                  @"Destination_Y"
#define TUTORIAL_ACTION_DATA_KEY_SCHEDULE_AFTER_TIME            @"ScheduleAfterTime"
#define TUTORIAL_ACTION_DATA_KEY_REPEAT                         @"Repeat"
#define TUTORIAL_ACTION_DATA_KEY_SCALE_X                        @"ScaleX"
#define TUTORIAL_ACTION_DATA_KEY_SCALE_Y                        @"ScaleY"
#define TUTORIAL_ACTION_DATA_KEY_JUMPS                          @"Jumps"
#define TUTORIAL_ACTION_DATA_KEY_JUMP_HEIGHT                    @"JumpHeight"
#define TUTORIAL_ACTION_DATA_KEY_EASE_TYPE                       @"EaseType"

#define TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_1_X                  @"ControlPoint1_X"
#define TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_1_Y                  @"ControlPoint1_Y"
#define TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_2_X                  @"ControlPoint2_X"
#define TUTORIAL_ACTION_DATA_KEY_CONTROL_POINT_2_Y                  @"ControlPoint2_Y"
#define TUTORIAL_ACTION_DATA_KEY_FADE_OPACITY                                               @"FadeOpacity"
#define TUTORIAL_ACTION_DATA_KEY_ROTATE_ANGLE                       @"Angle"
#define TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP                       @"AnimationLoop"
#define TUTORIAL_ACTION_DATA_KEY_ANIMATION_LOOP_DELAY                       @"AnimationLoopDelay"
#define TUTORIAL_ACTION_DATA_KEY_ANIMATION_FRAME_DELAY                       @"FrameDelay"
#define TUTORIAL_ACTION_DATA_KEY_ANIMATION_RESTORE_FRAME                       @"RestoreOriginalFrame"
#define TUTORIAL_ACTION_DATA_KEY_ANIMATION_LIST_FRAMES                       @"Frames"
#define TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTAS                       @"Deltas"
#define TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTA_X_VALUE                       @"Delta_X"
#define TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTA_Y_VALUE                       @"Delta_Y"
#define TUTORIAL_ACTION_DATA_KEY_CUSTOM_MOVE_DELTA_DURATION                       @"MoveDuration"
#define TUTORIAL_ACTION_DATA_ACTION_SEQUENCE                         @"ActionSequence"
#define TUTORIAL_ACTION_DATA_ACTION_EASE_RATE                               @"Rate"
#define TUTORIAL_ACTION_DATA_ACTION_EASE_PERIOD                               @"Period"

//define key for special actions
#define TUTORIAL_ACTION_DATA_KEY_START_Amplitude                      @"StartAmplitude"
#define TUTORIAL_ACTION_DATA_KEY_END_Amplitude                      @"EndAmplitude"
#define TUTORIAL_ACTION_DATA_KEY_MAX_Amplitude                              @"MaxAmplitude"
#define TUTORIAL_ACTION_DATA_KEY_MIN_Amplitude                              @"MinAmplitude"
#define TUTORIAL_ACTION_DATA_KEY_Amplitude                              @"Amplitude"
#define TUTORIAL_ACTION_DATA_KEY_LOOP                                       @"Loop"
#define TUTORIAL_ACTION_DATA_KEY_POSITIVE                                       @"Positive"
#define TUTORIAL_ACTION_DATA_KEY_INCREASE                                       @"Increase"
#define TUTORIAL_ACTION_DATA_KEY_NUMBER_SPRING                                       @"NumberSpring"
#define TUTORIAL_ACTION_DATA_KEY_CLOCKWISE                                       @"Clockwise"
#define TUTORIAL_ACTION_DATA_KEY_DISTANCE_INTERVAL              @"DistanceInterval"


//define list action enum
#define TUTORIAL_ACTION_CALL_FUNCTION_IN_GAME                                 @"CallFunctionInGame"
#define TUTORIAL_ACTION_MOVING_CALL_FUNCTION_IN_GAME                                 @"MovingCallFunctionInGame" //this action use in moving controller
#define TUTORIAL_ACTION_DATA_KEY_NAME_OF_FUNCTION_IN_GAME                    @"NameOfFunctionInGame"

#define TUTORIAL_ACTION_MOVE_TO                                 @"MoveTo"
#define TUTORIAL_ACTION_MOVE_BY                                 @"MoveBy"
#define TUTORIAL_ACTION_JUMP_TO                                 @"JumpTo"
#define TUTORIAL_ACTION_JUMP_BY                                 @"JumpBy"
#define TUTORIAL_ACTION_BEZIER_TO                               @"BezierTo"
#define TUTORIAL_ACTION_BEZIER_BY                               @"BezierBy"
#define TUTORIAL_ACTION_SHOW                                    @"Show"
#define TUTORIAL_ACTION_HIDE                                    @"Hide"

#define TUTORIAL_ACTION_FADE_IN                                    @"FadeIn"
#define TUTORIAL_ACTION_FADE_OUT                                    @"FadeOut"
#define TUTORIAL_ACTION_FADE_TO                                    @"FadeTo"
#define TUTORIAL_ACTION_SCALE_TO                                    @"ScaleTo"
#define TUTORIAL_ACTION_SCALE_BY                                    @"ScaleBy"
#define TUTORIAL_ACTION_ROTATE_TO                                    @"RotateTo"
#define TUTORIAL_ACTION_ROTATE_BY                                    @"RotateBy"
#define TUTORIAL_ACTION_SEQUENCE                                    @"Sequence"
#define TUTORIAL_ACTION_PLACE                                    @"Place"
#define TUTORIAL_ACTION_DELAY                                    @"Delay"
#define TUTORIAL_ACTION_CUSTOM_MOVE                                    @"CustomMove"
#define TUTORIAL_ACTION_RUN_ANIMATION                                    @"RunAnimation"

#define TUTORIAL_ACTION_EASE_IN                                    @"EaseIn"
#define TUTORIAL_ACTION_EASE_OUT                                    @"EaseOut"
#define TUTORIAL_ACTION_EASE_IN_OUT                                   @"EaseInOut"
#define TUTORIAL_ACTION_EASE_EXPONENTIAL_IN                                    @"EaseExponentialIn"
#define TUTORIAL_ACTION_EASE_EXPONENTIAL_OUT                                    @"EaseExponentialOut"
#define TUTORIAL_ACTION_EASE_EXPONENTIAL_IN_OUT                                    @"EaseExponentialInOut"
#define TUTORIAL_ACTION_EASE_SINE_IN                                    @"EaseSineIn"
#define TUTORIAL_ACTION_EASE_SINE_OUT                                    @"EaseSineOut"
#define TUTORIAL_ACTION_EASE_SINE_IN_OUT                                    @"EaseSineInOut"
#define TUTORIAL_ACTION_EASE_ELASTIC_IN                                    @"EaseElasticIn"
#define TUTORIAL_ACTION_EASE_ELASTIC_OUT                                    @"EaseElasticOut"
#define TUTORIAL_ACTION_EASE_ELASTIC_IN_OUT                                    @"EaseElasticInOut"
#define TUTORIAL_ACTION_EASE_BOUNCE_IN                                    @"EaseBounceIn"
#define TUTORIAL_ACTION_EASE_BOUNCE_OUT                                    @"EaseBounceOut"
#define TUTORIAL_ACTION_EASE_BOUNCE_IN_OUT                                    @"EaseBounceInOut"
#define TUTORIAL_ACTION_EASE_BACK_IN                                  @"EaseBackIn"
#define TUTORIAL_ACTION_EASE_BACK_OUT                                    @"EaseBackOut"
#define TUTORIAL_ACTION_EASE_BACK_IN_OUT                                    @"EaseBackInOut"

//Special moving object of GameLib
#define TUTORIAL_ACTION_MOVING_EASE_IN                                    @"MovingEaseIn"
#define TUTORIAL_ACTION_MOVING_EASE_OUT                                    @"MovingEaseOut"
#define TUTORIAL_ACTION_MOVING_EASE_IN_OUT                                    @"MovingEaseInOut"
#define TUTORIAL_ACTION_MOVING_EASE_OUT_IN                                    @"MovingEaseOutIn"
#define TUTORIAL_ACTION_ZICZAC_MOVING                                    @"ZiczacMoving"
#define TUTORIAL_ACTION_ELIP_MOVING                                    @"ElipMoving"
#define TUTORIAL_ACTION_SPRING_MOVING                                    @"SpringMoving"
#define TUTORIAL_ACTION_FERMAT_SPIRAL_MOVING                                    @"FermatSpiralMoving"
#define TUTORIAL_ACTION_WAVY_SIN_MOVING                                    @"WavySinMoving"
#define TUTORIAL_ACTION_ROUND_MOVING                                    @"RoundMoving"
#define TUTORIAL_ACTION_MOVING_REPEAT                                    @"MovingRepeat"
#define TUTORIAL_ACTION_MOVING_REPEAT_FOREVER                                    @"MovingRepeatForever"
#define TUTORIAL_ACTION_MOVING_SEQUENCE                                    @"MovingSequence"
#define TUTORIAL_ACTION_LINEAR_MOVING                                    @"LinearMoving"
#define TUTORIAL_ACTION_CUSTOM_SPRING_MOVING                                    @"CustomSpringMoving"
#define TUTORIAL_ACTION_MOVING_REVERT                                    @"MovingRevert"
#define TUTORIAL_ACTION_MOVING_REVERT_FOREVER                                   @"MovingRevertForever"
#define TUTORIAL_ACTION_MOVING_DELAY                                   @"MovingDelay"

#define TUTORIAL_ACTION_ON_POINT_MOVING                                   @"OnPointMoving"
#define TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT                                   @"ListOnPoint"
#define TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT_MEMBER                                   @"OnPoint"
#define TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT_PARAMETER_POS_X                                   @"PosX"
#define TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT_PARAMETER_POS_Y                                   @"PosY"

#define TUTORIAL_ACTION_LIST_ANIMATION_FRAMES                                   @"Frames"
#define TUTORIAL_ACTION_LIST_ANIMATION_FRAMES_MEMBER                                                 @"Frame"

#endif
