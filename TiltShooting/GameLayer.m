//
//  GameLayer.m
//  TiltShooting
//
//  Created by yan zhuang on 12-9-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "TargetSprite.h"
#import "SimpleAudioEngine.h"
#import "ModelInterface.h"
#import "Model.h"
#import "Aim.h"
#import "Bomb.h"
@implementation GameLayer

@synthesize level;
@synthesize background;
@synthesize aimCross;
@synthesize targetList;
@synthesize SheetExplode;
@synthesize SheetExplodeBig;
@synthesize targetLeft;
@synthesize shootMode;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        [Viewer NSLogDebug:self.debug withMsg:@"init gameLayer"];

        //viewer draw background 
        //[Viewer showMenuBackground:self];
        CGSize size = [[CCDirector sharedDirector] winSize];
		// Load background 1440*960 ??
		background = [CCSprite spriteWithFile:@"nightsky.png"];
		[self addChild:background z:0 tag:9];
        background.position=ccp( size.width /2 , size.height/2 );
        //NSLog(@"init gameLayer bg");
		/*
		// indecator
		CCSprite *spriteInd = [CCSprite spriteWithFile:@"enemy.png" rect:CGRectMake(0,0,40,40)];
		[self addChild:spriteInd z:1 tag:5];
		
		spriteInd.scale = 0.8;
		spriteInd.position = ccp(20, 300);
		*/
        
        //show how many targets left ??
		targetLeft = [CCLabelBMFont labelWithString:@"00" fntFile:@"font09.fnt"];
		targetLeft.anchorPoint = ccp(0.0, 1.0);
		targetLeft.scale = 0.8;
		[self addChild:targetLeft z:1 tag:6];
		targetLeft.position = ccp(440, 305);
		
        //creat the aim cross sprite
        //aimCross=[CCSprite spriteWithFile:@"aimcross.png"];
        //aimCross.position =  ccp( size.width /2 , size.height/2 );
        //[self addChild:aimCross z:1 tag:1];
        //[Viewer NSLogDebug:self.debug withMsg:@"init gameLayer aimcross"];
        //init back to menu button
        [CCMenuItemFont setFontSize:30];
		CCMenuItem *backToMenu = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(onBackToMenu:)];
		CCMenu *mn = [CCMenu menuWithItems:backToMenu, nil];
		[mn alignItemsVertically];
		mn.position = ccp (480 - 50, 30);
        
		[self addChild:mn z:1 tag:2];        // add the label as a child to this Layer
        //add temp gameover scene button
        CCMenuItem *gameOverButton = [CCMenuItemFont itemFromString:@"GameOver" target:self selector:@selector(showGameOverScene:)];
		CCMenu *mn3 = [CCMenu menuWithItems:gameOverButton, nil];
		[mn3 alignItemsVertically];
		mn3.position = ccp (480 - 50, 60);
        
		[self addChild:mn3 z:1 tag:2];
        /*
		// Check Game Stae
		[self schedule:@selector(ShowState) interval: 0.5];
		
		// tank
		tank = [TankSprite TankWithinLayer:self imageFile:@"Tank.PNG"];
		[tank setPosition:ccp(20, 20)];
		tank.bIsEnemy = NO;
		*/
        
		// Stroe targets for collision detection?
        // ****Add new target as child of background***
		targetList = [[NSMutableArray alloc] initWithCapacity:8];
		
		/*int i;
		TargetSprite *target;
		
		for (i = 0; i < 1; i++) {
            //create and add a new target
			target= [TargetSprite TargetWithinLayerBackground:self imageFile:@""]; //??
            [targetList addObject:target];
		}*/
        
		//Explosion effects
		// explode1
		SheetExplode = [CCSpriteBatchNode batchNodeWithFile:@"Explode1.png" capacity:10];
		[background addChild:SheetExplode z:0];
		
		CCSprite *spriteExplode = [CCSprite spriteWithTexture:SheetExplode.texture rect:CGRectMake(0,0,23,23)];
		[SheetExplode addChild:spriteExplode z:1 tag:5];
		spriteExplode.position = ccp(240, 160);
		[spriteExplode setVisible:NO];
        
		// explode2
		SheetExplodeBig = [CCSpriteBatchNode batchNodeWithFile:@"exploBig.png" capacity:15];
		[background addChild:SheetExplodeBig z:0];
		
		CCSprite *spriteExplodeBig = [CCSprite spriteWithTexture:SheetExplodeBig.texture rect:CGRectMake(0,0,40,40)];
		[SheetExplodeBig addChild:spriteExplodeBig z:1 tag:5];
		spriteExplodeBig.position = ccp(240, 160);
		[spriteExplodeBig setVisible:NO];
		
        //select shoot mode button
        CCMenuItem *shootModeButton = [CCMenuItemFont itemFromString:@"     " target:self selector:@selector(changeShootMode:)];
		CCMenu *mn2= [CCMenu menuWithItems:shootModeButton, nil];
        [self addChild:mn2 z:1];
		mn2.position = ccp (150, 30);
        
        shootMode=[CCSprite spriteWithFile:@"bullet_single_multi.png"   rect:CGRectMake(0, 0,50,50)];
        [self addChild:shootMode z:2];
        shootMode.position=ccp(150,30);
        
        //preload sound effetc
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rifle_GunShot.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgmusic1_15s.mp3"];
        //show weapon
        //[Viewer showWeapon:self];
        // register to model event listener
        id<ModelInterface>  model = [[Model class] instance];
        [model addToCoreEventListenerList:self];
       
		//debug
        [self setDebug:YES];
	}
	return self;
}
//On enter
-(void) onEnter
{
	[super onEnter];
    
	[Viewer NSLogDebug:self.debug withMsg:@"Enter GameLayer"];

    //start model
    [Viewer NSLogDebug:self.debug withMsg:@"start model for model test "];
     id<ModelInterface> model = [[Model class] instance];
    [Viewer NSLogDebug:self.debug withMsg:@"start model"];
    [model start];
    //play bg music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgmusic1_15s.mp3"];
    
    //set shoot mode: default single shoot
    [self setMultiShoot:NO];
    // Enable touch
    [self setIsTouchEnabled:YES];
    [Viewer NSLogDebug:self.debug withMsg:@"enable gameLayer touch"];
    
	
}
//on exit
-(void) onExit{
    
    [super onExit];
    //remove from listenlist of model?
    /* not stop here
    //stop model
    id<ModelInterface> model = [[Model class] instance];
    if (model.status == RUNNING || model.status==PAUSING) {
        [Viewer NSLogDebug:self.debug withMsg:@"gameLayer stops model"];
        [model stop];
    }
    */
    [Viewer NSLogDebug:self.debug withMsg:@"Exit gameLayer"];
}

