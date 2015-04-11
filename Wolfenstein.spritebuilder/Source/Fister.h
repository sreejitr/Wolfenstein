//
//  Fister.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Fister : CCSprite
- (void) hit;
- (void) idle;
- (void) punch;
- (void) groundhit;
- (void) run;
- (void) getup;
@end
