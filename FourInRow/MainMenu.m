//
//  MainMenu.m
//  FourInRow
//
//  Created by Nikita Gil' on 02.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import "MainMenu.h"
#import "Settings.h"
#import "GameScene.h"
#import "BestTime.h"

@interface MainMenu()

@property (strong, nonatomic) SKSpriteNode* nGameButton;
@property (strong, nonatomic) SKSpriteNode *bestTimeButton;

@end

@implementation MainMenu

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.zPosition = 1;
        
        [self addChild:background];
                
        [self showGameLabel];
        [self showButtons];
        
    }
    return self;
}

//Show main label with games name
-(void) showGameLabel
{
    SKLabelNode *name = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    name.fontSize = 30;
    name.fontColor = FONT_COLOR_RED;
    name.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.7);
    name.zPosition = 21;
    name.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    name.text = @"Game Four in One";
    [self addChild:name];
}

//show buttons and labels on it
-(void) showButtons
{
    _nGameButton = [SKSpriteNode spriteNodeWithImageNamed:@"button"];
    _nGameButton.position = CGPointMake( self.frame.size.width * 0.5, self.frame.size.height * 0.55 );
    _nGameButton.zPosition = 5;
    _nGameButton.size = CGSizeMake(self.frame.size.width * 0.6, self.frame.size.height * 0.1);
    [self addChild:_nGameButton];
    
    SKLabelNode *newGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    newGameLabel.fontSize = 20;
    newGameLabel.fontColor = FONT_COLOR_RED;
    newGameLabel.position = CGPointMake(_nGameButton.position.x, _nGameButton.position.y );
    newGameLabel.zPosition = 6;
    newGameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    newGameLabel.text = @"New Game";
    [self addChild:newGameLabel];
    
    _bestTimeButton = [SKSpriteNode spriteNodeWithImageNamed:@"button"];
    _bestTimeButton.position = CGPointMake( self.frame.size.width * 0.5, self.frame.size.height * 0.38 );
    _bestTimeButton.zPosition = 5;
    _bestTimeButton.size = CGSizeMake(self.frame.size.width * 0.6, self.frame.size.height * 0.1);
    [self addChild:_bestTimeButton];
    
    SKLabelNode *bestTimeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    bestTimeLabel.fontSize = 20;
    bestTimeLabel.fontColor = FONT_COLOR_RED;
    bestTimeLabel.position = CGPointMake(_bestTimeButton.position.x, _bestTimeButton.position.y * 1);
    bestTimeLabel.zPosition = 6;
    bestTimeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    bestTimeLabel.text = @"Best Time";
    [self addChild:bestTimeLabel];
}

#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if ([_nGameButton containsPoint:location])
        {
            SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2f];
            SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.2f];
            SKAction *sequence = [SKAction sequence:@[scaleDown, scaleUp]];
            [_nGameButton runAction:sequence completion:^{
                GameScene *myScene = [[GameScene alloc] initWithSize:self.size];
                SKTransition *reveal = [SKTransition doorwayWithDuration:0.5];
                [self.view presentScene:myScene transition:reveal];
            }];
            
        }
        if ([_bestTimeButton containsPoint:location])
        {
            SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2f];
            SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.2f];
            SKAction *sequence = [SKAction sequence:@[scaleDown, scaleUp]];
            [_bestTimeButton runAction:sequence completion:^{
                BestTime *myScene = [[BestTime alloc] initWithSize:self.size];
                SKTransition *reveal = [SKTransition doorwayWithDuration:0.5];
                [self.view presentScene:myScene transition:reveal];
            }];
        }
    }
}


@end
