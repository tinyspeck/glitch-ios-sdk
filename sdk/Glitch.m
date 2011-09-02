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
#import "GlitchConfig.h"


static NSString * const kGCAuthUrl = @"http://api.glitch.com/oauth2/authorize";


@implementation Glitch


NSString * AccessTokenSavePath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"GlitchOAuthAccessToken.cache"];
}


@synthesize accessToken = _accessToken,
                sessionDelegate = _sessionDelegate;


#pragma mark - Initialization

- (id)initWithDelegate:(id<GCSessionDelegate>)delegate
{
    self = [super init];
    if (self) {
        _sessionDelegate = delegate;
    }
    
    return self;
}


#pragma mark - Authorization with Glitch

// Pass in "identity", "read", or "write" as scope. See Glitch API docs for more info about OAuth scopes!
- (void)authorizeWithScope:(NSString*)scope
{
    [self authorizeWithScope:scope andState:nil];
}


// State is an optional value used by the client to maintain state between the request and callback.
// The auth server includes this value when redirecting the user-agent back to the client.
- (void)authorizeWithScope:(NSString*)scope andState:(NSString*)state
{
    // Check for saved token
    NSString * savedToken = [NSKeyedUnarchiver unarchiveObjectWithFile:AccessTokenSavePath()];
    
    if (savedToken)
    {
        // Using saved token
        _accessToken = [savedToken copy];
        
        if ([_sessionDelegate respondsToSelector:@selector(glitchLoginSuccess)])
        {
            [_sessionDelegate glitchLoginSuccess];
        }
        
        return;
    }
    
    // Set scope to identity if we don't have it
    NSString * serviceScope = scope ? scope : @"identity";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             GCAPIKey,@"client_id",
                             GCRedirectURI,@"redirect_uri",
                             @"token",@"response_type",
                             serviceScope,@"scope",
                             nil];
    
    if (state)
    {
        [params setValue:state forKey:@"state"];
    }
    
    
    NSString * authUrl = [GCRequest serializeURL:kGCAuthUrl params:params];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
}


- (void)handleOpenURL:(NSURL *)url {
    // If the URL's structure doesn't match the structure used for Glitch authorization, ignore.
    if ([[url absoluteString] hasPrefix:GCRedirectURI]) {
        // Get the hash tag fragment from the URL
        NSString * fragment = [url fragment];
        
        // Get parameters dictionary from the hash tag fragment
        NSDictionary * params = [GCRequest deserializeParams:fragment];
        NSString * accessToken = [params valueForKey:@"access_token"];
        
        if (accessToken)
        {
            // Successfully logged in! Yay!
            _accessToken = [accessToken copy];
            
            [self saveAccessTokenToDisk];
            
            if ([_sessionDelegate respondsToSelector:@selector(glitchLoginSuccess)])
            {
                [_sessionDelegate glitchLoginSuccess];
            }
        }
        else
        {
            // Throw ERROR!
            if ([_sessionDelegate respondsToSelector:@selector(glitchLoginFail)])
            {
                [_sessionDelegate glitchLoginFail];
            }
        }
    }
}


- (void)logout
{
    _accessToken = nil;
    [[NSFileManager defaultManager] removeItemAtPath:AccessTokenSavePath() error:nil];
    
    if ([_sessionDelegate respondsToSelector:@selector(glitchLoggedOut)])
    {
        [_sessionDelegate glitchLoggedOut];
    }
}


#pragma mark - Utility

- (void)saveAccessTokenToDisk
{
    [NSKeyedArchiver archiveRootObject:_accessToken toFile:AccessTokenSavePath()];
}


#pragma mark - Interacting with the API

- (GCRequest*)requestWithMethod:(NSString*)method delegate:(id<GCRequestDelegate>)delegate params:(NSDictionary*)params
{
    NSMutableDictionary * requestParams = [NSMutableDictionary dictionaryWithObject:_accessToken forKey:@"oauth_token"];
    
    if (params)
    {
        [requestParams addEntriesFromDictionary:params];
    }
    
    return [GCRequest requestWithMethod:method delegate:delegate params:requestParams];
}


- (GCRequest*)requestWithMethod:(NSString*)method delegate:(id<GCRequestDelegate>)delegate
{
    return [self requestWithMethod:method delegate:delegate params:nil];
}


@end