//Back to menu
-(void)onBackToMenu:(id)sender{
    //pause
    id<ModelInterface>  model = [[Model class] instance];
    NSLog(@"onbacktomenu pause the model for ingamememu display");
    [model pause];
    [self setIsTouchEnabled:NO];
    
    [(InGameMenuLayer*)self.inGameMenuLayer initWithGameLayer:self];
    
    //CCScene *sc = [MenuScene node];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:sc withColor:ccWHITE]];
}
//temp show gameover scene
-(void)showGameOverScene:(id)sender{
    //will change this to model listen func
    //check win or lose
    //if win
     [Viewer showBigSign:@"WIN!" inLayer:self withDuration:1.5];
    //if lose
    //[Viewer showBigSign:@"LOSE!" inLayer:self withDuration:1];
    
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    [model stop];
    //replace scene
    CCScene *sc = [GameOverScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];

}

-(void)removeChildFromParent:(CCNode*)child{
    [child removeFromParentAndCleanup:YES];
}
//change shoot mode , show button animation
-(void) changeShootMode:(id)sender{
    CCSpriteBatchNode *shootModeSheet = [CCSpriteBatchNode batchNodeWithFile:@"bullet_single_multi.png" capacity:2];
    [self addChild:shootModeSheet];
    CCAnimation *ans = [CCAnimation animationWithFrames:nil  delay:0.2f];
    if(self.multiShoot){ //change to single
        NSLog(@"change to single shoot mode");
        [self setMultiShoot:NO];
        [Viewer showBigSign:@"Single Shoot" inLayer:self withDuration:1];
        [self.shootMode  setDisplayFrame:[CCSpriteFrame frameWithTextureFilename:@"bullet_single_multi.png" rect:CGRectMake(0, 0, 50, 50)]];
        [self.shootMode runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:1.3],[CCScaleTo actionWithDuration:0.5 scale:1], nil]];
        
        
    }
    else{ //change to multi
        NSLog(@"change to single shoot mode");
        [self setMultiShoot:YES];
        [Viewer showBigSign:@"Multi Shoot" inLayer:self withDuration:1];
        [self.shootMode  setDisplayFrame:[CCSpriteFrame frameWithTextureFilename:@"bullet_single_multi.png" rect:CGRectMake(50, 0, 50, 50)]];
        [self.shootMode runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:1.3],[CCScaleTo actionWithDuration:0.5 scale:1], nil]];
    }
    
    
}
//************ Handle GameLayer Touch *******************//
// register to get touches input
-(void) registerWithTouchDispatcher
{
    //NSLog(@"register gamelayer to touch dispatcher");
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [Viewer NSLogDebug:self.debug withMsg:@"touch began once"];
    /*
     // get location of touch 
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"x=%f y=%f",location.x,location.y);
     */
    if(self.multiShoot){
        [self schedule:@selector(fireWeapon) interval:0.1];
    }
    else{//single shoot mode
        
        [self schedule:@selector(fireWeapon) interval:0.1 repeat:0 delay:0];
    }
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [Viewer NSLogDebug:self.debug withMsg:@"touch ended once"];
    if(self.multiShoot){
        [self fireWeapon];//at least fire once
        [self unschedule:@selector(fireWeapon)];
    }
    //[[SimpleAudioEngine sharedEngine] playEffect:@"gunShotOntarget.mp3"];
    
}
-(void)fireWeapon{
    //call model 
    id<ModelInterface> m = [[Model class] instance];
    [m shoot];

    [Viewer NSLogDebug:self.debug withMsg:@"fire gun once"];
    //shoot effect
    [[SimpleAudioEngine sharedEngine] playEffect:@"Rifle_GunShot.mp3"];  
    //show a bullet hole for test, not using location here
    [Viewer showBulletHole:self atLocation:self.aimCross.position];
    
}


