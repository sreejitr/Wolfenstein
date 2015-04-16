//
//  TutorialGameplay.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialGameplay.h"
#import "Level.h"
#import "Wolfe.h"


static NSString *selectedLevel = @"Level0";
static NSString * const kFirstLevel = @"Level0";

@implementation TutorialGameplay {
    CCNode *_levelNode;
    Level *_loadedLevel;
    Wolfe *_wolfe;
    CCLabelTTF *_instructions;
}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
    _wolfe.position = ccp(205, 130);
    _instructions.string = [NSString stringWithFormat:@"Tap anywhere on the screen to hit Dead Bunny"];
    _instructions.visible = true;
}

- (void)loadNextLevel {
    selectedLevel = _loadedLevel.nextLevelName;
    
    CCScene *nextScene = nil;
    
    if (selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"TutorialGameplay"];
    } else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"MainScene"];
    }
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

@end
