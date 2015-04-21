//
//  Gaso.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gaso.h"

@implementation Gaso {
    CCAnimationManager* animationManager;
}

- (void) didLoadFromCCB {
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"enemy";
}

- (void) correctPositionOnScreenAtPosition:(CGPoint)loadedLevelPosition withWidth:(CGSize)width{
    if (self.position.x < loadedLevelPosition.x + 50) {
        self.position = ccp(loadedLevelPosition.x + 50, self.position.y);
    }
    if (self.position.x > width.width - 50) {
        self.position = ccp(width.width - 50, self.position.y);
    }
}

- (void) idle {
    if (self.flipX == NO) {
        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 10, self.position.y)];
        [self runAction:moveBy];
    }
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}

- (void) punch {
//    if (self.flipX == NO) {
//        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 40, self.position.y)];
//        [self runAction:moveBy];
//    }
    [animationManager runAnimationsForSequenceNamed:@"Punch"];
}

- (void) run {
    [animationManager runAnimationsForSequenceNamed:@"Walk"];
}

- (void) hit {
//    if (self.flipX == YES) {
//        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 40, self.position.y)];
//        [self runAction:moveBy];
//    }
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
    [self performSelector:@selector(idle) withObject:nil afterDelay:1.8f];
}

@end
