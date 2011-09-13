/*-
 *  Glitch iOS SDK Sample App
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License. 
 *
 *  See more about Glitch at http://www.glitch.com
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
            // Get the status of the auth token
            id ok = [(NSDictionary*)result objectForKey:@"ok"];
            
            // Ensure that we're ok before proceeding! (the ok number is 1)
            if (ok && [ok isKindOfClass:[NSNumber class]] && [(NSNumber*)ok boolValue])
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
                        _playerNameLabel.font = [UIFont fontWithName:@"Open Sans" size:32.0f];
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
                } // end of if (player_name && [player_name isKindOfClass:[NSString class]])
            } // end of if (ok && [ok isKindOfClass:[NSNumber class]] && [(NSNumber*)ok boolValue])
            else
            {
                // If we're NOT ok!
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nooooo!" message:@"The API request was not ok!" 
                                                               delegate:self cancelButtonTitle:@"Darn" otherButtonTitles:nil];
                [alert show];
                [alert release];
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
- (void)glitchLoginFail:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"Glitch login failed!" 
                                                   delegate:self cancelButtonTitle:@":-(" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark - View lifecycle

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _glitch = [[Glitch alloc] initWithDelegate:self];
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [_glitch authorizeWithScope:@"identity"];
}


-(void)dealloc
{
    [_glitch release];
    [_playerNameLabel release];
    
    [super dealloc];
}


@end
