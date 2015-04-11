//
//  Fire.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Fire.h"

@implementation Fire
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"powerUpcol";
}
@end
