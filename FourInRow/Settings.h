//
//  Settings.h
//  FourInRow
//
//  Created by Nikita Gil' on 01.08.15.
//  Copyright (c) 2015 Nikita Gil'. All rights reserved.
//

#ifndef FourInRow_Settings_h
#define FourInRow_Settings_h

//Global

#define FOURWIN         4
#define STARTPOINT     self.frame.size.height * 0.4

//Color

#define FONT_COLOR_RED    [UIColor colorWithRed:(246/255.0) green:(0/255.0) blue:(29/255.0) alpha:1]
#define FONT_COLOR_YELLOW [UIColor colorWithRed:(249/255.0) green:(206/255.0) blue:(21/255.0) alpha:1]
#define FONT_COLOR_GREEN [UIColor colorWithRed:(0/255.0) green:(255/255.0) blue:(64/255.0) alpha:1]


typedef enum {
    PlayerTypeRed = 1,
    PlayerTypeYellow
} PlayerType;

#endif
