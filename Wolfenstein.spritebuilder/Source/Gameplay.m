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
#import "Gaso.h"
#import "Hencher.h"
#import "WinPopUp.h"
#import "CCActionFollow+CurrentOffset.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "CCDirector.h"
#import "MenuLayer.h"
#import "GameState.h"


static NSString * const kFirstLevel = @"Level4";
static NSString *selectedLevel = @"Level1";
static float level1_interval = 1.4;
static float level2_interval = 1.2;
static float level3_interval = 1.;
static float level4_interval = 0.8;


@implementation Gameplay{
    __weak Wolfe *_wolfe;
    __weak Fister *_fister;
    __weak Gaso *_gaso;
    __weak Hencher *_hencher;
    CCSprite *_powerUp;
    __weak CCNode *_levelNode;
    __weak Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_enemyHealth;
    CCLabelTTF *_winPopUpLabel;
    CCLabelTTF *_gamePoints;
    double_t timeelapsed;
    double_t totaltimeelapsed;
    int wolfe_hit;
    int enemy_hit;
    BOOL wolfe_attack;
    BOOL enemy_attack;
    WinPopUp *popup;
    int healthPointsWolfe;
    int healthPointsEnemy;
    BOOL _gameOver;
    BOOL rightface;
    CCAction *_followWolfe;
    CGPoint touchBeganLocation;
    CGPoint touchMovedLocation;
    BOOL powerupavailable;
    BOOL powerupsactivated;
    BOOL wolfe_jumped;
    BOOL enemy_jumped;
    CCParticleSystem *effect;
    NSArray *powerupArray;
    BOOL playerGroundHit;
    BOOL enemyGroundHit;
    NSInteger healthPointsToDeducthero;
    NSInteger healthPointsToDeductenemy;
    BOOL facingeachother;
    NSString *currentPowerUp;
    int playerScore;
    BOOL wolfeAttackEnable;
    BOOL crouchCombo;
    NSString *playerCollidedwithPowerUp;
    NSString *enemyCollidedwithPowerUp;
    NSDictionary *enemy;
    NSDictionary *fister_v;
    NSDictionary *gaso_v;
    NSDictionary *hencher_v;
    MenuLayer *_menuLayer;
    MenuLayer *newMenuLayer;
    MenuLayer *_popoverMenuLayer;
    GameState* gameState;
    CCSprite *_enemyFace;
    BOOL enemyMovedAway;
    __weak CCNode *_powerUpLabel;
    BOOL collidedOnceAlready;
    float timediff;
}

#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
    gameState = [GameState sharedGameState];
    _menuLayer.gamePlay = self;
    _physicsNode.collisionDelegate = self;
    [self showPopoverNamed:gameState.highestUnlockedLevel];
    wolfe_attack = FALSE;
    enemy_attack = FALSE;
    enemyMovedAway = false;
    wolfe_hit = 0;
    enemy_hit = 0;
    timeelapsed = 0.0f;
    _healthLabel.visible = TRUE;
    _enemyHealth.visible = TRUE;
    _gamePoints.visible = TRUE;
    healthPointsWolfe = 100;
    healthPointsEnemy = 100;
    [self showScore];
    _gameOver = FALSE;
    powerupavailable = false;
    powerupsactivated = false;
    powerupArray = @[@"Health", @"TwoX", @"Star", @"Shield", @"Lightening", @"Freeze"];
    wolfe_jumped = false;
    playerGroundHit = FALSE;
//    _physicsNode.debugDraw = TRUE;
    facingeachother = true;
    healthPointsToDeducthero = 2;
    healthPointsToDeductenemy = 2;
    playerScore = 0;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"FacesForLabel.plist"];
    
}

-(void) loadLevel: (NSString*) levelName
{
    selectedLevel = levelName;
    _loadedLevel = (Level *) [CCBReader load:levelName owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
    CGPoint offsetFromParentCenter = CGPointMake(180, 120);
    _wolfe.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + offsetFromParentCenter.x,
                                  self.contentSize.height * self.anchorPoint.y + offsetFromParentCenter.y);
    rightface = TRUE;
    offsetFromParentCenter = CGPointMake(330, 140);
    fister_v = @{
                 @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
                 @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
                 @"maintainDistanceFromWolfe" : @150,
                 @"moveToAfterPunchAttack" : @120,
                 @"walkRightTo" : @138,
                 @"walkLeftTo" : @150,
                 @"wolfeDistBeforeAttack" : @140
                 };
    offsetFromParentCenter = CGPointMake(290, 120);
    gaso_v = @{
               @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
               @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
               @"maintainDistanceFromWolfe" : @150,
               @"moveToAfterPunchAttack" : @105,
               @"walkRightTo" : @155,
               @"walkLeftTo" : @110,
               @"wolfeDistBeforeAttack" : @120
               };
    hencher_v = @{
                  @"offsetFromParentCenterX": [NSNumber numberWithFloat:offsetFromParentCenter.x],
                  @"offsetFromParentCenterY": [NSNumber numberWithFloat:offsetFromParentCenter.y],
                  @"maintainDistanceFromWolfe" : @160,
                  @"moveToAfterPunchAttack" : @120,
                  @"walkRightTo" : @145,
                  @"walkLeftTo" : @160,
                  @"wolfeDistBeforeAttack" : @150
                  };
    if ([_loadedLevel.nextLevelName isEqualToString:@"Level2"]) {
        enemy = gaso_v;
        _gaso = (Gaso*)[CCBReader load:@"Gaso"];
        [_physicsNode addChild:_gaso];
        _gaso.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + [enemy[@"offsetFromParentCenterX"] floatValue],
                                     self.contentSize.height * self.anchorPoint.y + [enemy[@"offsetFromParentCenterY"] floatValue]);
        [_enemyFace setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"FacesForLabel/gaso_face.png"]];

    }
    else if ([_loadedLevel.nextLevelName isEqualToString:@"Level3"]) {
        enemy = hencher_v;
        _hencher = (Hencher*)[CCBReader load:@"Hencher"];
        _hencher.scale = 0.5f;
        [_physicsNode addChild:_hencher];
        _hencher.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + [enemy[@"offsetFromParentCenterX"] floatValue],
                                        self.contentSize.height * self.anchorPoint.y + [enemy[@"offsetFromParentCenterY"] floatValue]);
        [_enemyFace setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"FacesForLabel/hencher_face.png"]];
        _enemyFace.scaleX = 0.28f;
        _enemyFace.scaleY = 0.28f;
    }
    else {
        _fister = (Fister*)[CCBReader load:@"Fister"];
        enemy = fister_v;
        if ([_loadedLevel.nextLevelName isEqualToString:@"Level4"]) {
            _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
        }
        [_physicsNode addChild:_fister];
        _fister.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + [enemy[@"offsetFromParentCenterX"] floatValue],
                                       self.contentSize.height * self.anchorPoint.y + [enemy[@"offsetFromParentCenterY"] floatValue]);
        if ([selectedLevel isEqualToString:@"Level3"]) {
            [_enemyFace setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"FacesForLabel/Fester.png"]];
            _enemyFace.scaleX = 0.24f;
            _enemyFace.scaleY = 0.24f;
        } else {
            [_enemyFace setSpriteFrame:[CCSpriteFrame frameWithImageNamed: @"FacesForLabel/fister.png"]];
        }
    }

    if (_popoverMenuLayer)
    {
        [_popoverMenuLayer removeFromParent];
        _popoverMenuLayer = nil;
        _menuLayer.visible = YES;
        _levelNode.paused = NO;
        
    }
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_wolfe worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
}

