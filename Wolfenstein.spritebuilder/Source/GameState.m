//
//  GameState.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameState.h"

@implementation GameState

static GameState* sharedInstance;
static dispatch_once_t onceToken;

+(GameState*) sharedGameState
{
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameState alloc] init];
    });
    return sharedInstance;
}

static NSString* KeyForLevelDict = @"levelInfo";

-(void) setLevelDictionary:(NSMutableDictionary*)levelInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:levelInfo forKey:KeyForLevelDict];
}

-(NSMutableDictionary*) levelInfo
{
    NSMutableDictionary *levelInfoDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:KeyForLevelDict] mutableCopy];
    return levelInfoDictionary;
}

@end
