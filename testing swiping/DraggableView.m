//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#import "constants.h"

#define ACTION_MARGIN 50 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle

#import <QuartzCore/QuartzCore.h>
#import "DraggableView.h"



@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

//delegate is instance of ViewController
@synthesize delegate;

@synthesize panGestureRecognizer,tapGestureRecognizer;
@synthesize information,score,roundView;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        roundView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, TEXT_WIDTH, TEXT_WIDTH)];
        information = [[UILabel alloc]initWithFrame:CGRectMake((TEXT_WIDTH-INSC_SQUARE)/2, (TEXT_WIDTH-INSC_SQUARE)/2, INSC_SQUARE, INSC_SQUARE)];
        roundView.layer.cornerRadius = TEXT_WIDTH/2;
        roundView.backgroundColor = UIColorFromHEX(BACKGROUND_COLOR);
        roundView.clipsToBounds = YES;
        [self addSubview:roundView];
//        information.layer.borderColor = [[UIColor redColor] CGColor];
//        information.layer.borderWidth = 3.0f;
        information.numberOfLines = 0;
        information.text = @"no info given";
        [information setTextAlignment:NSTextAlignmentCenter];
        information.textColor = UIColorFromHEX(TEXT_COLOR);
        information.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
        information.lineBreakMode = NSLineBreakByWordWrapping;
        information.minimumScaleFactor = 0.5;
        
        score = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-SCORE_WIDTH/2, (roundView.frame.origin.y+roundView.frame.size.height+self.frame.size.height)/2-SCORE_WIDTH/2, SCORE_WIDTH, SCORE_WIDTH)];
//        score.layer.borderColor = [[UIColor greenColor] CGColor];
//        score.layer.borderWidth = 1.0f;
        score.text = @"no info given";
        [score setTextAlignment:NSTextAlignmentCenter];
        score.textColor = UIColorFromHEX(TEXT_COLOR);
        score.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:50];
        score.lineBreakMode = NSLineBreakByWordWrapping;
        score.layer.cornerRadius = SCORE_WIDTH/2;
        score.backgroundColor = UIColorFromHEX(BACKGROUND_COLOR);
        score.clipsToBounds = YES;
        
        self.backgroundColor = UIColorFromHEX(CARD_COLOR);
#warning placeholder stuff, replace with card-specific information }
        
        
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beingTapped:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        [self addGestureRecognizer:tapGestureRecognizer];
        [roundView addSubview:information];
        [self addSubview:score];
        
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 30;
    self.layer.shadowRadius = 10;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    [self setBackgroundColor:UIColorFromHEX(0xA7DCDB)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngle = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

-(void)beingTapped:(UITapGestureRecognizer *)gestureRecognizer{
    if ([self.data[@"url"]  isEqual: @""]) {
        NSString *url = [NSString stringWithFormat:@"https://news.ycombinator.com/item?id=%@",self.data[@"id"]];
        OpenInChromeController *chrome = [OpenInChromeController sharedInstance];
        if ([chrome isChromeInstalled]) {
            [chrome openInChrome:[NSURL URLWithString:url]
                            withCallbackURL:nil
                               createNewTab:true];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }else{

        OpenInChromeController *chrome = [OpenInChromeController sharedInstance];
        if ([chrome isChromeInstalled]) {
            [chrome openInChrome:[NSURL URLWithString:self.data[@"url"]]
                 withCallbackURL:nil
                    createNewTab:true];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.data[@"url"]]];
        }
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    int st = BACKGROUND_COLOR;
    int end = NO_COLOR;
    
    if (distance > 0) {
        end = YES_COLOR;
    }

    
    float endDec = MIN(fabsf(distance)/100.0f, 1);
    float startDec = 1 - endDec;
    UIColor *newColor = [UIColor colorWithRed:(redFromHex(st)*startDec)+(redFromHex(end)*endDec) green:(greenFromHex(st)*startDec)+(greenFromHex(end)*endDec) blue:(blueFromHex(st)*startDec)+(blueFromHex(end)*endDec) alpha:1];
    
    self.roundView.backgroundColor = newColor;
    self.score.backgroundColor = newColor;
    
    
//    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                             self.roundView.backgroundColor = UIColorFromHEX(BACKGROUND_COLOR);
                             self.score.backgroundColor = UIColorFromHEX(BACKGROUND_COLOR);
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}



@end