-(void) levelInfoDidChange
{
    NSString *highestUnlockedLevel = [GameState sharedGameState].highestUnlockedLevel;
    NSString *levelnumber = [highestUnlockedLevel substringFromIndex: [highestUnlockedLevel length] - 1];
    int level = levelnumber.intValue;
    int currentLevel = [selectedLevel substringFromIndex: [selectedLevel length] - 1].intValue;
    if (currentLevel == 1) {
        [GameState sharedGameState].scoreLevel1 = playerScore;
    } else if (currentLevel == 2) {
        [GameState sharedGameState].scoreLevel2 = playerScore;
    } else if (currentLevel == 3) {
        [GameState sharedGameState].scoreLevel3 = playerScore;
    } else if (currentLevel == 4) {
        [GameState sharedGameState].scoreLevel4 = playerScore;
    }
    if (level == currentLevel) {
        [GameState sharedGameState].highestUnlockedLevel = newMenuLayer.nextLevelStart;
    }
    
}

-(void) showPopoverNamed:(NSString*)name
{
    if (_popoverMenuLayer == nil)
    {
        newMenuLayer = (MenuLayer*)[CCBReader load:name];
        [self addChild:newMenuLayer];
        _popoverMenuLayer = newMenuLayer;
        _popoverMenuLayer.gamePlay = self;
        _menuLayer.visible = NO;
        _levelNode.paused = YES;
        
    }
}

-(void) removePopover
{
    if (_popoverMenuLayer)
    {
        [_popoverMenuLayer removeFromParent];
        _popoverMenuLayer = nil;
        _menuLayer.visible = YES;
        _levelNode.paused = NO;
    }
}

- (void)loadNextLevel {
    selectedLevel = _loadedLevel.nextLevelName;
    CCScene *nextScene = nil;
    nextScene = [CCBReader loadAsScene:@"Gameplay"];

    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:nextScene withTransition:transition];
}


- (void)onEnter {
    [super onEnter];
    if ([selectedLevel isEqualToString:@"Level1"]) {
        timediff = level1_interval;
    } else if ([selectedLevel isEqualToString:@"Level2"]) {
        timediff = level2_interval;
    } else if ([selectedLevel isEqualToString:@"Level3"]) {
        timediff = level3_interval;
    } else if ([selectedLevel isEqualToString:@"Level4"]) {
        timediff = level4_interval;
    }
}

