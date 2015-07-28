//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "DraggableViewBackground.h"
#import "constants.h"

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* settingsButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    UILabel* noCardsLabel;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 450; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
//        exampleCardLabels =[[HKNewsFetcher sharedFetcher] news]; //%%% placeholder for card-specific information
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
//        [self loadCards];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{

    self.backgroundColor = UIColorFromHEX(BACKGROUND_COLOR); //the gray background colors
//    settingsButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 25, 40, 25)];
//    [settingsButton setImage:[UIImage imageNamed:@"settingsButton"] forState:UIControlStateNormal];
//    [settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
//    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
//    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
//    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
//    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
//    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
//    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
//    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    noCardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-16, self.frame.size.width, 50)];
    noCardsLabel.text = @"That's all, folks!";
    noCardsLabel.textAlignment = NSTextAlignmentCenter;
    [noCardsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:32]];
    [noCardsLabel setHidden:true];
    [self addSubview:settingsButton];
    [self addSubview:messageButton];
    [self addSubview:xButton];
    [self addSubview:checkButton];
    [self addSubview:noCardsLabel];
}


//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(void)insertCardWithData:(NSDictionary*)data
{
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    draggableView.information.text = data[@"title"]; //%%% placeholder for card-specific information
    
    draggableView.data = data;
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    
    int i;
//    NSLog(@"insc: %f",INSC_SQUARE);
    for(i = 30; i > 10; i--)
    {
        font = [font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(INSC_SQUARE, MAXFLOAT);
        CGSize labelSize = [data[@"title"] sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        if(labelSize.height <= INSC_SQUARE)
            break;
    }
    
    draggableView.information.font = font;
//    [draggableView.information sizeToFit];
//    draggableView.information.frame = CGRectMake(draggableView.information.frame.origin.x, draggableView.information.frame.origin.y, 170, draggableView.information.frame.size.height);
    
    
    NSString *score = [NSString stringWithFormat:@"%@",data[@"score"]];
    draggableView.score.text = score;
    font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:70];
    
    for(i = 110; i > 10; i--)
    {
        font = [font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(INSC_SQUARE_SCORE, MAXFLOAT);
        CGSize labelSize = [score sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        if(labelSize.height <= INSC_SQUARE_SCORE)
            break;
    }
    
    draggableView.score.font = font;
    draggableView.delegate = self;
    
    if (loadedCards.count < MAX_BUFFER_SIZE) {
        [self insertSubview:draggableView atIndex:0];
        [loadedCards addObject:draggableView];
        cardsLoadedIndex++;
        [noCardsLabel setHidden:true];
    }
    [allCards addObject:draggableView];
    
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
//-(void)loadCards
//{
//    if([exampleCardLabels count] > 0) {
//        NSInteger numLoadedCardsCap =(([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
//        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
//        
//        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
//        for (int i = 0; i<[exampleCardLabels count]; i++) {
//            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
//            [allCards addObject:newCard];
//            
//            if (i<numLoadedCardsCap) {
//                //%%% adds a small number of cards to be loaded
//                [loadedCards addObject:newCard];
//            }
//        }
//        
//        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
//        // are showing at once and clogging a ton of data
//        for (int i = 0; i<[loadedCards count]; i++) {
//            if (i>0) {
//                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
//            } else {
//                [self addSubview:[loadedCards objectAtIndex:i]];
//            }
//            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
//        }
//    }
//}


//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card
{
    //do whatever you want with the card that was swiped

    DraggableView *c = (DraggableView *)card;
    [self commonSwipe:c];
}


//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    
    DraggableView *c = (DraggableView *)card;
    [self commonSwipe:c];
    [self save:c.data];
    

}

-(void) commonSwipe:(DraggableView*)card{
    NSLog(@"%@",card.data);
    NSMutableArray *stored = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"clubmaster"]];
    [stored addObject:card.data[@"id"]];
    [[NSUserDefaults standardUserDefaults] setObject:stored forKey:@"clubmaster"];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
        [noCardsLabel setHidden:true];
    }
    if ([allCards indexOfObject:card] == allCards.count-1) {
        [noCardsLabel setHidden:false];
    }
}

-(void) save:(NSDictionary*)data{
    
    NSMutableArray *papered = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"papered"]];
    if (![papered containsObject:data[@"id"]]) {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"pass_keychain" accessGroup:nil];
        NSString *user = [keychainItem objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
        NSString *pass = [keychainItem objectForKey:(id)CFBridgingRelease(kSecValueData)];
        AFHTTPRequestOperationManager *m = [AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"https://www.instapaper.com/api/add?username=%@&password=%@&url=%@",user,pass,data[@"url"]];
        NSLog(@"%@",url);
        [m POST:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSLog(@"success");
            NSLog(@"%ld",(long)operation.response.statusCode);
        }failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"failure");
            NSLog(@"%ld",(long)operation.response.statusCode);
        }];
        [papered addObject:data[@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:papered forKey:@"papered"];
    }
    
    

    
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
