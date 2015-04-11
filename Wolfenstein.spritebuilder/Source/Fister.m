//
//  Fister.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Fister.h"

@implementation Fister {
    CCAnimationManager* animationManager;
}

- (void) didLoadFromCCB {
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"enemy";
}

- (void) idle {
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}

- (void) punch {
    [animationManager runAnimationsForSequenceNamed:@"Punch"];
}

- (void) jabcombo {
    [animationManager runAnimationsForSequenceNamed:@"Jabcombo"];
}

- (void) uppercut {
    [animationManager runAnimationsForSequenceNamed:@"Uppercut"];
}

- (void) hit {
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
}

- (void) groundhit {
    [animationManager runAnimationsForSequenceNamed:@"Groundhit"];
}

- (void) run {
    [animationManager runAnimationsForSequenceNamed:@"Run"];
}


@end
