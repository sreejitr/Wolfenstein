//
//  Gameplay.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>
{
    CCPhysicsNode* _physicsNode;
    CCNode* _powerUpPosition;
    
}
-(void) showPopoverNamed:(NSString*)popoverName;
-(void) removePopover;
-(void) loadLevel: (NSString*) levelName;

@end
