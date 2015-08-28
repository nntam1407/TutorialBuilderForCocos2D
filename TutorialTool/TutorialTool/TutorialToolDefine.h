//
//  TutorialToolDefine.h
//  TutorialTool
//
//  Created by User on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TutorialTool_TutorialToolDefine_h
#define TutorialTool_TutorialToolDefine_h

#define RESOURCE_CACHE_DIR                         @"ResourceCache/"

#define MAIN_WINDOWS_LARGE_HEIGHT                   852
#define MAIN_WINDOWS_SMALL_HEIGHT                   480

#define MAIN_WINDOWS_LARGE_WIDTH                    1000
#define MAIN_WINDOWS_SMALL_WIDTH                    500

//Define device type
enum {
    DEVICE_TYPE_IPHONE_4 = 0,
    DEVICE_TYPE_IPHONE_4_RETINA,
    DEVICE_TYPE_IPHONE_5,
    DEVICE_TYPE_IPHONE_5_RETINA,
    DEVICE_TYPE_IPAD,
    DEVICE_TYPE_IPAD_RETINA,
    DEVICE_TYPE_CUSTOM_RESOLUTION
};

enum {
    DEVICE_VIEW_MODE_LANDSCAPE = 0,
    DEVICE_VIEW_MODE_PORTRAIL
};

enum{
    ACTION_TIMELINE_UNSELECT_STATE = 0,
    ACTION_TIMELINE_SAME_TARGET_SELECT_STATE,
    ACTION_TIMELINE_SELECT_STATE
};

static const CGSize DEVICE_SIZE_IPHONE_4_LANDSCAPE = { 480, 320 };
static const CGSize DEVICE_SIZE_IPHONE_4_PORTRAIL = { 320, 480 };
static const CGSize DEVICE_SIZE_IPHONE_5_LANDSCAPE = { 568, 320 };
static const CGSize DEVICE_SIZE_IPHONE_5_PORTRAIL = { 320, 568 };
static const CGSize DEVICE_SIZE_IPAD_LANDSCAPE = { 1024, 768 };
static const CGSize DEVICE_SIZE_IPAD_PORTRAIL = { 768, 1024 };

#define EDITOR_MIN_ZOOM                              0.2
#define EDITOR_MAX_ZOOM                              2.0
#define EDITOR_ZOOM_UNIT                             0.05

#define RIGHT_BAR_DEFAULT_HEIGHT                        407

#define DOCUMENTVIEW_EDIT_IPHONE_LANDSCAPE_HEIGHT     405
#define DOCUMENTVIEW_EDIT_IPHONE_PORTRAIL_HEIGHT      730

#define IPHONE_LANDSCAPE_WIDTH                      480
#define IPHONE_LANDSCAPE_HEIGHT                     320
#define IPHONE_LANDSCAPE_ORIGIN_X                     125
#define IPHONE_LANDSCAPE_ORIGIN_Y                     44
#define IPHONE_PORTRAIL_WIDTH                       320
#define IPHONE_PORTRAIL_HEIGHT                       480
#define IPHONE_PORTRAIL_ORIGIN_X                     205
#define IPHONE_PORTRAIL_ORIGIN_Y                     125

#define IMAGEVIEW_IPHONE_LANDSCAPE_HEIGHT           403
#define IMAGEVIEW_IPHONE_LANDSCAPE_ORIGIN_X           0
#define IMAGEVIEW_IPHONE_LANDSCAPE_ORIGIN_Y          2
#define IMAGEVIEW_IPHONE_PORTRAIL_HEIGHT            730
#define IMAGEVIEW_IPHONE_PORTRAIL_ORIGIN_X           0
#define IMAGEVIEW_IPHONE_PORTRAIL_ORIGIN_Y          0

#define TUTORIAL_TOOL_OBJECT_TYPE_SPRITE            0
#define TUTORIAL_TOOL_OBJECT_TYPE_BUTTON            1
#define TUTORIAL_TOOL_OBJECT_TYPE_TEXT              2
#define TUTORIAL_TOOL_OBJECT_TYPE_PARTICLE          3

#define SPLIT_LIST_ON_POINT_EPXILON_VALUE           5

#define LIST_ACTION_SEQUENCE_COUNT                  24

#define TIMELINE_PIXEL_PER_UNIT                    100 //Old value 100
#define TIMELINE_DIVISION_COUNT_PER_UINIT           5 //old 5

static NSString *listSequenceAction[] = {
    @"Sequence",
    @"MovingSequence",
    @"EaseIn",
    @"EaseOut",
    @"EaseInOut",
    @"EaseExponentialIn",
    @"EaseExponentialOut",
    @"EaseExponentialInOut",
    @"EaseSineIn",
    @"EaseSineOut",
    @"EaseSineInOut",
    @"EaseElasticIn",
    @"EaseElasticOut",
    @"EaseElasticInOut",
    @"EaseBounceIn",
    @"EaseBounceOut",
    @"EaseBounceInOut",
    @"EaseBackIn",
    @"EaseBackOut",
    @"EaseBackInOut",
    @"MovingEaseIn",
    @"MovingEaseOut",
    @"MovingEaseInOut",
    @"MovingEaseOutIn"
};

