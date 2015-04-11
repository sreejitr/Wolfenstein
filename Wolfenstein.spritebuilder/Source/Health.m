//
//  Health.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Health.h"

@implementation Health
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"powerUpcol";
}
@end
