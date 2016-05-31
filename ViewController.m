//
//  ViewController.m
//  Dot 2 Dot TV
//
//  Created by Mathew Darcy on 29/01/2016.
//

#import "ViewController.h"


@import UIKit;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *MainView;

@end

@implementation ViewController

UIButton *cardFace1, *cardFace2;
UIButton *flipBack1, *flipBack2;        //required to separate cards to be over turned if user tries to pick third card
UIButton *btnEasy, *btnMedium, *btnHard;
//Display Title
UIImageView *ivTitle;
int firstFlip, flipFirst, flipSecond;
NSString *face1;
NSString *face2;
NSMutableArray *faceArray;
NSMutableArray *cardArray;
NSMutableArray *viewArray;
int gameSize, rows;
CGSize screenSize;
int pairs;
UIImageView *backgroundView, *winningView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    pairs = 0;
    
    //set the background to the brain image used on launch
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage.png"]];
    [self.view addSubview:backgroundView];
    
    //get the screen size
    screenSize = _MainView.frame.size;
    
    cardArray = [[NSMutableArray alloc] initWithCapacity:24];
    viewArray = [[NSMutableArray alloc] initWithCapacity:24];
    
    //Create the faces of the cards
    faceArray = [NSMutableArray arrayWithObjects:@"Star", @"Star", @"Square", @"Square", @"Circle", @"Circle", @"Cloud", @"Cloud", @"Diamond", @"Diamond", @"Heart", @"Heart", @"Music", @"Music", @"Nuclear", @"Nuclear", @"Spade", @"Spade", @"Light", @"Light", @"Recycle", @"Recycle", @"Club", @"Club",nil];
    
    //Display Title
    ivTitle = [[UIImageView alloc] init];
    UIImage *myimg = [UIImage imageNamed:@"Title.png"];
    ivTitle.image=myimg;
    ivTitle.frame = CGRectMake(screenSize.width / 4, 100, screenSize.width / 2, 150);
    
    //Display player difficulty options, and check for result
    btnEasy = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //set its size
    btnEasy.frame = CGRectMake((screenSize.width / 2) - 100, (screenSize.height / 2) - 150, 200, 100);
    
    //add the event listener
    [btnEasy addTarget:self action:@selector(DifficultyClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    //Set the button Title
    [btnEasy setTitle:@"Easy" forState:UIControlStateNormal];
    
    [btnEasy setHidden:false];
    
    [btnEasy setEnabled:true];
    
    //Display player difficulty options, and check for result
    btnMedium = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //set its size
    btnMedium.frame = CGRectMake((screenSize.width / 2) - 130, (screenSize.height / 2), 260, 100);
    
    //add the event listener
    [btnMedium addTarget:self action:@selector(DifficultyClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    //Set the button Title
    [btnMedium setTitle:@"Medium" forState:UIControlStateNormal];
    
    [btnMedium setHidden:false];
    
    [btnMedium setEnabled:true];
    
    //Display player difficulty options, and check for result
    btnHard = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //set its size
    btnHard.frame = CGRectMake((screenSize.width / 2) - 100, (screenSize.height / 2) + 150, 200, 100);
    
    //add the event listener
    [btnHard addTarget:self action:@selector(DifficultyClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    //Set the button Title
    [btnHard setTitle:@"Hard" forState:UIControlStateNormal];
    
    [btnHard setHidden:false];
    
    [btnHard setEnabled:true];
    
    [self.view addSubview:ivTitle];
    [self.view addSubview:btnEasy];
    [self.view addSubview:btnMedium];
    [self.view addSubview:btnHard];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) DifficultyClicked:(id)sender
{
    //Create an instance of the object which was selected
    UIButton *button = (UIButton *)sender;
    NSString *difficulty = [button titleForState:UIControlStateNormal];
    
    [ivTitle setHidden:true];
    [btnEasy setHidden:true];
    [btnMedium setHidden:true];
    [btnHard setHidden:true];
    
     
    if ([difficulty isEqualToString:@"Easy"])
    {
        gameSize = 12;      //these values to change based on the player difficulty selection
        rows = 3;
        
        [self createCards];
        
        //Shuffle the cards
        [self shuffle];
    }
    
    if ([difficulty isEqualToString:@"Medium"])
    {
        gameSize = 18;
        rows = 3;
        
        [self createCards];
        
        [self shuffle];
    }
    
    if ([difficulty isEqualToString:@"Hard"])
    {
        gameSize = 24;
        rows = 4;
        
        [self createCards];
        
        [self shuffle];
    }
    
}

-(void) ButtonClicked:(id)sender
{
    //Create an instance of the object which was selected
    UIButton *button = (UIButton *)sender;
    [button setEnabled:NO];
    int buttonNumber = 0;
    
    //We need to loop through all of the cards
    for (int i = 0; i < [cardArray count]; i++)
    {
        //If we have a match, then we know which card in the array to flip over
        if (button == cardArray[i])
        {
            buttonNumber = i;
        }
    }
    
    //Create the name of the image we need to display
    NSMutableString *imageName = [[NSMutableString alloc]init];
    [imageName appendString:faceArray[buttonNumber]];
    [imageName appendString:@".png"];
    
    //Create a button for the face of the card which was selected
    UIButton *faceBut = cardArray[buttonNumber];
    
    //Has the user already selected a card?
    if (face1 == NULL)
    {
        //Initialise the button for the face of the card
        cardFace1 = [UIButton buttonWithType:UIButtonTypeSystem];
        //Set the size of the card
        cardFace1.frame = faceBut.frame;
        //Set the image of the face of the card to the string constructed above
        [cardFace1 setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    else
    {
        //Initialise the button for the face of the card
        cardFace2 = [UIButton buttonWithType:UIButtonTypeSystem];
        //Set the size of the card
        cardFace2.frame = faceBut.frame;
        //Set the image of the face of the card to the string constructed above
        [cardFace2 setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    //Has the player already selected a card
    if (face1 == NULL)
    {
        face1 = faceArray[buttonNumber];
        firstFlip = buttonNumber;   //index of the first card which was flipped
        
        [UIView transitionFromView:cardArray[buttonNumber] toView:(cardFace1) duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    }
    else
    {
        face2 = faceArray[buttonNumber];
        
        BOOL match = false;
        
        //we only want to check for a match after 2 cards have been selected so not required above
        
        //check for a match
        if ([self CheckForMatch])
        {
            match = true;
            
            pairs += 2;
            //maybe add a counter here to check whether all pairs have been completed
            //for game to be complete counter must be gameSize / 2
            NSLog(@"We have a match!");
            
        }
        else
        {
            match = false;
        }
        
        //re-initialise everything
        face1 = NULL;
        face2 = NULL;
        
        //copy all the variables to new values so they can be overwritten.  Without this, if the player selects too fast, logic fails.
        flipBack1 = cardFace1;
        flipBack2 = cardFace2;
        
        flipFirst = firstFlip;
        flipSecond = buttonNumber;
        
        [UIView transitionFromView:cardArray[buttonNumber] toView:(flipBack2) duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished){
            
            if (!match)
            {
                //flip card 1 back over and re-enable
                [UIView transitionFromView:flipBack1 toView:cardArray[flipFirst] duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft  completion:nil];
                [cardArray[flipFirst] setEnabled:true];
            
                //flip card 2 back over and re-enable
                [UIView transitionFromView:flipBack2 toView:cardArray[flipSecond] duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
                [cardArray[flipSecond] setEnabled:true];
            }
            else
            {
                //If equal, player has completed the game
                if (pairs == gameSize)
                {
                    //Player has matched all pairs, display complete, and return to game selection
                    winningView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Complete.png"]];
                    [UIView transitionFromView:backgroundView toView:winningView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished){
                        //Display complete message for 2 seconds
                        [NSThread sleepForTimeInterval:2.0f];
                        
                        //Clear all views from the main view
                        [[_MainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                        
                        //Back to the start
                        [self viewDidLoad];
                    }];
                }
            }
        }];
    }
    

}

-(bool) CheckForMatch
{
    if (face1 == face2)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(void) createCards
{
    for (int i = 0; i < gameSize; i++)
    {
        //create button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
        //set its size
        button.frame = CGRectMake(0, 0, 118, 163);
    
        //set the background image
        [button setBackgroundImage:[UIImage imageNamed:@"Card.png"] forState:UIControlStateNormal];
        
        //add the event listener
        [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventPrimaryActionTriggered];
        
        
    
        //then add the button to the array
        [cardArray addObject:button];
        
        //where to start on left of screen
        int left = (screenSize.width / 2) - (100 * gameSize / rows);
        
        //where to start from top of screen
        int top = (screenSize.height / 2) - (100 * rows);
    
        //create UIView  location of the view is dependant on number of cards and rows required
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((left + (200 * (i / rows))), top + (200 * (i % rows)), 118, 163)];
    
        //add the view to the view array
        [viewArray addObject:view];
    
        //add the button to the view array
        [viewArray[i] addSubview:cardArray[i]];
        
        [self.view addSubview:viewArray[i]];
        
        [self.view setNeedsFocusUpdate];
    }
    
}

- (void)shuffle
{
    for (NSUInteger i = 0; i < gameSize - 1; ++i) {
        NSInteger remainingCount = gameSize - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [faceArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
