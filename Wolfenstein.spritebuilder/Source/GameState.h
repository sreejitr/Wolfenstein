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

@property NSMutableDictionary *levelInfo;

@end
