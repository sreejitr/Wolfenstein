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

@end
