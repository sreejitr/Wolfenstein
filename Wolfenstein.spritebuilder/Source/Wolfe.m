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

- (void) correctPositionOnScreenAtPosition:(CGPoint)loadedLevelPosition withWidth:(CGSize)width{
    if (self.position.x < loadedLevelPosition.x + 70) {
        self.position = ccp(loadedLevelPosition.x + 60, self.position.y);
    }
    if (self.position.x > width.width - 60) {
        self.position = ccp(width.width - 60, self.position.y);
    }
}

- (void) idle {
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}

- (void) attack:(CGPoint)position withDistance:(NSInteger) distance {
    if (self.flipX == NO) {
        if (position.x > self.position.x + distance) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.30 position:ccp(position.x - distance, self.position.y)];
            [self runAction:moveBy];
        }
        
    }
    [animationManager runAnimationsForSequenceNamed:@"Attack"];

    
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
