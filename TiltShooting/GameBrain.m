//
//  GameBrain.m
//  TiltShooting
//
//  Created by yirui zhang on 9/18/12.
//
//

#import "GameBrain.h"
#import "Model.h"
#import "Enemy.h"
#import "Aim.h"
#import "TimePlus.h"
#import "TimeMinus.h"
#import "DesertEagle.h"
#import "Map2Box2D.h"
#import "M4A1.h"
#import "Monster.h"
#import "BulletBox.h"
#import "Spider.h"
#import "PeaceKeeper.h"
static int Totalenemy;

@implementation GameBrain

+ (void) setTotalenemy:(int)enemy{
    Totalenemy = enemy;
}

+ (int) totalenemy{
    return Totalenemy;
}

+ (void) initGameSceneWithLevel: (int) level {
    id<ModelFullInterface> m = [Model instance];
    // init weapon list
    NSMutableArray *weapons = [m weaponList];
    [weapons addObject: [[DesertEagle alloc] init]];
    [weapons addObject: [[M4A1 alloc] init]];
    [weapons addObject:[[PeaceKeeper alloc] init]];
    // init current weapon
    [m setCurrentWeapon: [weapons objectAtIndex:0]];
    // init score system
    [m setScore:0.0f];
    [m setBonus:0.0f];
    [m setTime: 60.0f];
    [GameBrain setTotalenemy:sqrtf(level) * 20];
    // test
    //[GameBrain setTotalenemy:level];
    [GameBrain generateWithNumber:Totalenemy level:level];
}


+ (void) refreshGameWithLevel:(int)level{
    //NSLog(@"GOTO referesh");
    
    id<ModelFullInterface> m = [[Model class] instance];
    int totalnumber=[GameBrain totalenemy];
    NSMutableArray * e=[m targetList];
    int differ = totalnumber - [e count];
    if(differ > 0) {
        srand((unsigned int) time(NULL));
        int num = arc4random() % differ;
        int percentage = ((float)differ / (float)totalnumber) * 100;
        percentage = arc4random() % (100 - percentage);
        if (percentage > 50) {
            [GameBrain generateWithNumber:num level:level];
        }
    }
}

+ (void) randomGen: (int) level {
    id<ModelFullInterface> m = [[Model class] instance];
    int percentage=rand() % 100;
    float x = arc4random() % (int)m.canvasW;
    float y = arc4random() % (int)m.canvasH;
    float targetLevel = ((float) (arc4random() % 100)) / 10.f + (float)level;
    targetLevel = targetLevel > 10.f ? 10.f : targetLevel;
    Target* t = nil;
    //t = [[Spider alloc] initWithX:x Y:y level:targetLevel];//test
    if(percentage > 0 && percentage < 50) {
        t = [[Enemy alloc] initWithX:x Y:y level:targetLevel];
    } else if(percentage < 60) {
        t = [[Spider alloc] initWithX:x Y:y level:targetLevel];
    } else if(percentage < 65) {
        t = [[Monster alloc] initWithX:x Y:y level:targetLevel];
    } else if (percentage < 80) {
        t = [[BulletBox alloc] initWithX:x Y:y level:targetLevel];
    } else if(percentage < 90) {
        t = [[TimePlus alloc] initWithX:x Y:y level:targetLevel];
    } else {
        t = [[TimeMinus alloc] initWithX:x Y:y level:targetLevel];
    }
    [m createTarget:t];
}

+ (void) generateWithNumber:(int)number level:(int)level {
    
    for (int i = 0; i < number ; ++i) {
        [self randomGen: level];
    }
}


@end
