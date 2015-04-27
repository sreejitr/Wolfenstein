@interface MainScene : CCNode
-(void) showPopoverNamed:(NSString*)popoverName;
-(void) removePopover;
-(void) loadLevel: (NSString*) levelName;
@end
