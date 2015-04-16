//
//  DeadBunny.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DeadBunny.h"

@implementation DeadBunny {
    CCAnimationManager* animationManager;
}

- (void) didLoadFromCCB {
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"enemy";
}

- (void) idle {
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}

- (void) hop {
    [animationManager runAnimationsForSequenceNamed:@"Hop"];
}

- (void) hit {
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
}


@end