-(void)update:(CCTime)delta
{
    float xpos;
    [self showScore];
    if (healthPointsEnemy <= 0) {
        [self winScreen];
    }
    if (healthPointsWolfe <= 0) {
        [self loseScreen];
    }
    
//    _fister.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _fister.contentSize} cornerRadius:0];
    if (!_gameOver && !_levelNode.paused) {
        [_wolfe correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        if (_fister) {
            xpos = _fister.position.x;
            [_fister correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        } else if (_gaso) {
            xpos = _gaso.position.x;
            [_gaso correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        } else if (_hencher) {
            xpos = _hencher.position.x;
            [_hencher correctPositionOnScreenAtPosition:_loadedLevel.positionInPoints withWidth:_loadedLevel.contentSizeInPoints];
        }
        NSNumber *maintainDistanceFromWolfe = enemy[@"maintainDistanceFromWolfe"];
        if ((((fabs(_wolfe.position.x - xpos) <= [maintainDistanceFromWolfe intValue]) && (fabsf(_wolfe.position.x - xpos) < [enemy[@"maintainDistanceFromWolfe"] intValue]) && !wolfe_jumped && !playerGroundHit && !enemyGroundHit) || wolfe_attack || enemy_attack) && ![enemyCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Shield"]) {
            _wolfe.color = [CCColor colorWithRed:1. green:0.7 blue:0.7];
        } else if (![enemyCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Shield"]){
            _wolfe.color = [CCColor colorWithRed:1. green:1 blue:1];
        }
        
        timeelapsed += delta;
        totaltimeelapsed += delta;
        if (totaltimeelapsed >= 20.f && !powerupsactivated) {
            [self loadpowerups];
            powerupsactivated = TRUE;
        }
        else if ((totaltimeelapsed > 15.f && powerupsactivated && ![playerCollidedwithPowerUp isEqualToString:@"Shield"] && ![enemyCollidedwithPowerUp isEqualToString:@"Shield"]) || (totaltimeelapsed > 20.f && powerupsactivated && ([playerCollidedwithPowerUp isEqualToString:@"Shield"] || [enemyCollidedwithPowerUp isEqualToString:@"Shield"]))) {
            [self loadpowerups];
            totaltimeelapsed = 0.0f;
        }
        
        if (playerGroundHit) {
            [_wolfe performSelector:@selector(getup) withObject:nil afterDelay:2.f];
            [self performSelector:@selector(resetplayerGroundHit) withObject:nil afterDelay:2.2f];
        }
        
        if (timeelapsed > timediff) {
            if (_fister) {
                id moveBy = [CCActionMoveBy actionWithDuration:0.01 position:ccp(0, 140 - _fister.position.y)];
                [_fister runAction:moveBy];
                if (!wolfe_attack) {
                    if (powerupavailable) {
                        if (_fister.position.x - 70 <= _powerUpPosition.position.x && _fister.position.x + 70 > _powerUpPosition.position.x ) {
                            [self jumpUpEnemy];
                        }
                    }
                    if (enemyMovedAway) {
                        NSNumber *xPos = @(_fister.position.x);
                        [self performSelector:@selector(moveEnemyTowardsWolfe:) withObject:xPos afterDelay:2.2f];
                    } else {
                        [self moveEnemyTowardsWolfe:_fister.position.x];
                    }
                } else {
                    int randthreshold = [self randomIntBetween:3 and:5];
                    if (enemy_hit >= randthreshold) {
                        
                        if(((_fister.position.x > _loadedLevel.positionInPoints.x + 90) || (_fister.position.x < _loadedLevel.contentSizeInPoints.width - 90))&& ![playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
                            enemyMovedAway = true;
                            [_fister stopAllActions];
                            if (rightface) {
                                [self walkRightEnemy:(_fister.position.x + 30)];
                            } else {
                                [self walkLeftEnemy:(_fister.position.x - 90)];
                            }
                            enemy_hit = 0;
                            [self flip_handle];
                        } //else if (_fister.position.x < 90.f && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
//                            [self jumpRightEnemy];
//                            enemy_hit = 0;
//                        } else if ((_fister.position.x > _loadedLevel.contentSizeInPoints.width - 90) && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
//                            [self jumpLeftEnemy];
//                            enemy_hit = 0;
//                        }
                    }
                }
                
            } else if (_gaso) {
                id moveBy = [CCActionMoveBy actionWithDuration:0.01 position:ccp(0, 120 - _gaso.position.y)];
                [_gaso runAction:moveBy];
                if (!wolfe_attack) {
                    if (enemyMovedAway) {
                        NSNumber *xPos = @(_gaso.position.x);
                        [self performSelector:@selector(moveEnemyTowardsWolfe:) withObject:xPos afterDelay:2.2f];
                    } else {
                        [self moveEnemyTowardsWolfe:_gaso.position.x];
                    }
                } else {
                    int randthreshold = [self randomIntBetween:3 and:5];
                    if(enemy_hit >= randthreshold && ((_gaso.position.x > _loadedLevel.positionInPoints.x + 90) || (_gaso.position.x < _loadedLevel.contentSizeInPoints.width - 90))&& ![playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
                        enemyMovedAway = true;
                        [_gaso stopAllActions];
                        if (rightface) {
                            [self walkRightEnemy:(_gaso.position.x + 30)];
                        } else {
                            [self walkLeftEnemy:(_gaso.position.x - 90)];
                        }
                        enemy_hit = 0;
                        [self flip_handle];
                    }
                    
                }
            } else if (_hencher) {
                id moveBy = [CCActionMoveBy actionWithDuration:0.01 position:ccp(0, 120 - _hencher.position.y)];
                [_hencher runAction:moveBy];
                if (!wolfe_attack) {
                    if (powerupavailable) {
                        if (_hencher.position.x - 50 <= _powerUpPosition.position.x && _hencher.position.x + 50 > _powerUpPosition.position.x) {
                            [self jumpUpEnemy];
                        }
                    }
                    if (enemyMovedAway) {
                        NSNumber *xPos = @(_hencher.position.x);
                        [self performSelector:@selector(moveEnemyTowardsWolfe:) withObject:xPos afterDelay:2.2f];
                    } else {
                        [self moveEnemyTowardsWolfe:_hencher.position.x];
                    }
                } else {
                    int randthreshold = [self randomIntBetween:3 and:5];
                    if(enemy_hit >= randthreshold && ((_hencher.position.x > _loadedLevel.positionInPoints.x + 90) || (_hencher.position.x < _loadedLevel.contentSizeInPoints.width - 90))&& ![playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
                        enemyMovedAway = true;
                        [_hencher stopAllActions];
                        if (rightface) {
                            [self walkRightEnemy:(_hencher.position.x + 30)];
                        } else {
                            [self walkLeftEnemy:(_hencher.position.x - 90)];
                        }
                        enemy_hit = 0;
                        [self flip_handle];
                    }
                }
            }
            timeelapsed = 0.0f;
        }
    }
}

- (void) moveEnemyTowardsWolfe: (CGFloat)xPos {
    NSNumber *maintainDistanceFromWolfe = enemy[@"maintainDistanceFromWolfe"];
    NSNumber *moveToAfterAttack = enemy[@"moveToAfterPunchAttack"];
    if (fabs(_wolfe.position.x - xPos) <= [maintainDistanceFromWolfe intValue] && !wolfe_jumped && !enemy_jumped && !playerGroundHit && !enemyGroundHit && (![playerCollidedwithPowerUp isEqualToString:@"Freeze"])) {
        [self enemyAttackBegan:[moveToAfterAttack intValue] withDistanceFromWolfe:[maintainDistanceFromWolfe intValue]];
    } else if (!wolfe_attack && ![playerCollidedwithPowerUp isEqualToString:@"Freeze"] && ![playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
        [self flip_handle];
        if (xPos - _wolfe.position.x > [maintainDistanceFromWolfe intValue]){
            [self walkLeftEnemy:(_wolfe.position.x + [enemy[@"walkLeftTo"] intValue])];
        }
        if (_wolfe.position.x - xPos > [maintainDistanceFromWolfe intValue]){
            [self walkRightEnemy:(_wolfe.position.x - [enemy[@"walkRightTo"] intValue])];
        }
    }
    
    enemyMovedAway = false;
}

- (int)randomIntBetween:(int)lowerBound and:(int)upperBound {
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void) enemyAttackBegan:(NSInteger) moveToVal withDistanceFromWolfe:(NSInteger) distanceFromWolfe{
    self.userInteractionEnabled = FALSE;
    enemy_attack = TRUE;
    if (_wolfe.position.y <= 135) {
        wolfe_hit += 1;
        playerScore -= 950;
        healthPointsWolfe -= healthPointsToDeductenemy;
        [self showScore];
    }
    
    if (_fister) {
        if (_fister.flipX == NO) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_fister.position.x + moveToVal, _fister.position.y)];
            [_fister runAction:moveBy];
        } else if (_fister.flipX == YES) {
            if (![enemyCollidedwithPowerUp isEqualToString:@"TwoX"]) {
                id moveBy = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - 120, _fister.position.y)];
                [_fister runAction:moveBy];
            } else {
                id moveBy = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x - 140, _fister.position.y)];
                [_fister runAction:moveBy];
            }
        }
        [_fister punch];
    } else if (_gaso) {
        if (_gaso.flipX == NO) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_wolfe.position.x + moveToVal, _gaso.position.y)];
            [_gaso runAction:moveBy];
        }
        [_gaso punch:_wolfe.position];
    } else if (_hencher) {
        if (_hencher.flipX == NO) {
            id moveBy = [CCActionMoveTo actionWithDuration:0.10 position:ccp(_hencher.position.x + moveToVal, _hencher.position.y)];
            [_hencher runAction:moveBy];
        }
        [_hencher punch];
    }
    if (![playerCollidedwithPowerUp isEqualToString:@"Shield"]) {
        [_wolfe performSelector:@selector(hit) withObject:nil afterDelay:0.2f];
    } else {
        [_wolfe block];
    }
    
    if (healthPointsWolfe == 0) {
        [_wolfe groundhit];
        playerGroundHit = TRUE;
    }
    
    [self performSelector:@selector(turnoff_enemy_attack) withObject:nil afterDelay:2.f];
    if (_fister) {
        if (_wolfe.position.x < _fister.position.x) {
            _fister.position = ccp(_wolfe.position.x + distanceFromWolfe, _fister.position.y);
        }
    } else if (_gaso) {
    } else if (_hencher) {
        if (_wolfe.position.x < _hencher.position.x) {
            _hencher.position = ccp(_wolfe.position.x + distanceFromWolfe, _hencher.position.y);
        }
    }
    

}

