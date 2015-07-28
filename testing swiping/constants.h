//
//  constants.h
//  testing swiping
//
//  Created by Matteo Sandrin on 08/03/15.
//  Copyright (c) 2015 Richard Kim. All rights reserved.
//

#define BACKGROUND_COLOR 0x6D9DCE
#define CARD_COLOR 0xDE4C4E
#define TEXT_COLOR 0xFFD041
#define YES_COLOR 0X55BE90
#define NO_COLOR 0xDB343F
#define TEXT_WIDTH 230
#define SCORE_WIDTH 160
#define INSC_SQUARE TEXT_WIDTH/1.414
#define INSC_SQUARE_SCORE SCORE_WIDTH/1.414

#define redFromHex(rgbValue) (((float)((rgbValue & 0xFF0000) >> 16))/255.0)
#define greenFromHex(rgbValue) (((float)((rgbValue & 0xFF00) >> 8))/255.0)
#define blueFromHex(rgbValue) (((float)(rgbValue & 0xFF))/255.0)

#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


