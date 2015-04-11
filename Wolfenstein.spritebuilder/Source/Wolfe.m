//
//  Wolfe.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Wolfe.h"

//static const float velocity = 5.f;

@implementation Wolfe {
    CCAnimationManager* animationManager;
}

- (void) didLoadFromCCB {
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"hero";
}

- (void) idle {
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}

- (void) attack {
    [animationManager runAnimationsForSequenceNamed:@"Attack"];
}

- (void) walk {
    [animationManager runAnimationsForSequenceNamed:@"Walk"];
}

- (void) aircombo {
    [animationManager runAnimationsForSequenceNamed:@"Aircombo"];
}

- (void) crouchcombo {
    [animationManager runAnimationsForSequenceNamed:@"Crouchcombo"];
}

- (void) getup {
    [animationManager runAnimationsForSequenceNamed:@"GetUp"];
}

- (void) jumpflip {
    [animationManager runAnimationsForSequenceNamed:@"Jumpflip"];
}

- (void) hit {
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
}

- (void) groundhit {
    [animationManager runAnimationsForSequenceNamed:@"Groundhit"];
}

- (void) block {
    [animationManager runAnimationsForSequenceNamed:@"Block"];
}


@end
