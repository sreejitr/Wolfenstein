//
//  Lightening.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Lightening.h"

@implementation Lightening
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"powerUpcol";
}
@end
