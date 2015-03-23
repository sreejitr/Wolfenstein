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
}

//- (void)onEnter {
//    [super onEnter];
//    self.userInteractionEnabled = TRUE;
//}


//- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [self walk];
//}
//- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
//{
//    // we want to know the location of our touch in this scene
//    CGPoint touchLocation = [touch locationInNode:self.parent];
//    CCActionMoveBy *move = [CCActionMoveBy actionWithDuration:0.5 position:ccp(0, 50)];
//    [self runAction:move];
//    [self.physicsBody applyImpulse:ccp(0, -1 * self.physicsBody.velocity.y)];
//    [self walk];
//    self.position = touchLocation;
//}

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

- (void) block {
    [animationManager runAnimationsForSequenceNamed:@"Block"];
}



@end
