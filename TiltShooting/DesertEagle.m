//
//  DesertEagle.m
//  TiltShooting
//
//  Created by yirui zhang on 10/30/12.
//
//

#import "DesertEagle.h"
#import "Model.h"

@implementation DesertEagle
- (id) init {
    if (self = [super initWithSpeed:1.0f damage:5.0f
                          skillMana:100.0f bulletCapacity:7 depotRemain: 35]) {
        // do nothing
    }
    return self;
}

- (void) doSpecialSkillWithX:(float)x y:(float)y {
    id<ModelFullInterface> m = [[Model class] instance];
    
    // search for the targets
    Map2Box2D *p = [m map2Box2D];
    Target *t = [p locateTargetByX:x y:y];
    self.bulletRemain -= 1;
    
    [t onShootBy:self with:^(WeaponBase* weapon, Target* target){
        target.hp -= weapon.damage * 10;
    }];

}

- (void) doShootWithX:(float)x y:(float)y {
    id<ModelFullInterface> m = [[Model class] instance];
    // search for the targets
    Map2Box2D *p = [m map2Box2D];
    Target *t = [p locateTargetByX:x y:y];
    self.bulletRemain -= 1;
    
    [t onShootBy:self with:^(WeaponBase* weapon, Target* target){
        target.hp -= weapon.damage;
    }];
}

@end
