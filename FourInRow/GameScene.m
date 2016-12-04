//
//  GameScene.m
//  FourInRow
//
//  Created by Nikita Gil' on 01.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#import "GameScene.h"
#import "MainMenu.h"
#import "NGLevel.h"
#import "NGPlayer.h"
#import "Settings.h"

static const CGFloat TileWidth = 36.0;
static const CGFloat TileHeight = 36.0;

@interface GameScene()

//Layers
@property (strong, nonatomic) SKNode *gameLayer;
@property (strong, nonatomic) SKNode *mainLayer;
@property (strong, nonatomic) SKNode *tilesLayer;

//Elements
@property (strong, nonatomic) SKSpriteNode *playerCircle;
@property (strong, nonatomic) SKSpriteNode *backButton;
@property (strong, nonatomic) SKSpriteNode *restartButton;
@property (strong, nonatomic) SKLabelNode *playerLabel;
@property (strong, nonatomic) SKLabelNode *timerLabel;
@property (strong, nonatomic) SKLabelNode *endGameLabel;
@property (strong, nonatomic) SKSpriteNode *endGameLayer;

//Work
@property (strong, nonatomic) NGLevel *level;
@property (strong, nonatomic) NSMutableArray *upRowOnBoard; //for top row on board - to detect coordinats
@property (strong, nonatomic) NSMutableArray *inBoard;  //save all circles on board
@property (assign, nonatomic) NSInteger step; //to detect which of players move
@property (strong, nonatomic) NSDate *now;
@property (assign, nonatomic) NSTimeInterval timeFromBegin;
@property (assign, nonatomic) BOOL possibleSwap;

@end

@implementation GameScene


- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.zPosition = 1;
        background.anchorPoint = CGPointMake(0.5, 0.5);
        
        [self addChild:background];
        
        self.gameLayer = [SKNode node];
        self.gameLayer.zPosition = 2;
        [self addChild:self.gameLayer];
        
        CGPoint layerPosition = CGPointMake(-TileWidth*NumColumns/2, -TileHeight*NumRows/2);
        
        //        добавляю клетки, предcтавляющие структуру борда, содержит спрайт ноды
        self.tilesLayer = [SKNode new];
        self.tilesLayer.position = layerPosition;
        self.tilesLayer.zPosition = 3;
        [self.gameLayer addChild:self.tilesLayer];
        
        self.mainLayer = [SKNode node];
        self.mainLayer.position = layerPosition;
        
        [self.gameLayer addChild:self.mainLayer];
        
        self.level = [[NGLevel alloc] init];
        self.upRowOnBoard = [NSMutableArray arrayWithCapacity:NumColumns];
        self.inBoard = [NSMutableArray array];
        [self addTiles];
        
        
        [self beginGame];
        [self setButtons];
 
    }
    return self;
}

-(void) setButtons
{
    self.backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back-button"];
    self.backButton.position = CGPointMake(-self.frame.size.width * 0.4 , self.frame.size.height * 0.44);
    self.backButton.size = CGSizeMake(self.frame.size.width * 0.15 , self.frame.size.width * 0.15);
    self.backButton.zPosition = 15;
    [self.gameLayer addChild:self.backButton];
    
    self.restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];
    self.restartButton.position = CGPointMake(self.frame.size.width * 0.4 , self.frame.size.height * 0.44);
    self.restartButton.size = CGSizeMake(self.frame.size.width * 0.15 , self.frame.size.width * 0.15);
    self.restartButton.zPosition = 15;
    [self.gameLayer addChild:self.restartButton];
}

