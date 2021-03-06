//
//  GameLayer.h
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WeaponSprite.h"
#import "CoreEventListener.h"
#import "ModelInterface.h"
#import "MenuScene.h"

//#import "Viewer.h"
@class Viewer;
#import "TimeProcessBar.h"
#import "ProgressBar.h"
#import "InGameMenuLayer.h"
#import "Weapon.h"

#define MAX_TIME_BAR 120.0;  //300s
#define MAX_BONUS_BAR 20.0;

@interface GameLayer : CCLayer <CoreEventListener,UIAccelerometerDelegate>{
    
}
@property (nonatomic,strong) Viewer* viewer;
@property BOOL multiShoot;
@property BOOL debug;
@property int level;
@property float score;
@property(nonatomic,strong) CCSprite *background;   //background pic of main scene
@property(nonatomic,strong) CCSprite *aimCross;     //aim cross in the middle
@property(nonatomic,strong) CCSpriteBatchNode *SheetExplode;   //spritesheet for gun shot explosion
@property(nonatomic,strong) CCSpriteBatchNode *SheetExplodeBig; //spritesheet for target destroyed explosion
@property(nonatomic,strong) NSMutableArray *targetList;   //array stores the targets**********
@property(nonatomic,strong) CCLabelBMFont *scoreFont;    //count the left targets******* (CCLabelBMFont )
@property(nonatomic,strong) CCSprite *shootMode;
@property(nonatomic,strong) WeaponSprite *weapon; // guns, no gun yet
@property(nonatomic,weak)   CCLayer* inGameMenuLayer;
@property(nonatomic,strong) TimeProcessBar* timeBar;
@property(nonatomic,strong) ProgressBar* progressBar;
@property float percentage;
@property float progressPercentage;
@property CGPoint firstTouchLocation;
//@property NSTimeInterval startTime;
@property BOOL shakeonce;
@property float currentTime;
@property float shakeStartTime;
@property (nonatomic,weak) Weapon* currentWeapon;
@property BOOL specialShoot;
//FB
@property BOOL facebookEnable;
@property (nonatomic,strong) NSMutableArray* FBInfo;
@property  int targetNumber;
@end
