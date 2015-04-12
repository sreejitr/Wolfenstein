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
    if (self.flipX == NO) {
        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 40, self.position.y)];
        [self runAction:moveBy];
    }
    [animationManager runAnimationsForSequenceNamed:@"Punch"];
}

- (void) jabcombo {
    [animationManager runAnimationsForSequenceNamed:@"Jabcombo"];
}

- (void) uppercut {
    [animationManager runAnimationsForSequenceNamed:@"Uppercut"];
}

- (void) hit {
    if (self.flipX == YES) {
        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 40, self.position.y)];
        [self runAction:moveBy];
    }
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
    [self performSelector:@selector(idle) withObject:nil afterDelay:1.8f];
}

- (void) groundhit {
    [animationManager runAnimationsForSequenceNamed:@"Groundhit"];
}

- (void) getup {
    [animationManager runAnimationsForSequenceNamed:@"GetUp"];
}

- (void) run {
    [animationManager runAnimationsForSequenceNamed:@"Run"];
}


@end
