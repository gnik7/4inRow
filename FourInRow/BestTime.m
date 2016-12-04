//
//  BestTime.m
//  FourInRow
//
//  Created by Nikita Gil' on 02.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import "BestTime.h"
#import "MainMenu.h"
#import "Settings.h"

@implementation BestTime


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

//Show Labels with best time and time on screen
-(void) showGameLabel
{
    SKLabelNode *name = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    name.fontSize = 30;
    name.fontColor = FONT_COLOR_RED;
    name.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.7);
    name.zPosition = 21;
    name.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    name.text = @"Best Time in Game";
    [self addChild:name];
    
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    timeLabel.fontSize = 20;
    timeLabel.fontColor = FONT_COLOR_GREEN;
    timeLabel.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    timeLabel.zPosition = 21;
    timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    CGFloat time = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestTime"] doubleValue];
    if (time == 0)
    {
        timeLabel.text = @"-";
    }
    else
    {
    NSInteger hourI = (NSInteger)(time/3600);
    NSInteger minI = (NSInteger)(time - hourI * 3600)/60;
    NSInteger secI = (NSInteger)(time - hourI * 3600 - minI * 60);
    
    NSString *hour = @"";
    NSString *min = @"";
    NSString *sec = @"";
    
    if (hourI < 10 )
        hour = [NSString stringWithFormat:@"0%lu", (long)hourI];
    else
        hour = [NSString stringWithFormat:@"%lu", (long)hourI];
    
    if (minI < 10 )
        min = [NSString stringWithFormat:@"0%lu", (long)minI];
    else
        min = [NSString stringWithFormat:@"%lu", (long)minI];
    
    if (secI < 10 )
        sec = [NSString stringWithFormat:@"0%lu", (long)secI];
    else
        sec = [NSString stringWithFormat:@"%lu", (long)secI];
    
    timeLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hour, min, sec];
    }
    [self addChild:timeLabel];
}

-(void) showButtons
{
    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back-button"];
    backButton.name = @"backButton";
    backButton.position = CGPointMake(self.frame.size.width * 0.1 , self.frame.size.height * 0.9);
    backButton.size = CGSizeMake(self.frame.size.width * 0.15 , self.frame.size.width * 0.15);
    backButton.zPosition = 15;
    [self addChild:backButton];
}

#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKSpriteNode *backButton = (SKSpriteNode*)[self childNodeWithName:@"backButton"];
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if ([backButton containsPoint:location])
        {
            SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2f];
            SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.2f];
            SKAction *sequence = [SKAction sequence:@[scaleDown, scaleUp]];
            [backButton runAction:sequence completion:^{
                MainMenu *myScene = [[MainMenu alloc] initWithSize:self.size];
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                [self.view presentScene:myScene transition:reveal];
            }];
            
        }
    }
}


@end
