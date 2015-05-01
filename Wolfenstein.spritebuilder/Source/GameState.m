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

static NSString* KeyForHighestUnlockedLevel = @"highestUnlockedLevel";
-(void) setHighestUnlockedLevel:(NSString*)level
{
    [[NSUserDefaults standardUserDefaults] setObject:level forKey:KeyForHighestUnlockedLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) highestUnlockedLevel
{
    NSString* level = [[NSUserDefaults standardUserDefaults]
                        stringForKey:KeyForHighestUnlockedLevel];
    return (level ? level : @"LevelStart0");
}

static NSString* KeyForScoreLevel0 = @"scoreLevel0";
-(void) setScoreLevel0:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForScoreLevel0];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) scoreLevel0
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForScoreLevel0];
    return (score > 0 ? score : 0);
}

static NSString* KeyForScoreLevel1 = @"scoreLevel1";
-(void) setScoreLevel1:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForScoreLevel1];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) scoreLevel1
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForScoreLevel1];
    return (score > 0 ? score : 0);
}

static NSString* KeyForScoreLevel2 = @"scoreLevel2";
-(void) setScoreLevel2:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForScoreLevel2];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) scoreLevel2
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForScoreLevel2];
    return (score > 0 ? score : 0);
}

static NSString* KeyForScoreLevel3 = @"scoreLevel3";
-(void) setScoreLevel3:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForScoreLevel3];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) scoreLevel3
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForScoreLevel3];
    return (score > 0 ? score : 0);
}

static NSString* KeyForScoreLevel4 = @"scoreLevel4";
-(void) setScoreLevel4:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForScoreLevel4];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) scoreLevel4
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForScoreLevel4];
    return (score > 0 ? score : 0);
}


@end
