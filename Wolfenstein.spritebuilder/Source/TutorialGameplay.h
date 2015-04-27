//
//  TutorialGameplay.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface TutorialGameplay : CCNode <CCPhysicsCollisionDelegate>
{
    CCPhysicsNode* _physicsNode;
}
-(void) showPopoverNamed:(NSString*)popoverName;
-(void) removePopover;
-(void) loadLevel: (NSString*) levelName;
@end
