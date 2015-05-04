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
#import "GameState.h"

@implementation MenuLayer {
    CCSprite *_bunnyface;
    CCSprite *_gasoface;
    CCSprite *_hencherface;
    CCSprite *_festerface;
    CCSprite *_fisterface;
    NSInteger score;
}
- (void)didLoadFromCCB {
    score = [GameState sharedGameState].scoreLevel0;
    if (score) {
        if (score > 0) {
            [_bunnyface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/bunny_3stars.png"]];
        }
    } else {
        [_bunnyface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/bunny_0stars.png"]];
    }
    score = [GameState sharedGameState].scoreLevel1;
    if (score) {
        if (score >= 40000) {
            [_gasoface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/gaso_3stars.png"]];
        } else if (score >= 28000 && score < 40000) {
            [_gasoface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/gaso_2stars.png"]];
        } else if (score < 28000) {
            [_gasoface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/gaso_1star.png"]];
        }
        
    } else {
        [_gasoface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/gaso_0stars.png"]];
    }
    score = [GameState sharedGameState].scoreLevel2;
    if (score) {
        if (score >= 40000) {
            [_hencherface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/hencher_3stars.png"]];
        } else if (score >= 28000 && score < 40000) {
            [_hencherface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/hencher_2stars.png"]];
        } else if (score < 28000) {
            [_hencherface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/hencher_1star.png"]];
        }
        
    } else {
        [_hencherface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/hencher_0stars.png"]];
    }
    score = [GameState sharedGameState].scoreLevel3;
    if (score) {
        if (score >= 40000) {
            [_festerface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fester_3stars.png"]];
        } else if (score >= 28000 && score < 40000) {
            [_festerface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fester_2stars.png"]];
        } else if (score < 28000) {
            [_festerface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fester_1star.png"]];
        }
        
    } else {
        [_festerface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fester_0stars.png"]];
    }
    score = [GameState sharedGameState].scoreLevel4;
    if (score) {
        if (score >= 40000) {
            [_fisterface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fister_3stars.png"]];
        } else if (score >= 28000 && score < 40000) {
            [_fisterface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fister_2stars.png"]];
        } else if (score < 28000) {
            [_fisterface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fister_1star.png"]];
        }
        
    } else {
        [_fisterface setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"Progress/fister_0stars.png"]];
    }
   
}


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


