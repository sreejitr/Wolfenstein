//
//  Wolfe.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Wolfe : CCSprite
- (void) idle;
- (void) attack:(CGPoint)position withDistance:(NSInteger) distance;
- (void) attack;
- (void) hit;
- (void) groundhit;
- (void) walk;
- (void) block;
- (void) jumpflip;
- (void) crouchcombo;
- (void) getup;
- (void) correctPositionOnScreenAtPosition:(CGPoint)loadedLevelPosition withWidth:(CGSize)width;
@end
