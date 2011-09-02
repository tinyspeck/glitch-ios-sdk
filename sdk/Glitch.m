/*-
 *  Glitch iOS SDK
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  http://www.glitch.com
 *  http://www.tinyspeck.com
 */


#import "Glitch.h"


static NSString * kGCRedirectUri = @"glitchiossdk://auth";
static NSString * kGCAuthUrl = @"http://api.glitch.com/oauth2/authorize";


@implementation Glitch


@synthesize accessToken = _accessToken,
                clientId = _clientId,
                sessionDelegate = _sessionDelegate;


#pragma mark - Initialization

- (id)initWithDelegate:(id<GCSessionDelegate>)delegate andAPIKey:(NSString*)apiKey 
{
    self = [super init];
    if (self) {
        _sessionDelegate = delegate;
        
        [_clientId release];
        _clientId = [apiKey copy];
    }
    
    return self;
}


#pragma mark - Authorization with Glitch

- (void)authorize{
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             _clientId,@"client_id",
                             kGCRedirectUri,@"redirect_uri",
                             @"token",@"response_type",
                             @"identity",@"scope",
                             //@"hello-world",@"state", // State is an optional value used by the client
                                                        // to maintain state between the request and callback.
                                                        // The auth server includes this value when
                                                        // redirecting the user-agent back to the client.
                             nil];
    
    
    NSString * authUrl = [GCRequest serializeURL:kGCAuthUrl params:params];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
}


- (void)handleOpenURL:(NSURL *)url {
    // If the URL's structure doesn't match the structure used for Glitch authorization, ignore.
    if ([[url absoluteString] hasPrefix:kGCRedirectUri]) {
        // Get the hash tag fragment from the URL
        NSString * fragment = [url fragment];
        
        // Get parameters dictionary from the hash tag fragment
        NSDictionary * params = [GCRequest deserializeParams:fragment];
        NSString * accessToken = [params valueForKey:@"access_token"];
        
        if (accessToken)
        {
            // Successfully logged in! Yay!
            _accessToken = [accessToken copy];
            
            if ([_sessionDelegate respondsToSelector:@selector(glitchLoginSuccess)])
            {
                [_sessionDelegate glitchLoginSuccess];
            }
        }
        else
        {
            // Throw ERROR!
        }
    }
}


#pragma mark - Interacting with the API

- (GCRequest*)requestWithPath:(NSString*)path delegate:(id<GCRequestDelegate>)delegate params:(NSDictionary*)params
{
    NSMutableDictionary * requestParams = [NSMutableDictionary dictionaryWithObject:_accessToken forKey:@"oauth_token"];
    
    if (params)
    {
        [requestParams addEntriesFromDictionary:params];
    }
    
    return [GCRequest requestWithPath:path delegate:delegate params:requestParams];
}


- (GCRequest*)requestWithPath:(NSString*)path delegate:(id<GCRequestDelegate>)delegate
{
    return [self requestWithPath:path delegate:delegate params:nil];
}


@end