#pragma mark - Update
-(void)update:(CFTimeInterval)currentTime
{
    if (!self.level.endGame)
    {
        NSDate *current = [[NSDate alloc] init];
        _timeFromBegin = [current timeIntervalSinceDate:self.now];
        [_timerLabel removeFromParent];
        [self setLabelForTimer:_timeFromBegin];
    }
    else
    {
        NSTimeInterval tmp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestTime"] doubleValue];
        if (tmp > _timeFromBegin)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:_timeFromBegin] forKey:@"bestTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


#pragma mark - BeginGame

-(void)beginGame
{
    self.step = 1;
    [self addCircle:self.step];
    [self showPlayerLab:PlayerTypeRed];
    self.now = [[NSDate alloc] init];
    self.possibleSwap = YES;
}

- (void)addTiles
{
    for (NSInteger row = 0; row < NumRows; row++)
    {
        for (NSInteger column = 0; column < NumColumns; column++)
        {
            SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"cell"];
            tileNode.position = [self pointForColumn:column row:row];
            [self.tilesLayer addChild:tileNode];
            if (row == NumRows-1)
            {
                [self.upRowOnBoard addObject:tileNode];
            }
        }
    }
}

-(void) addCircle:(NSInteger)player
{
    NGPlayer *pl = [[NGPlayer alloc]init];
    pl.numberType = player;
    NSString *spriteName = [pl spriteName];
    self.playerCircle = nil;
    self.playerCircle = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    self.playerCircle.name = spriteName;
    self.playerCircle.position = CGPointMake(0, STARTPOINT * 1.5);
    self.playerCircle.zPosition = 5;
    [self.gameLayer addChild:self.playerCircle];
    pl = nil;
    
    SKAction *moveToDest = [SKAction moveTo:CGPointMake(0, STARTPOINT ) duration:1.0f];
    moveToDest.timingMode = SKActionTimingEaseOut;
    [self.playerCircle runAction:moveToDest];
}

-(void) setLabelForTimer:(CGFloat)time
{
    _timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    _timerLabel.fontSize = 20;
    _timerLabel.fontColor = FONT_COLOR_GREEN;
    _timerLabel.position = CGPointMake(0, -self.frame.size.height * 0.47);
    _timerLabel.zPosition = 15;
    _timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
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

    _timerLabel.text = [NSString stringWithFormat:@"Game time: %@:%@:%@", hour, min, sec];

    [self addChild:_timerLabel];
}


#pragma mark - FallingCircle

-(void) fallingCircleWithName:(NSString*)name withColumn:(NSInteger)column
{
    NSInteger type = [NGPlayer spriteTypeByName:name];
    NSInteger row = [self.level fillColumn:column withTypePlayer:type];
    
    CGPoint point = [self pointForColumn:column row:NumRows-1];
    SKSpriteNode *circle = [SKSpriteNode spriteNodeWithImageNamed:name];
    circle.position = point;
    circle.zPosition = 5;
    [self.tilesLayer addChild:circle];
    [self.inBoard addObject:circle];
    
    CGPoint destination = [self pointForColumn:column row:row];
    SKAction *moveToDest = [SKAction moveTo:destination duration:1.0f];
    moveToDest.timingMode = SKActionTimingEaseOut;
    [circle runAction:moveToDest completion:^{
        [self nextTurn];
    }];

}

#pragma mark - NextTern

//start all checks before begin next turn
-(void) nextTurn
{
    [self.level matches];
    [self decrementSteps];
    self.possibleSwap = YES;
}

//count steps for seperate which of player move
-(void)decrementSteps
{
    if (!self.level.endGame)
    {
        self.step += 1;
        if (self.step%2 == 0)
        {
            [self addCircle:PlayerTypeYellow];
            [self showPlayerLab:PlayerTypeYellow];
        }
        else
        {
            [self addCircle:PlayerTypeRed];
            [self showPlayerLab:PlayerTypeRed];
        }
    }
    else
    {
        if (self.step%2 == 0)
        {
            [self showEndGame:PlayerTypeYellow];
        }
        else
        {
            [self showEndGame:PlayerTypeRed];
        }
    }
    
}

