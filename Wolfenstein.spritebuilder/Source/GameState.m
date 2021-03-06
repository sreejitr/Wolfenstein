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
        [sharedInstance setFisterDefaults];
        [sharedInstance setGasoDefaults];
        [sharedInstance setHencherDefaults];
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

static NSString* KeyForHighestScoreLevel0 = @"highestScoreLevel0";
-(void) setHighestScoreLevel0:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForHighestScoreLevel0];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) highestScoreLevel0
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForHighestScoreLevel0];
    return (score > 0 ? score : 0);
}

static NSString* KeyForHighestScoreLevel1 = @"highestScoreLevel1";
-(void) setHighestScoreLevel1:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForHighestScoreLevel1];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) highestScoreLevel1
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForHighestScoreLevel1];
    return (score > 0 ? score : 0);
}

static NSString* KeyForHighestScoreLevel2 = @"highestScoreLevel2";
-(void) setHighestScoreLevel2:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForHighestScoreLevel2];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) highestScoreLevel2
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForHighestScoreLevel2];
    return (score > 0 ? score : 0);
}

static NSString* KeyForHighestScoreLevel3 = @"highestScoreLevel3";
-(void) setHighestScoreLevel3:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForHighestScoreLevel3];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) highestScoreLevel3
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForHighestScoreLevel3];
    return (score > 0 ? score : 0);
}

static NSString* KeyForHighestScoreLevel4 = @"highestScoreLevel4";
-(void) setHighestScoreLevel4:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:KeyForHighestScoreLevel4];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) highestScoreLevel4
{
    NSInteger score = [[NSUserDefaults standardUserDefaults]
                       integerForKey:KeyForHighestScoreLevel4];
    return (score > 0 ? score : 0);
}

static NSString* KeyForFisterDefaults = @"fisterDefaults";
-(void) setFisterDefaults
{
    NSDictionary *fister_v;
   
    CGPoint offsetFromParentCenter = CGPointMake(330, 140);
    fister_v = @{
                 @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
                 @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
                 @"maintainDistanceFromWolfe" : @150,
                 @"moveToAfterPunchAttack" : @120,
                 @"walkRightTo" : @138,
                 @"walkLeftTo" : @150,
                 @"wolfeDistBeforeAttack" : @140
                 };
    [[NSUserDefaults standardUserDefaults] setObject:fister_v forKey:KeyForFisterDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary*) fisterDefaults
{
    NSDictionary *fister_v = [[NSUserDefaults standardUserDefaults]
                       dictionaryForKey:KeyForFisterDefaults];
    return fister_v;
}

static NSString* KeyForGasoDefaults = @"gasoDefaults";
-(void) setGasoDefaults
{
    NSDictionary *gaso_v;
    
    CGPoint offsetFromParentCenter = CGPointMake(290, 120);
    gaso_v = @{
               @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
               @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
               @"maintainDistanceFromWolfe" : @150,
               @"moveToAfterPunchAttack" : @105,
               @"walkRightTo" : @155,
               @"walkLeftTo" : @110,
               @"wolfeDistBeforeAttack" : @120
               };

    [[NSUserDefaults standardUserDefaults] setObject:gaso_v forKey:KeyForGasoDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary*) gasoDefaults
{
    NSDictionary *gaso_v = [[NSUserDefaults standardUserDefaults]
                              dictionaryForKey:KeyForGasoDefaults];
    return gaso_v;
}


static NSString* KeyForHencherDefaults = @"hencherDefaults";
-(void) setHencherDefaults
{
    NSDictionary *hencher_v;
    
    CGPoint offsetFromParentCenter = CGPointMake(290, 120);
    hencher_v = @{
              @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
              @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
              @"maintainDistanceFromWolfe" : @160,
              @"moveToAfterPunchAttack" : @120,
              @"walkRightTo" : @145,
              @"walkLeftTo" : @160,
              @"wolfeDistBeforeAttack" : @150
              };
    [[NSUserDefaults standardUserDefaults] setObject:hencher_v forKey:KeyForHencherDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary*) hencherDefaults
{
    NSDictionary *hencher_v = [[NSUserDefaults standardUserDefaults]
                            dictionaryForKey:KeyForHencherDefaults];
    return hencher_v;
}


@end
