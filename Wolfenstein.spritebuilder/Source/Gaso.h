//
//  Gaso.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Gaso : CCSprite
- (void) hit:(CGPoint) position;
- (void) idle;
- (void) punch:(CGPoint) position;
- (void) run;
- (void) correctPositionOnScreenAtPosition:(CGPoint)loadedLevelPosition withWidth:(CGSize)width;
@end
