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


@protocol GCRequestDelegate;


@interface GCRequest : NSObject {
    NSString * _url; // Full url for request, e.g. "http://api.glitch.com/simple/players.info"
    NSString * _path; // Specific method path without 'simple', e.g. "players.info"
    NSDictionary * _params; // Dictionary of parameters passed in the request
    id<GCRequestDelegate> _requestDelegate; // Delegate that will be called when events occur before, during, and after the request
    NSURLConnection * _connection; // Connection object - this is held on to until the request completes
    NSMutableData * _receivedResponseData; // Response data, filled up as information is received from the server
}


@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * path;
@property (nonatomic, copy) NSDictionary * params;
@property (nonatomic, assign) id<GCRequestDelegate> requestDelegate;
@property (nonatomic, assign) NSURLConnection * connection;
@property (nonatomic, assign) NSMutableData * receivedResponseData;


#pragma mark - Initialization

// Do not call this directly - call Glitch, which will call this lower-level method
//
// Get a GCRequest object with a specificed method path,
// delegate to call when request/response events occur,
// and any parameters passed in for the request.
+ (GCRequest *)requestWithPath:(NSString*)path
                     delegate:(id<GCRequestDelegate>)delegate
                       params:(NSDictionary*)params;


#pragma mark - Interacting with the API

// Once you have the request object, call this to actually perform the asynchronous request
- (void)connect;

// Parse the data from the server into an object using JSON parser
- (id)parseResponse:(NSData *)data;


#pragma mark - Utility

+ (NSString *)urlEncodeString:(NSString*)string;
+ (NSString*)serializeURL:(NSString*)url params:(NSDictionary*)params;
+ (NSString*)serializeParams:(NSDictionary*)params;
+ (NSDictionary*)deserializeParams:(NSString*)query;


@end


/*------------------------------------------------------*/


@protocol GCRequestDelegate <NSObject>


@optional

// Called when request was completed
- (void)requestFinished:(GCRequest*)request withResult:(id)result;


// Called when request fails
- (void)requestFailed:(GCRequest*)request withError:(NSError*)error;


@end