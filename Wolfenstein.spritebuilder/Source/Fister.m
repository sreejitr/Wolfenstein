//
//  Fister.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Fister.h"
#import "Gameplay.h"


@implementation Fister {
    CCAnimationManager* animationManager;
}

- (void) didLoadFromCCB {
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"enemy";
}

- (void) correctPositionOnScreenAtPosition:(CGPoint)loadedLevelPosition withWidth:(CGSize)width{
    if (self.position.x < loadedLevelPosition.x + 60) {
        self.position = ccp(loadedLevelPosition.x + 60, self.position.y);
    }
    if (self.position.x > width.width - 50) {
        self.position = ccp(width.width - 50, self.position.y);
    }
}

- (void) idle {
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}

- (void) punch {
    if (self.flipX == NO) {
        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 110, self.position.y)];
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

- (void) hit:(CGPoint) position {
    if (self.flipX == YES) {
        if (self.position.x >= position.x - 160) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(position.x - 160, self.position.y)];
            [self runAction:moveBy];
        }
    }
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
//    [self performSelector:@selector(idle) withObject:nil afterDelay:1.8f];
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

- (void) punchcharge {
    [animationManager runAnimationsForSequenceNamed:@"Punchcharge"];
}

@end
