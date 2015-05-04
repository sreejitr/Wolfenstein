//
//  GameState.h
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

+(GameState*) sharedGameState;

@property (nonatomic, assign) NSInteger scoreLevel0;
@property int scoreLevel1;
@property int scoreLevel2;
@property int scoreLevel3;
@property int scoreLevel4;
@property NSString* highestUnlockedLevel;
@end