- (void)showScore
{
    if (healthPointsWolfe < 0) {
        healthPointsWolfe = 0;
    }
    if (healthPointsEnemy < 0) {
        healthPointsEnemy = 0;
    }
    if (healthPointsWolfe >= 60) {
        _healthLabel.color = [CCColor colorWithRed:0.2 green:0.7 blue:0.1];
    } else if (healthPointsWolfe < 60 && healthPointsWolfe >= 25) {
        _healthLabel.color = [CCColor colorWithRed:0.7 green:0.28 blue:0.0];
    } else if (healthPointsWolfe < 25 && healthPointsWolfe >= 0) {
        _healthLabel.color = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
    }
    
    _healthLabel.string = [NSString stringWithFormat:@"Wolfe: %d", healthPointsWolfe];
    _healthLabel.visible = true;
    
    
    if (healthPointsEnemy >= 60) {
        _enemyHealth.fontColor = [CCColor colorWithRed:0.2 green:0.7 blue:0.1];
    } else if (healthPointsEnemy < 60 && healthPointsEnemy >= 25) {
        _enemyHealth.fontColor = [CCColor colorWithRed:0.7 green:0.28 blue:0.0];
    } else if (healthPointsEnemy < 25 && healthPointsEnemy >= 0) {
        _enemyHealth.fontColor = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
    }
    if (_fister) {
        _enemyHealth.fontSize = 18;
        if ([selectedLevel isEqualToString:@"Level3"]) {
            _enemyHealth.string = [NSString stringWithFormat:@"Fester: %d", healthPointsEnemy];
        } else {
        _enemyHealth.string = [NSString stringWithFormat:@"Fister: %d", healthPointsEnemy];
        }
    } else if (_gaso) {
        _enemyHealth.string = [NSString stringWithFormat:@"Gaso: %d", healthPointsEnemy];
        _enemyHealth.fontSize = 18;
    } else {
        _enemyHealth.string = [NSString stringWithFormat:@"Hencher: %d", healthPointsEnemy];
        _enemyHealth.fontSize = 15;
    }
    
    _enemyHealth.visible = true;
    
    _gamePoints.string = [NSString stringWithFormat:@"Score: %d", playerScore];
    _gamePoints.visible = true;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (![enemyCollidedwithPowerUp isEqualToString:@"Freeze"]) {
        touchBeganLocation = [touch locationInNode:self.parent];
        wolfeAttackEnable = TRUE;
        crouchCombo = FALSE;
    }
    
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    self.userInteractionEnabled = TRUE;
    [self turnoff_enemy_attack];
    
    touchMovedLocation = [touch locationInNode:self.parent];
    if (!_gameOver && ![enemyCollidedwithPowerUp isEqualToString:@"Freeze"]) {
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (touchBeganLocation.x - touchMovedLocation.x > 50) && !wolfe_jumped) {
            [self jumpLeft];
        } else if ((touchBeganLocation.x - touchMovedLocation.x > 50) && (_wolfe.position.x - 20 > _loadedLevel.boundingBox.origin.x + 90) && !wolfe_jumped) {
            [self walkLeft];
        }
        
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (touchMovedLocation.x - touchBeganLocation.x > 50) && ((_wolfe.position.x + 200) < (_loadedLevel.boundingBox.size.width - _wolfe.boundingBox.size.width)) && !wolfe_jumped) {
            [self jumpRight];
        } else if ((touchMovedLocation.x - touchBeganLocation.x > 50) && (_wolfe.position.x + 20 < (_loadedLevel.boundingBox.size.width - 90)) && !wolfe_jumped) {
            [self walkRight];
        }
        
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && !wolfe_jumped) {
            [self jumpUp];
        }
        
    
        if (touchBeganLocation.y - touchMovedLocation.y > 50) {
            if (![selectedLevel isEqualToString:@"Level1"]) {
                wolfeAttackEnable = TRUE;
                crouchCombo = TRUE;
            } else {
                wolfeAttackEnable = TRUE;
            }
        } else {
            wolfeAttackEnable = false;
        }
        _followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:self.boundingBox];
        [_levelNode runAction:_followWolfe];
    }
}

