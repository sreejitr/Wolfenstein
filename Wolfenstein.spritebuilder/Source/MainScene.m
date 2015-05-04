#import "MainScene.h"
#import "SceneManager.h"
#import "Wolfe.h"
#import "Gaso.h"
#import "Hencher.h"
#import "Fister.h"
#import "MenuLayer.h"
#import "GameState.h"


static NSString *currentLevelStart = @"LevelStart0";

@implementation MainScene {
    __weak Wolfe *_wolfe;
    __weak Gaso *_gaso;
    __weak Hencher *_hencher;
    __weak Fister *_fister;
    __weak Fister *_fisterBoss;
    MenuLayer *_popoverMenuLayer;
    MenuLayer* newMenuLayer;
}

- (void)didLoadFromCCB {
    _wolfe.physicsBody.affectedByGravity = FALSE;
    _gaso.physicsBody.affectedByGravity = FALSE;
    _hencher.physicsBody.affectedByGravity = FALSE;
    _fister.physicsBody.affectedByGravity = FALSE;
    _fisterBoss.physicsBody.affectedByGravity = FALSE;
    _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
    [_fister performSelector:@selector(idle) withObject:nil afterDelay:1.f];
    
}

- (void)play {
  
//--------------------------This is to ensure that game always starts from Training level-----------------------------
//    [GameState sharedGameState].highestUnlockedLevel = @"LevelStart0";
//    [GameState sharedGameState].scoreLevel0 = Nil;
//    [GameState sharedGameState].scoreLevel1 = nil;
//    [GameState sharedGameState].scoreLevel2 = nil;
//    [GameState sharedGameState].scoreLevel3 = nil;
//    [GameState sharedGameState].scoreLevel4 = nil;
//--------------------------------------------------------------------------------------------------------------------
    
    currentLevelStart = [GameState sharedGameState].highestUnlockedLevel;
    if ([currentLevelStart isEqualToString:@"LevelStart0"]) {
        [self showPopoverNamed:currentLevelStart];
    } else {
       [SceneManager presentGameplayScene];
    }
    
}

-(void) showPopoverNamed:(NSString*)name
{
    if (_popoverMenuLayer == nil)
    {
        newMenuLayer = (MenuLayer*)[CCBReader load:name];
        [self addChild:newMenuLayer];
        _popoverMenuLayer = newMenuLayer;
        _popoverMenuLayer.mainscene = self;
    }
}

-(void) removePopover
{
    if (_popoverMenuLayer)
    {
        [_popoverMenuLayer removeFromParent];
        _popoverMenuLayer = nil;
     
    }
}

@end
