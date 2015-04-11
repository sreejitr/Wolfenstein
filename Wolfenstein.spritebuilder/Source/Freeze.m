//
//  Freeze.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Freeze.h"

@implementation Freeze
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"powerUpcol";
}
@end
