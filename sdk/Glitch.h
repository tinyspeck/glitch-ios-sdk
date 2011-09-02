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
    NSString * _clientId;
    id<GCSessionDelegate> _sessionDelegate;
}


@property (nonatomic, copy) NSString * accessToken;
@property (nonatomic, copy) NSString * clientId;
@property (nonatomic, assign) id<GCSessionDelegate> sessionDelegate;


#pragma mark - Initialization

- (id)initWithDelegate:(id<GCSessionDelegate>)delegate andAPIKey:(NSString*)apiKey;


#pragma mark - Authorization with Glitch

- (void)authorize;
- (void)handleOpenURL:(NSURL *)url;


#pragma mark - Interacting with the API

- (GCRequest*)requestWithPath:(NSString*)path delegate:(id<GCRequestDelegate>)delegate params:(NSDictionary*)params;
- (GCRequest*)requestWithPath:(NSString*)path delegate:(id<GCRequestDelegate>)delegate;


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