-(void) touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent *)event{
    if (wolfeAttackEnable && !enemy_jumped) {
        
    if (!_gameOver) {
        float xpos;
        if (_fister) {
            xpos = _fister.position.x;
        } else if (_gaso) {
            xpos = _gaso.position.x;
        } else if (_hencher) {
            xpos = _hencher.position.x;
        }
        if (!enemy_attack && ![enemyCollidedwithPowerUp isEqualToString:@"Freeze"] && fabsf(_wolfe.position.x - xpos) < [enemy[@"maintainDistanceFromWolfe"] intValue] && !wolfe_jumped && !playerGroundHit && !enemyGroundHit) {
            [self wolfeAttackBegan];
        }
        
    }
    }
}

-(void) wolfeAttackBegan {
    self.userInteractionEnabled = FALSE;
    wolfe_attack = TRUE;
    if (crouchCombo) {
        [self crouchComboAttack];
        if (enemyGroundHit && !_gameOver) {
            if (_fister) {
                [_fister performSelector:@selector(getup) withObject:nil afterDelay:2.f];
                [self performSelector:@selector(resetenemyGroundHit) withObject:nil afterDelay:1.f];
            } else if (_hencher) {
                [self performSelector:@selector(resetenemyGroundHit) withObject:nil afterDelay:1.f];
            }
        }
        [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:3.5f];
    } else {
        if (_fister) {
            [_wolfe attack:_fister.position withDistance:[enemy[@"wolfeDistBeforeAttack"] intValue]];
            if (![enemyCollidedwithPowerUp isEqualToString:@"Shield"]) {
                [_fister hit:_wolfe.position];
            }
        } else if (_gaso) {
            [_wolfe attack:_gaso.position withDistance:[enemy[@"wolfeDistBeforeAttack"] intValue]];
            if (![enemyCollidedwithPowerUp isEqualToString:@"Shield"]) {
                [_gaso hit:_wolfe.position];
            }
        } else if (_hencher) {
            [_wolfe attack:_hencher.position withDistance:[enemy[@"wolfeDistBeforeAttack"] intValue]];
            if (![enemyCollidedwithPowerUp isEqualToString:@"Shield"]) {
                [_hencher hit];
            }
        }
        
        [self performSelector:@selector(updateEnemyHealth) withObject:nil afterDelay:1.2f];
        [self showScore];

        [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:1.9f];
    }
    
}

- (void) updateEnemyHealth {
    float xPos;
    if (_fister) {
        xPos = _fister.position.x;
    } else if (_gaso) {
        xPos = _gaso.position.x;
    } else if (_hencher) {
        xPos = _hencher.position.x;
    }
    if ( (_wolfe.flipX == NO) || (fabsf(xPos - _wolfe.position.x) < [enemy[@"maintainDistanceFromWolfe"] intValue])) {
        enemy_hit += 1;
        playerScore += 1000;
        healthPointsEnemy -= healthPointsToDeducthero;
    }

}

-(void) turnoff_wolfe_attack {
    wolfe_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
    wolfeAttackEnable = false;
    
}

-(void) turnoff_enemy_attack {
    enemy_attack = FALSE;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
}


- (void)walkRightEnemy:(CGFloat) xPos {
    if (_fister) {
        _fister.flipX=YES;
        NSLog(@"Right");
        [_fister run];
        id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(xPos, _fister.position.y)];
        [_fister runAction:moveRight];
        [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];

    } else if (_gaso) {
        _gaso.flipX=YES;
        NSLog(@"Right");
        [_gaso run];
        id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(xPos, _gaso.position.y)];
        [_gaso runAction:moveRight];
        [self performSelector:@selector(gaso_idle) withObject:nil afterDelay:0.5f];
    } else if (_hencher) {
        _hencher.flipX=YES;
        NSLog(@"Right");
        [_hencher run];
        id moveRight = [CCActionMoveTo actionWithDuration:0.10 position:ccp(xPos, _hencher.position.y)];
        [_hencher runAction:moveRight];
        [self performSelector:@selector(hencher_idle) withObject:nil afterDelay:0.5f];
    }
    facingeachother = false;
    [self flip_handle];
    
}

- (void)walkRight {
    float xPos;
    float size;
    if (_fister) {
        xPos = _fister.position.x;
        size = 80;
    } else if (_gaso) {
        xPos = _gaso.position.x;
        size = 25;
    } else {
        xPos = _hencher.position.x;
        size = 50;
    }
    if ((_wolfe.position.x + 60) < (xPos - size) || (_wolfe.position.x > xPos)) {
        _wolfe.flipX=NO;
        [_wolfe walk];
        id moveRight = [CCActionMoveBy actionWithDuration:0.10 position:ccp(10, 0)];
        [_wolfe runAction:moveRight];
        facingeachother = FALSE;
        [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
}

- (void)walkLeftEnemy:(CGFloat) xPos {
    if (_fister) {
        [_fister run];
        id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(xPos, _fister.position.y)];
        [_fister runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(fister_idle) withObject:nil afterDelay:0.5f];
    } else if (_gaso) {
        [_gaso run];
        id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(xPos, _gaso.position.y)];
        [_gaso runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(gaso_idle) withObject:nil afterDelay:0.5f];
    } else if (_hencher) {
        [_hencher run];
        id moveLeft = [CCActionMoveTo actionWithDuration:0.10 position:ccp(xPos, _hencher.position.y)];
        [_hencher runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(hencher_idle) withObject:nil afterDelay:0.5f];
    }
    
    
}

