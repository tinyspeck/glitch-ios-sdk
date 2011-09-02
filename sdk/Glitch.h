/*-
 *  Glitch iOS SDK
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  http://www.glitch.com
 *  http://www.tinyspeck.com
 */


#import <Foundation/Foundation.h>
#import "GCRequest.h"


@protocol GCSessionDelegate;


@interface Glitch : NSObject {
    NSString * _accessToken;
    id<GCSessionDelegate> _sessionDelegate;
}


@property (nonatomic, copy) NSString * accessToken;
@property (nonatomic, assign) id<GCSessionDelegate> sessionDelegate;


#pragma mark - Initialization

- (id)initWithDelegate:(id<GCSessionDelegate>)delegate;


#pragma mark - Authorization with Glitch

- (void)authorizeWithScope:(NSString*)scope; // Pass in "identity", "read", or "write" as scope. See Glitch API docs for more info about OAuth scopes!
- (void)authorizeWithScope:(NSString*)scope andState:(NSString*)state;
- (void)handleOpenURL:(NSURL *)url;
- (void)logout;


#pragma mark - Utility

- (void)saveAccessTokenToDisk;


#pragma mark - Interacting with the API

- (GCRequest*)requestWithMethod:(NSString*)method delegate:(id<GCRequestDelegate>)delegate params:(NSDictionary*)params;
- (GCRequest*)requestWithMethod:(NSString*)method delegate:(id<GCRequestDelegate>)delegate;


@end


/*------------------------------------------------------*/


@protocol GCSessionDelegate <NSObject>


@optional

// Called when login was successful
- (void)glitchLoginSuccess;


// Called when login fails
- (void)glitchLoginFail;


// Called when logout was completed
- (void)glitchLoggedOut;


@end
