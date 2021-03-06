//
//  SceneManager.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SceneManager.h"

@implementation SceneManager

+(void) presentMainMenu
{
    id s = [CCBReader loadAsScene:@"MainScene"];
    id t = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft
                                              duration:0.2];
    [[CCDirector sharedDirector] replaceScene:s withTransition:t];
}

+(void) presentHighScoresScreen
{
    id s = [CCBReader loadAsScene:@"HighScoresScreen"];
    id t = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft
                                              duration:0.2];
    [[CCDirector sharedDirector] replaceScene:s withTransition:t];
}


+(void) presentGameplayScene
{
    id s = [CCBReader loadAsScene:@"Gameplay"];
    id t = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionRight
                                              duration:0.1];
    [[CCDirector sharedDirector] replaceScene:s withTransition:t];
}

+(void) presentGameplaySceneNoTransition
{
    id s = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:s];
}

+(void) presentTrainingScene
{
    id s = [CCBReader loadAsScene:@"TutorialGameplay"];
    id t = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft
                                              duration:0.1];
    [[CCDirector sharedDirector] replaceScene:s withTransition:t];
}

@end