//************Listen to model*******************//
/* target */
- (BUBBLE_RULE) targetAppear: (Target *) target{
    //check type of target
    TARGET_TYPE type=[self checkTargetType:target];
    switch (type) {
        case AIM:
            //model init aimCross position?? now, init in gameLayer above
            [Viewer showAim:target inLayer:self];
            break;
        case ENEMY:
            
            [Viewer showTarget:target inLayer:self];
            break;
        case BOMB:
            
            [Viewer showBomb:target inLayer:self];
            break;

        default:
            break;
    }
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) targetDisAppear: (Target *) target{
    //for test
    if(target.aux!=nil){
        //check type of target
        TARGET_TYPE type=[self checkTargetType:target];
        switch (type) {
            case AIM:
                
                [Viewer removeAim:target inLayer:self];
                break;
            case ENEMY:
                
                [Viewer removeTarget:target inLayer:self];
                break;
            case BOMB:
                
                [Viewer removeBomb:target inLayer:self];
                break;
                
            default:
                break;
        }

        //remove using Viewer now
        
    }
    else{
        NSLog(@"error:try to delete nil target");
    }
    return BUBBLE_CONTINUE;

}
- (BUBBLE_RULE) targetMove: (Target *) target{
    //for test
    if(target.aux!=nil){
        CCNode *tg=(CCNode*)target.aux;
        //[Viewer NSLogDebug:self.debug withMsg:[NSString stringWithFormat:@"move target from (%f,%f) to (%f,%f)",tg.position.x,tg.position.y,target.x,target.y]];
        tg.position=ccp(target.x,target.y);
    }
    else{
        NSLog(@"error:try to move nil target");
    }
    return BUBBLE_CONTINUE;

}


/* other object */
- (BUBBLE_RULE) canvasMovetoX:(float)x Y:(float)y {
    [self.background setPosition:ccp(x, y)];
    return BUBBLE_CONTINUE;
}
- (BUBBLE_RULE) impact: (Target *) t1 by: (Target *) t2{
    return BUBBLE_CONTINUE;

}

/* game control signals */
- (BUBBLE_RULE) gameInitFinished{
    return BUBBLE_CONTINUE;

}

//check target type
-(TARGET_TYPE)checkTargetType:(Target*)target{
    if([target isMemberOfClass:[Aim class]]){
        //[Viewer NSLogDebug:self.debug withMsg:@"got an Aim target"];
        return AIM;
    }
    else if([target isMemberOfClass:[Enemy class]]){
        //NSLog(@"got an enemy target");
        return ENEMY;
    }
    else if([target isMemberOfClass:[Bomb class]]){
        return BOMB;
    }
    return UNKNOWN;
}

- (BUBBLE_RULE) targetHit:(Target *)target {
    if(target.aux!=nil){
        NSLog(@"HITTED");
    }
    return BUBBLE_CONTINUE;
}

/* win, lose && score */
- (BUBBLE_RULE) win {
    NSLog(@"win");
    
    //if win
    [Viewer showBigSign:@"WIN!" inLayer:self withDuration:1.5];
    //if lose
    //[Viewer showBigSign:@"LOSE!" inLayer:self withDuration:1];
    
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    [model stop];
    
    //replace scene
    GameOverScene *sc = [GameOverScene node];
    //pass score to gameoverscene
    [sc setScore:self.score];
    [sc setWin:TRUE];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];

    return BUBBLE_CONTINUE;
}

- (BUBBLE_RULE) lose {
    NSLog(@"Lose");
    //if win
    //[Viewer showBigSign:@"WIN!" inLayer:self withDuration:1.5];
    //if lose
    [Viewer showBigSign:@"LOSE!" inLayer:self withDuration:1];
    
    //stop model here
    id<ModelInterface>  model = [[Model class] instance];
    [model stop];
    
    //replace scene
    GameOverScene *sc = [GameOverScene node];
    //pass score to gameoverscene
    [sc setScore:self.score];
    [sc setWin:FALSE];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:sc withColor:ccWHITE]];

    return BUBBLE_CONTINUE;
}

- (BUBBLE_RULE) score:(float)score {
    NSLog(@"score change to: %f", score);
    return BUBBLE_CONTINUE;
}
@end
