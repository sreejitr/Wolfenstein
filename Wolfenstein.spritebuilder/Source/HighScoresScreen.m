//
//  HighScoresScreen.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 5/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "HighScoresScreen.h"
#import "SceneManager.h"
#import "GameState.h"

@implementation HighScoresScreen{
    CCLabelTTF *level4HighScore;
    CCLabelTTF *level3HighScore;
    CCLabelTTF *level2HighScore;
    CCLabelTTF *level1HighScore;
    CCLabelTTF *level0HighScore;
}

-(void) didLoadFromCCB {
    level4HighScore.string = [NSString stringWithFormat:@"Highest Score: %d", [GameState sharedGameState].highestScoreLevel4];
    level3HighScore.string = [NSString stringWithFormat:@"Highest Score: %d", [GameState sharedGameState].highestScoreLevel3];
    level2HighScore.string = [NSString stringWithFormat:@"Highest Score: %d", [GameState sharedGameState].highestScoreLevel2];
    level1HighScore.string = [NSString stringWithFormat:@"Highest Score: %d", [GameState sharedGameState].highestScoreLevel1];
    level0HighScore.string = [NSString stringWithFormat:@"Highest Score: %d", [GameState sharedGameState].highestScoreLevel0];
}

-(void) loadMainScene {
    [SceneManager presentMainMenu];
}

@end