//show label with color of player
-(void) showPlayerLab:(PlayerType)type
{
    if (self.playerLabel != nil) {
        [self.playerLabel removeFromParent];
        self.playerLabel = nil;
    }
    self.playerLabel  = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    self.playerLabel.fontSize = 20;
    self.playerLabel.position = CGPointMake(0, self.frame.size.height * 0.45);
    self.playerLabel.zPosition = 10;
    self.playerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    if (type == PlayerTypeRed)
    {
        self.playerLabel.fontColor = FONT_COLOR_RED;
        self.playerLabel.text = @"Player Red Move";
    }
    else if (type == PlayerTypeYellow)
    {
        self.playerLabel.fontColor = FONT_COLOR_YELLOW;
        self.playerLabel.text = @"Player Yellow Move";
    }
     self.playerLabel.alpha = 0;
    [self.gameLayer  addChild:self.playerLabel];
    SKAction *fadeIn = [SKAction fadeInWithDuration:1.1];
    [self.playerLabel runAction:fadeIn];
}

#pragma mark - Converts

//convert column and row in Point
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}


#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if ([self.backButton containsPoint:location])
        {
            SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2f];
            SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.2f];
            SKAction *sequence = [SKAction sequence:@[scaleDown, scaleUp]];
            [self.backButton runAction:sequence completion:^{
                MainMenu *myScene = [[MainMenu alloc] initWithSize:self.size];
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.7];
                [self.view presentScene:myScene transition:reveal];
            }];
            
        }
        if ([self.restartButton containsPoint:location])
        {
            SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2f];
            SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.2f];
            SKAction *sequence = [SKAction sequence:@[scaleDown, scaleUp]];
            [self.restartButton runAction:sequence completion:^{
                [self restartGame];
            }];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.possibleSwap)
    {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            self.playerCircle.position = CGPointMake(location.x, location.y);
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.possibleSwap)
    {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self.tilesLayer];

        for (NSInteger column = 0; column < [self.upRowOnBoard count]; column++)
        {
            if ([(SKSpriteNode*)[self.upRowOnBoard objectAtIndex:column] containsPoint:location])
            {
                self.possibleSwap = NO;
                [self.playerCircle removeFromParent];
                [self fallingCircleWithName:self.playerCircle.name withColumn:column];
                return;//for forbid double click
            }
            else
            {
                SKAction *moveBack = [SKAction moveTo:CGPointMake(0, STARTPOINT) duration:1.0];
                moveBack.timingMode = SKActionTimingEaseIn;
                [self.playerCircle runAction:moveBack];
            }
        }
    }
}




#pragma mark - Restart

//before new game clean board and arrays
-(void) restartGame
{
    for (SKSpriteNode *sp in self.inBoard)
    {
        [sp removeFromParent];
    }
    [_endGameLayer removeFromParent];
    [_endGameLabel removeFromParent];
    _endGameLabel = nil;
    _endGameLayer = nil;
    self.inBoard = nil;
    self.inBoard = [NSMutableArray array];
    [self.level restartLevel];
    [self.playerLabel removeFromParent];
    [self.playerCircle removeFromParent];
    
    [self beginGame];
}

#pragma mark - EndGame

-(void) showEndGame:(PlayerType)type
{
    NSString *player =@"";
    if (type == PlayerTypeRed)
    {
        player = @"Red";
    }
    else if (type == PlayerTypeYellow)
    {
        player = @"Yellow";
    }

    _endGameLayer = [SKSpriteNode spriteNodeWithImageNamed:@"endLayer"];
    _endGameLayer.position = CGPointMake(0, -self.frame.size.height * 0.3);
    _endGameLayer.zPosition = 20;
    _endGameLayer.size = CGSizeMake(self.frame.size.width * 0.6, self.frame.size.height * 0.2);
    [self.gameLayer addChild:_endGameLayer];

    _endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
    _endGameLabel.fontSize = 20;
    _endGameLabel.fontColor = FONT_COLOR_GREEN;
    _endGameLabel.position = CGPointMake(_endGameLayer.position.x, _endGameLayer.position.y * 0.99);
    _endGameLabel.zPosition = 21;
    _endGameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _endGameLabel.text = [NSString stringWithFormat:@"Player %@ WIN", player];
    [self.gameLayer addChild:_endGameLabel];
}

@end
