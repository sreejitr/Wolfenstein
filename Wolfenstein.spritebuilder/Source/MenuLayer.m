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
#import "MainScene.h"

@implementation MenuLayer
- (void)didLoadFromCCB {
}

//-(void) shouldLoadLevel1
//{
//    [_gamePlay loadLevel:@"Level1"];
//}
//
//-(void) shouldLoadLevel2
//{
//    [_gamePlay loadLevel:@"Level2"];
//}
//
//-(void) shouldLoadLevel3
//{
//    [_gamePlay loadLevel:@"Level3"];
//}
//
//-(void) shouldLoadLevel4
//{
//    [_gamePlay loadLevel:@"Level4"];
//}

-(void) shouldLoadLevel:(CCButton*)sender
{
    [_gamePlay loadLevel:sender.name];
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

-(void) shouldLoadTutorial
{
    [_mainscene removePopover];
    [SceneManager presentTrainingScene];
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


