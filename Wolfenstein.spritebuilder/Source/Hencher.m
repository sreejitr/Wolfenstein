//
//  Hencher.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Hencher.h"

@implementation Hencher {
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
        id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(self.position.x - 130, self.position.y)];
        [self runAction:moveBy];
    }
    [animationManager runAnimationsForSequenceNamed:@"Punch"];
}

- (void) run {
    [animationManager runAnimationsForSequenceNamed:@"Run"];
}

- (void) hit {
    [animationManager runAnimationsForSequenceNamed:@"Hit"];
    [self performSelector:@selector(idle) withObject:nil afterDelay:1.8f];
}

- (void) groundhit {
    [animationManager runAnimationsForSequenceNamed:@"Groundhit"];
}

@end
