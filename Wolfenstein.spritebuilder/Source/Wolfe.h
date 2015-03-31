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
- (void) attack;
- (void) hit;
- (void) groundhit;
- (void) walk;
@end
