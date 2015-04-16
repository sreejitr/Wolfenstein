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
#import "DeadBunny.h"
#import "WinPopUp.h"


static NSString *selectedLevel = @"Level0";
static NSString * const kFirstLevel = @"Level0";

@implementation TutorialGameplay {
    CCNode *_levelNode;
    Level *_loadedLevel;
    Wolfe *_wolfe;
    DeadBunny *_bunny;
    CCLabelTTF *_instructions;
    CCLabelTTF *_score;
    CGPoint touchBeganLocation;
    BOOL wolfeAttackEnable;
    BOOL crouchCombo;
    int points;
    int numOfHits;
    WinPopUp *popup;
}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    _bunny = (DeadBunny*)[CCBReader load:@"DeadBunny"];
    [_physicsNode addChild:_wolfe];
    [_physicsNode addChild:_bunny];
    _wolfe.position = ccp(230, 130);
    _bunny.position = ccp(370, 140);
    if ([_loadedLevel.nextLevelName isEqualToString:@"Level0-1"]) {
        _instructions.string = [NSString stringWithFormat:@"Tap anywhere on the screen to hit Dead Bunny"];
    } else if ([_loadedLevel.nextLevelName isEqualToString:@"None"]) {
        _instructions.string = [NSString stringWithFormat:@"Swipe left or right to move to or away from Dead Bunny"];
    }
    
    _instructions.visible = true;
    [self showScore];
    points = 0;
    _score.visible = true;
    numOfHits = 0;
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

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if ([_loadedLevel.nextLevelName isEqualToString:@"Level0-1"]) {
        [self wolfeAttackBegan];
        _instructions.string = [NSString stringWithFormat:@"Thats awesome!! Now hit Dead Bunny 5 times.."];
        _instructions.visible = true;
        crouchCombo = FALSE;
    } else if ([_loadedLevel.nextLevelName isEqualToString:@"None"]) {
        touchBeganLocation = [touch locationInNode:self];
    }
    
    
}

-(void)update:(CCTime)delta
{
    [self showScore];
    if (numOfHits >= 6) {
        [self winScreen];
    }
}

-(void) wolfeAttackBegan {
    self.userInteractionEnabled = FALSE;
    [_wolfe attack];
    [_bunny hit];
    points += 500;
    numOfHits += 1;
    [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:1.9f];
    
}

-(void) turnoff_wolfe_attack {
    self.userInteractionEnabled = TRUE;
}

- (void)showScore
{
    _score.string = [NSString stringWithFormat:@"Score: %d", points];
    _score.visible = true;
}

- (void)winScreen {
    popup = (WinPopUp *)[CCBReader load:@"WinPopUp3star" owner:self];
    popup._scoreLabel.string = [NSString stringWithFormat:@"Score: %d", points];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [_wolfe stopAllActions];
    [_bunny stopAllActions];
    [self addChild:popup];
}


@end