#define LIST_ACTION_TYPE_COUNT             22
static NSString *listActionTypes[] = {
    @"CallFunctionInGame",
    @"Show",
    @"Hide",
    @"MoveTo",
    //@"MoveBy",
    @"JumpTo",
    //@"JumpBy",
    //@"BezierTo",
    //@"BezierBy",
    @"FadeIn",
    @"FadeOut",
    @"FadeTo",
    @"ScaleTo",
    @"ScaleBy",
    @"RotateTo",
    @"RotateBy",
    @"Place",
    //@"Delay",
    @"RunAnimation",
    //@"LinearMoving",
    @"ZiczacMoving",
    @"ElipMoving",
    @"SpringMoving",
    @"FermatSpiralMoving",
    @"WavySinMoving",
    @"RoundMoving",
    //@"LinearMoving",
    @"CustomSpringMoving",
    //@"MovingRevert",
    //@"MovingDelay",
    @"OnPointMoving"
};

static NSString *listActionTypesDescriptions[] = {
    @"When run tutorial in game, this action will call function with name below!",
    @"Show object!",
    @"Hide object!",
    @"Move object to a destination point",
    //@"Move object by a distance X, Y",
    @"Object will jump a few times, with height value to destination point",
    //@"Object will jump a few times, with height value by delta point",
    @"Object changes transparent value from 0 to 255 in duration time",
    @"Object changes transparent value from 255 to 0 in duration time",
    @"Object changes transparent value from its current value to input value in duration time",
    @"Scale object to a specific number",
    @"Scale object by a specific number",
    @"Rotate object to a specific degree",
    @"Rotate object by a specific degree",
    @"Put object to destination point",
    //@"Delay",
    @"Create an animation from frames in texture resources",
    @"Object will move in ziczac way",
    @"Object will move in eclipse way",
    @"Object will move like the shape of a spring",
    @"Object will move like the shape of a spiral",
    @"Object will move in sine wave",
    @"Object will move in a circle",
    @"Object will move like the shape of a spring with other custom parameter",
    @"Move object with the way which you draw by mouse on screen!"
};

#define LIST_BASIC_PARTICLE_COUNT                    11
static NSString *listBasicParticle[] = {
    @"ParticleSun",
    @"ParticleExplosion",
    @"ParticleFire",
    @"ParticleFireworks",
    @"ParticleFlower",
    @"ParticleGalaxy",
    @"ParticleMeteor",
    @"ParticleRain",
    @"ParticleSmoke",
    @"ParticleSnow",
    @"ParticleSpiral"
};

#define LIST_COCOS_EASE_TYPE_COUNT                   19                 
static NSString *listCocosEaseType[] = {
    @"None",
    @"EaseIn",
    @"EaseOut",
    @"EaseInOut",
    @"EaseExponentialIn",
    @"EaseExponentialOut",
    @"EaseExponentialInOut",
    @"EaseSineIn",
    @"EaseSineOut",
    @"EaseSineInOut",
    @"EaseElasticIn",
    @"EaseElasticOut",
    @"EaseElasticInOut",
    @"EaseBounceIn",
    @"EaseBounceOut",
    @"EaseBounceInOut",
    @"EaseBackIn",
    @"EaseBackOut",
    @"EaseBackInOut",
};

#define LIST_MOVING_EASE_TYPE_COUNT                   5
static NSString *listMovingEaseType[] = {
    @"None",
    @"MovingEaseIn",
    @"MovingEaseOut",
    @"MovingEaseInOut",
    @"MovingEaseOutIn"
};

#define DEFAULT_IMAGE                                               @"missing-texture.png"
#define DEFAULT_PLIST_DATA_SPRITE                                               @"Default/Default_Sprite.plist"
#define DEFAULT_PLIST_DATA_BUTTON                                               @"Default/Default_Button.plist"
#define DEFAULT_PLIST_DATA_PARTICLE                                               @"Default/Default_Particle.plist"
#define DEFAULT_PLIST_DATA_TEXT                                               @"Default/Default_Text.plist"

//define key for project tpproject file
#define PROJECT_FILE_CURRENT_VERSION_VALUE                @"1.0"

#define PROJECT_FILE_VERSION_KEY                @"FileVer"
#define PROJECT_FILE_MAX_ZINDEX_OF_OBJECT_ADDED @"MaxZIndexOfObjectAdded"
#define PROJECT_FILE_KEY_XML_DATA           @"XmlData"
#define PROJECT_FILE_KEY_RESOURCE_PATH           @"ResourcePath"
#define PROJECT_FILE_KEY_RESOURCE_ELEMENTS           @"ResourceElements"
#define PROJECT_FILE_KEY_RESOURCE_PARTICLE_PLISTS           @"ParticlePlists"
#define PROJECT_FILE_KEY_RESOURCE_TEXTURE_PLISTS           @"TexturePlists"
#define PROJECT_FILE_KEY_RESOURCE_IMAGES           @"Images"
#define PROJECT_FILE_KEY_RESOURCE_FONTS           @"Fonts"
#define PROJECT_FILE_KEY_PROJECT_SETTING        @"ProjectSetting"
#define PROJECT_FILE_KEY_PROJECT_SETTING_DEVICE_MODE        @"DeviceMode"
#define PROJECT_FILE_KEY_PROJECT_SETTING_DEVICE_TYPE        @"DeviceType"
#define PROJECT_FILE_KEY_PROJECT_SETTING_CUSTOM_DEVICE_WIDTH        @"CustomDeviceWidth"
#define PROJECT_FILE_KEY_PROJECT_SETTING_CUSTOM_DEVICE_HEIGHT        @"CustomDeviceHeight"
#define PROJECT_FILE_KEY_TIMELINE_VIEW_INFO          @"TimeLineViewInfo"
#define PROJECT_FILE_KEY_TIMELINE_VIEW_INFO_LIST_ROW_INDEX_OF_ACTIONS          @"ListRowIndexOfActions"
#define PROJECT_FILE_KEY_TUTORIAL_DATA          @"TutorialData"

#endif