- (void)walkLeft {
    float xPos;
    float size;
    if (_fister) {
        xPos = _fister.position.x;
        size = 80;
    } else if (_gaso) {
        xPos = _gaso.position.x;
        size = 25;
    } else {
        xPos = _hencher.position.x;
        size = 50;
    }
    if (((_wolfe.position.x - 70) > (xPos + size)) || (_wolfe.position.x < xPos)) {
    _wolfe.flipX=YES;
    [_wolfe walk];
    id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(-10, 0)];
    [_wolfe runAction:moveLeft];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
}

-(void)jumpUp {
    self.userInteractionEnabled = FALSE;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(0, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(0,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpUpEnemy {
    self.userInteractionEnabled = FALSE;
    float dist;
    if (_fister) {
        if (_fister.flipX == NO) {
            dist = 30.f;
        } else {
            if (_fister.scale == 1.3) {
                dist = -50.f;
            } else {
                dist = -30.f;
            }
        }
    } else {
        dist = 0.f;
    }
    id jumpUp = [CCActionJumpBy actionWithDuration:0.2f position:ccp(30, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.2f position:ccp(dist,-150)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    if (_fister) {
        [self turnoff_enemy_attack];
        [_fister jump];
        [_fister runAction:seq];
        [_fister performSelector:@selector(idle) withObject:nil afterDelay:0.5f];
        [self performSelector:@selector(resetJumpEnemy) withObject:nil afterDelay:2.f];
        _fister.physicsBody.velocity = CGPointMake(0, 0);
    } else if (_gaso) {
        [_gaso runAction:seq];
        [_gaso performSelector:@selector(idle) withObject:nil afterDelay:0.5f];
        [self performSelector:@selector(resetJumpEnemy) withObject:nil afterDelay:2.f];
        _gaso.physicsBody.velocity = CGPointMake(0, 0);
    } else {
        [_hencher runAction:seq];
        [_hencher performSelector:@selector(idle) withObject:nil afterDelay:0.5f];
        [self performSelector:@selector(resetJumpEnemy) withObject:nil afterDelay:2.f];
        _hencher.physicsBody.velocity = CGPointMake(0, 0);
    }
    enemy_jumped = TRUE;
}

-(void)jumpLeft {
    self.userInteractionEnabled = FALSE;
    _wolfe.flipX=YES;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:2.f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.5f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpLeftEnemy {
    self.userInteractionEnabled = FALSE;
    _fister.flipX=YES;
    [_fister jump];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_fister.position.x, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_fister.position.x,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_fister runAction:seq];
    facingeachother = FALSE;
    [_fister performSelector:@selector(idle) withObject:nil afterDelay:2.f];
    enemy_jumped = TRUE;
    [self performSelector:@selector(resetJumpEnemy) withObject:nil afterDelay:2.5f];
    _fister.physicsBody.velocity = CGPointMake(0, 0);
}


-(void)jumpRight {
    self.userInteractionEnabled = FALSE;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(400, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.3f position:ccp(300,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:1.5f];
    wolfe_jumped = TRUE;
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.5f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
    
}

-(void)jumpRightEnemy {
    self.userInteractionEnabled = FALSE;
    [_fister jump];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(400, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.3f position:ccp(300,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_fister runAction:seq];
    facingeachother = FALSE;
    [_fister performSelector:@selector(idle) withObject:nil afterDelay:1.5f];
    enemy_jumped = TRUE;
    [self performSelector:@selector(resetJumpEnemy) withObject:nil afterDelay:2.5f];
    _fister.physicsBody.velocity = CGPointMake(0, 0);
    
}

- (void) crouchComboAttack {
    if (wolfe_attack) {
        [_wolfe crouchcombo];
        if (_fister) {
            [_fister hit:_wolfe.position];
            [_fister performSelector:@selector(groundhit) withObject:nil afterDelay:0.7f];
            enemyGroundHit = TRUE;
        } else if (_gaso) {
            [_gaso hit:_wolfe.position];
        } else if (_hencher) {
            [_hencher hit];
            [_hencher performSelector:@selector(groundhit) withObject:nil afterDelay:0.7f];
        }
        enemy_hit += 1;
        playerScore += 2000;
        healthPointsEnemy -= healthPointsToDeducthero;
        [self showScore];
    }
    
}

- (void) resetplayerGroundHit {
    playerGroundHit = FALSE;
}

- (void) resetenemyGroundHit {
    enemyGroundHit = FALSE;
}

- (void)resetJump {
    wolfe_jumped = FALSE;
    self.userInteractionEnabled = TRUE;
    [self flip_handle];
}

- (void)resetJumpEnemy {
    enemy_jumped = FALSE;
    self.userInteractionEnabled = TRUE;
    [self flip_handle];
}

- (void)flip_handle {
    float enemyXcoordRight;
    float enemyXcoordLeft;
    float wolfeXcoordRight = _wolfe.boundingBox.origin.x + _wolfe.boundingBox.size.width;
    float wolfeXcoordLeft = _wolfe.boundingBox.origin.x;
    if (_fister) {
        enemyXcoordRight = _fister.boundingBox.origin.x + _fister.boundingBox.size.width;
        enemyXcoordLeft = _fister.boundingBox.origin.x;
    } else if (_gaso) {
        enemyXcoordRight = _gaso.boundingBox.origin.x + _gaso.boundingBox.size.width;
        enemyXcoordLeft = _gaso.boundingBox.origin.x;
    } else {
        enemyXcoordRight = _hencher.boundingBox.origin.x + _hencher.boundingBox.size.width;
        enemyXcoordLeft = _hencher.boundingBox.origin.x;
    }
    
    if (wolfeXcoordRight < enemyXcoordRight) {
        rightface = TRUE;
        _wolfe.flipX=NO;
        if (_fister) {
            _fister.flipX=NO;
        } else if (_gaso) {
            _gaso.flipX=NO;
        } else if (_hencher) {
            _hencher.flipX=NO;
        }
    }
    else if (wolfeXcoordLeft > enemyXcoordLeft) {
        rightface = FALSE;
        _wolfe.flipX=YES;
        if (_fister) {
            _fister.flipX=YES;
        } else if (_gaso) {
            _gaso.flipX=YES;
        } else if (_hencher) {
            _hencher.flipX=YES;
        }

    }
}

- (void)wolfe_idle {
    [_wolfe idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)fister_idle {
    [_fister idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)gaso_idle {
    [_gaso idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)hencher_idle {
    [_hencher idle];
    [self flip_handle];
    facingeachother = TRUE;
}

- (void)loadpowerups {
    NSUInteger size = [powerupArray count];
    NSInteger index = arc4random_uniform((u_int32_t )size);
    currentPowerUp = [powerupArray objectAtIndex:index];
    _powerUp = (CCSprite*)[CCBReader load:currentPowerUp];
    _powerUp.name = @"PowerUp";
    [_powerUpPosition setPosition:[_physicsNode convertToNodeSpace:[self convertToWorldSpace:ccp(self.contentSizeInPoints.width/2, self.contentSizeInPoints.height* 0.9f)]]];
    [_powerUpPosition addChild:_powerUp];
    effect = (CCParticleSystem *)[CCBReader load:@"PowerupEffect"];
    effect.autoRemoveOnFinish = TRUE;
    effect.position = _powerUp.position;
    [_powerUp.parent addChild:effect];
    powerupavailable = TRUE;
    collidedOnceAlready = NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero powerUpcol:(CCNode *)powerUpcol {
    CCSprite *powerup = [_powerUpPosition getChildByName:@"PowerUp" recursively:NO];
    if (!collidedOnceAlready) {
        collidedOnceAlready = YES;
        playerCollidedwithPowerUp = currentPowerUp;
        [effect removeFromParent];
        [_powerUpPosition removeChild:powerup];
        [self handlePowerUp];
        powerupavailable = false;
    } else {
        [_powerUpPosition removeChild:powerup];
    }
    return TRUE;
}

// @"Health", @"TwoX", @"Star", @"Fire", @"Shield", @"Lightening", @"Freeze"
- (void) handlePowerUp {
    if ([playerCollidedwithPowerUp isEqualToString:@"Health"]) {
        healthPointsWolfe += 5;
        playerScore += 1000;
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Health +5\nScore +1000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:1.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:2.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"TwoX"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"TwoXEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        healthPointsToDeducthero = 4;
        playerScore += 2000;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Damage to Enemy's health: 2x2\nScore +2000"] fontName:@"Helvetica" fontSize:10.f];
        label.fontColor = [CCColor colorWithRed:1. green:0. blue:0.];
        [_powerUpLabel addChild:label];
        _wolfe.scale = 1.5;
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:10.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            [label removeFromParent];
            _wolfe.scale = 1;
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Star"]) {
        playerScore += 5000;
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score +5000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:2.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Shield"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"ShieldEffect"];
        effect.autoRemoveOnFinish = TRUE;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        _wolfe.color = [CCColor colorWithRed:0. green:1.0 blue:1.0];
        healthPointsToDeductenemy = 0;
        playerScore += 3000;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:20.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Shield Activated\nScore +3000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:20.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
            _wolfe.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Lightening"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"LighteningEffect"];
        effect.autoRemoveOnFinish = TRUE;
        playerScore += 3000;
        if (_fister) {
            effect.position = _fister.position;
            [_fister.parent addChild:effect];
        } else if (_gaso) {
            effect.position = _gaso.position;
            [_gaso.parent addChild:effect];
        } else if (_hencher) {
            effect.position = _hencher.position;
            [_hencher.parent addChild:effect];
        }
        
        healthPointsEnemy -= 10;
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Enemy health -10\nScore +3000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:2.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([playerCollidedwithPowerUp isEqualToString:@"Freeze"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"FreezeEffect"];
        effect.autoRemoveOnFinish = TRUE;
        playerScore += 3000;
        if (_fister) {
            effect.position = _fister.position;
            [_fister.parent addChild:effect];
            _fister.color = [CCColor colorWithRed:0.2 green:0.5 blue:0.9];

        } else if (_gaso) {
            effect.position = _gaso.position;
            [_gaso.parent addChild:effect];
            _gaso.color = [CCColor colorWithRed:0.2 green:0.5 blue:0.9];
        } else if (_hencher) {
            effect.position = _hencher.position;
            [_hencher.parent addChild:effect];
            _hencher.color = [CCColor colorWithRed:0.2 green:0.5 blue:0.9];
        }
        [self performSelector:@selector(resetplayerCollidedwithPowerUp) withObject:nil afterDelay:10.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Enemy Frozen\nScore +3000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:1. green:0. blue:1.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:10.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
            if (_fister) {
                if ([_loadedLevel.nextLevelName isEqualToString:@"Level4"]) {
                    _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
                } else {
                    _fister.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
                }
            } else if (_gaso) {
                _gaso.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
            } else {
                _hencher.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
            }
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    }
}

- (void) resetplayerCollidedwithPowerUp {
    healthPointsToDeducthero = 2;
    healthPointsToDeductenemy = 2;
    playerCollidedwithPowerUp = @"";
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemy:(CCNode *)enemy powerUpcol:(CCNode *)powerUpcol {
    CCSprite *powerup = [_powerUpPosition getChildByName:@"PowerUp" recursively:NO];
    if (!collidedOnceAlready) {
        collidedOnceAlready = YES;
        enemyCollidedwithPowerUp = currentPowerUp;
        [effect removeFromParent];
        [_powerUpPosition removeChild:powerup];
        [self handlePowerUpEnemy];
        powerupavailable = false;
    } else {
        [_powerUpPosition removeChild:powerup];
    }
    return TRUE;
}

// @"Health", @"TwoX", @"Star", @"Fire", @"Shield", @"Lightening", @"Freeze"
- (void) handlePowerUpEnemy {
    if ([enemyCollidedwithPowerUp isEqualToString:@"Health"]) {
        healthPointsEnemy += 5;
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Enemy Health +5"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:2.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            [label removeFromParent];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([enemyCollidedwithPowerUp isEqualToString:@"TwoX"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"TwoXEffect"];
        effect.autoRemoveOnFinish = TRUE;
        
        if (_fister) {
            effect.position = _fister.position;
            [_fister.parent addChild:effect];
        } else if (_hencher){
            effect.position = _hencher.position;
            [_hencher.parent addChild:effect];
        }
        
        healthPointsToDeductenemy = 4;
        [self performSelector:@selector(resetenemyCollidedwithPowerUp) withObject:nil afterDelay:10.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Damage to Wolfe's health: 2x2"] fontName:@"Helvetica" fontSize:10.f];
        label.fontColor = [CCColor colorWithRed:1. green:0. blue:0.];
        [_powerUpLabel addChild:label];
        if (_fister) {
            _fister.scale = 1.3;
        } else if (_hencher) {
            _hencher.scale = .6;
        }
        
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:10.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            [label removeFromParent];
            if (_fister) {
                _fister.scale = 1;
            } else if (_hencher) {
                _hencher.scale = 0.5;
            }
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([enemyCollidedwithPowerUp isEqualToString:@"Star"]) {
        playerScore -= 5000;
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score -5000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:1. green:0. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:2.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([enemyCollidedwithPowerUp isEqualToString:@"Shield"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"ShieldEffect"];
        effect.autoRemoveOnFinish = TRUE;
        if (_fister) {
            effect.position = _fister.position;
            [_fister.parent addChild:effect];
            _fister.color = [CCColor colorWithRed:0. green:1.0 blue:1.0];
        } else if (_hencher) {
            effect.position = _hencher.position;
            [_hencher.parent addChild:effect];
            _hencher.color = [CCColor colorWithRed:0. green:1.0 blue:1.0];
        }
        
        healthPointsToDeducthero = 0;
        playerScore -= 2000;
        [self performSelector:@selector(resetenemyCollidedwithPowerUp) withObject:nil afterDelay:20.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Shield Activated\nScore -2000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:20.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
            if (_fister) {
                if ([_loadedLevel.nextLevelName isEqualToString:@"Level4"]) {
                    _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
                } else {
                    _fister.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
                }
            } else if (_hencher){
                _hencher.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
            }
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([enemyCollidedwithPowerUp isEqualToString:@"Lightening"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"LighteningEffect"];
        effect.autoRemoveOnFinish = TRUE;
        playerScore -= 2000;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        
        healthPointsWolfe -= 10;
        [self performSelector:@selector(resetenemyCollidedwithPowerUp) withObject:nil afterDelay:10.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Wolfe's health -10\nScore -2000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:0. green:1. blue:0.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:2.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    } else if ([enemyCollidedwithPowerUp isEqualToString:@"Freeze"]) {
        effect = (CCParticleSystem *)[CCBReader load:@"FreezeEffect"];
        effect.autoRemoveOnFinish = TRUE;
        playerScore -= 2000;
        effect.position = _wolfe.position;
        [_wolfe.parent addChild:effect];
        _wolfe.color = [CCColor colorWithRed:0.2 green:0.5 blue:0.9];
        [self performSelector:@selector(resetenemyCollidedwithPowerUp) withObject:nil afterDelay:10.f];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Wolfe is Frozen\nScore -2000"] fontName:@"Helvetica" fontSize:15.f];
        label.fontColor = [CCColor colorWithRed:1. green:0. blue:1.];
        [_powerUpLabel addChild:label];
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:10.f];
        CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
            label.scaleX = 1.3;
            label.scaleY = 1.3;
            [label removeFromParent];
            _wolfe.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0];
        }];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[fadeOut, remove]];
        [label runAction:seq];
    }
}

- (void) resetenemyCollidedwithPowerUp {
    healthPointsToDeducthero = 2;
    healthPointsToDeductenemy = 2;
    enemyCollidedwithPowerUp = @"";
}

- (void)winScreen {
    if (playerScore < 0) {
        playerScore = 0;
    }
    [self levelInfoDidChange];
    if (popup == nil) {
        if ([selectedLevel isEqualToString:@"Level4"]) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUpLastLevel" owner:self];
        } else if (playerScore >= 40000) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp3star" owner:self];
        } else if (playerScore >= 28000 && playerScore < 40000) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp2star" owner:self];
        } else if (playerScore < 28000 && playerScore > 0) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp1star" owner:self];
        } else if (playerScore == 0) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp0star" owner:self];
        }
        
        popup._scoreLabel.string = [NSString stringWithFormat:@"Score: %d", playerScore];
        popup.positionType = CCPositionTypeNormalized;
        popup.position = ccp(0.5, 0.5);
        [_wolfe stopAllActions];
        [_fister stopAllActions];
        [self addChild:popup];
        _gameOver = TRUE;
        
    }
}

- (void) lastWinScreen {
    if (playerScore < 0) {
        playerScore = 0;
    }
    popup = nil;
    [self removeChild:popup];
    popup = (WinPopUp *)[CCBReader load:@"LastScreen" owner:self];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [self addChild:popup];
}

- (void)loseScreen {
    if (popup == nil) {
        popup = (WinPopUp *)[CCBReader load:@"LosePopUp" owner:self];
        popup.positionType = CCPositionTypeNormalized;
        popup.position = ccp(0.5, 0.5);
        [_wolfe stopAllActions];
        [_fister stopAllActions];
        [self addChild:popup];
        _gameOver = TRUE;
    }
}

@end
