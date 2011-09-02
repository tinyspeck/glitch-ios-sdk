/*-
 *  Glitch iOS SDK Sample App
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  http://www.glitch.com
 *  http://www.tinyspeck.com
 */

#import "SampleViewController.h"


@implementation SampleViewController


@synthesize glitch = _glitch;


#pragma mark - Glitch Request Delegate

// Called when request was completed
- (void)requestFinished:(GCRequest*)request withResult:(id)result
{
    // Validate we've got the right response
    if ([request.method isEqualToString:@"players.info"])
    {
        // Perform validation on the response
        if ([result isKindOfClass:[NSDictionary class]])
        {
            // Get the name of the player from the response
            id player_name = [(NSDictionary*)result objectForKey:@"player_name"];
            
            // Ensure we've got a valid player name
            if (player_name && [player_name isKindOfClass:[NSString class]])
            {
                // Initialize the player name label if it isn't already initialized
                if (!_playerNameLabel)
                {
                    _playerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 200)];
                    _playerNameLabel.textAlignment = UITextAlignmentCenter;
                    _playerNameLabel.font = [UIFont fontWithName:@"VAGRundschriftD" size:32.0f];
                    _playerNameLabel.alpha = 0.8f;
                    _playerNameLabel.backgroundColor = [UIColor clearColor];
                    _playerNameLabel.lineBreakMode = UILineBreakModeWordWrap;
                    _playerNameLabel.numberOfLines = 0;
                    _playerNameLabel.shadowColor = [UIColor whiteColor];
                    _playerNameLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
                    [self.view addSubview:_playerNameLabel];
                }
                
                // Update the label text with our player name
                _playerNameLabel.text = [NSString stringWithFormat:@"Hello, %@!",player_name];
            }
        }
    }
}


// Called when request fails
- (void)requestFailed:(GCRequest*)request withError:(NSError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"The API request failed!" 
                                                   delegate:self cancelButtonTitle:@":-(" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark - Glitch Login Delegate

// Called when login was successful
- (void)glitchLoginSuccess
{
    // Congrats! You're logged in!
    
    // Now let's load up our character image.
    
    // Call API to get basic player information
    GCRequest * request = [_glitch requestWithMethod:@"players.info" delegate:self];
    [request connect];
}


// Called when login fails
- (void)glitchLoginFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"Glitch login failed!" 
                                                   delegate:self cancelButtonTitle:@":-(" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated
{
    [_glitch authorizeWithScope:@"identity"];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    _glitch = [[Glitch alloc] initWithDelegate:self];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)dealloc
{
    [_glitch release];
    [_playerNameLabel release];
    
    [super dealloc];
}


@end
