//
//  Gameplay.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Level.h"
#import "Wolfe.h"
#import "Fister.h"
#import "WinPopUp.h"

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";


@implementation Gameplay{
    Wolfe *_wolfe;
    Fister *_fister;
    CCPhysicsNode *_physicsNode;
    CCNode *_contentNode;
    CCNode *_levelNode;
    Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_winPopUpLabel;
    BOOL _jumped;
    double_t timeelapsed;
    int wolfe_hit;
    int fister_hit;
    BOOL wolfe_attack;
    BOOL fister_attack;
    WinPopUp *popup;
    int points;
    BOOL _gameOver;
}


#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
//    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
    _wolfe.position = ccp(205, 110);
    _fister = (Fister*)[CCBReader load:@"Fister"];
    [_physicsNode addChild:_fister];
    _fister.position = ccp(370, 130);
    wolfe_attack = FALSE;
    fister_attack = FALSE;
    wolfe_hit = 0;
    fister_hit = 0;
    timeelapsed = 0.0f;
    _healthLabel.visible = TRUE;
    points = 100;
    [self showScore];
    _gameOver = FALSE;
}


-(void)update:(CCTime)delta
{
    if (!_gameOver) {
        timeelapsed += delta;
        if (timeelapsed > 1.f) {
        
            if (!wolfe_attack) {
                self.userInteractionEnabled = FALSE;
                fister_attack = TRUE;
                wolfe_hit += 1;
                points -= 5;
                [self showScore];
                [_fister punch];
                if (points == 0) {
                    [_wolfe hit];
                    [_wolfe groundhit];
                }
                else {
                    [_wolfe hit];
                }
                [self performSelector:@selector(turnoff_fister_attack) withObject:nil afterDelay:2.f];
//                [_wolfe performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//                [_fister performSelector:@selector(idle) withObject:nil afterDelay:6.f];
                _wolfe.position = ccp(225, 110);
                _fister.position = ccp(420, 130);
            }
            timeelapsed = 0.0f;
            
        }
        if (fister_hit > 20) {
            
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            [self addChild:popup];
            [_wolfe stopAllActions];
            [_fister stopAllActions];
            _gameOver = TRUE;

        }
        if (points == 0) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup._winPopUpLabel.string = [NSString stringWithFormat:@"You Lose!!"];
            popup.position = ccp(0.5, 0.5);
            [self addChild:popup];
            [_wolfe stopAllActions];
            [_fister stopAllActions];
            _gameOver = TRUE;
        }
    }
}

- (void)showScore
{
    _healthLabel.string = [NSString stringWithFormat:@"Health: %d", points];
    _healthLabel.visible = true;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
//    CGPoint touchLocation = [touch locationInNode:_contentNode];
    NSLog(@"touch received");
//    CCActionMoveBy *move = [CCActionMoveBy actionWithDuration:0.5 position:ccp(0, 50)];
//     _wolfe.physicsBody.velocity = ccp(5.f, _wolfe.physicsBody.velocity.y);
//    _wolfe.position = touchLocation;

    if (!_gameOver) {
        self.userInteractionEnabled = FALSE;
        if (!fister_attack) {
            wolfe_attack = TRUE;
            [_wolfe attack];
            fister_hit += 1;
            if (fister_hit > 20) {
                [_fister hit];
                [_fister groundhit];
            }
            else {
                [_fister hit];
            }
            
            [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:2.f];
//            [_wolfe performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//            [_fister performSelector:@selector(idle) withObject:nil afterDelay:6.f];
            _wolfe.position = ccp(205, 110);
            _fister.position = ccp(370, 130);
        }
        else {
            
        }
    
    }
    
}

-(void) turnoff_wolfe_attack {
    wolfe_attack = FALSE;
    self.userInteractionEnabled = TRUE;
}

-(void) turnoff_fister_attack {
    fister_attack = FALSE;
    self.userInteractionEnabled = TRUE;
}



@end
