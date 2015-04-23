//
//  MenuLayer.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MenuLayer.h"
#import "Gameplay.h"
#import "SceneManager.h"

@implementation MenuLayer
- (void)didLoadFromCCB {
    
}

-(void) resumeGame
{
    CCAnimationManager* am = self.animationManager;
    if ([am.runningSequenceName isEqualToString:@"resume game"] == NO)
    {
        [am runAnimationsForSequenceNamed:@"resume game"];
    }
}
-(void) resumeGameDidEnd
{
    [_gamePlay removePopover];
}

- (void)pauseGame {
//    Gameplay* _gameplay = (Gameplay*)self.scene.children.firstObject;
    [_gamePlay showPopoverNamed:@"PauseMenuLayer"];
}

-(void) restartGame
{
    [SceneManager presentGameplaySceneNoTransition];
}
-(void) exitGame
{
    [SceneManager presentMainMenu];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
    [self pauseGame];
}
@end


