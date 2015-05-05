//
//  Fister.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Fister : CCSprite
- (void) hit:(CGPoint) position;
- (void) idle;
- (void) punch;
- (void) groundhit;
- (void) run;
- (void) getup;
- (void) correctPositionOnScreenAtPosition:(CGPoint)loadedLevelPosition withWidth:(CGSize)width;
- (void) jabtaunt;
- (void) jump;
- (void) jabcombo;
@end
