//
//  YYHRequest.h
//  YYHRequest
//
//  Created by Angelo Di Paolo on 3/8/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Simple and lightweight class for loading asynchronous HTTP requests. Built on `NSURLConnection` and `NSOperationQueue`.

 ## Usage

 Create and load a request

    NSURL *url = [NSURL URLWithString:@"http://foo.bar"];

    [YYHRequest loadRequestWithURL:url success:^(NSData *data) {

    } failure:^(NSError *error) {

    }];

Create request and load manually.

    YYHRequest *request = [YYHRequest requestWithURL:url];

    [request onSuccess:^(NSData *data) {
        // request complete
    }];

    [request loadRequest];

 */
@interface YYHRequest : NSObject <NSURLConnectionDataDelegate>

/// @name Getting the Shared Request Operation Queue

/**
 Access the shared request queue instance.
 */
+ (NSOperationQueue *)sharedRequestQueue;

/// @name Specifying the Request Operation Queue

/**
 Set to specify the NSOperationQueue instance used for queueing connection operations. If unspecified a shared request queue is created as `sharedRequestQueue`.
 */
@property (nonatomic, strong) NSOperationQueue *requestQueue;

/// @name Configuring a Request

/**
 NSURL used to load the request.
 */
@property (nonatomic, copy) NSURL *url;

/**
 NSURL used to load the request.
 */
@property (nonatomic, copy) NSString *method;

/**
 HTTP body data.
 */
@property (nonatomic, copy) NSData *body;

/**
 User agent string.
 */
@property (nonatomic, copy) NSString *userAgent;

/**
 User agent string.
 */
@property (nonatomic, copy) NSString *contentType;

/**
 Request headers.
 */
@property (nonatomic, copy) NSMutableDictionary *headers;

/**
 Request parameters.
 */
@property (nonatomic, copy) NSMutableDictionary *parameters;

/**
 Determines if the success and failure callbacks are called on the main thread. Default to YES.
 */
@property (nonatomic, assign, getter = shouldCompleteOnMainThread) BOOL completeOnMainThread;

/**
 Set callback block to be invoked when the request has loaded successfully.
 */
- (void)onSuccess:(void (^)(NSData *data))success;

/**
 Set callback block to be invoked when the request fails.
 */
- (void)onFailure:(void (^)(NSError *error))failure;

/// @name Reading the Response

/**
 NSURLResponse object representing the state of the received response.
 */
@property (nonatomic, readonly, copy) NSURLResponse *response;

/// @name Creating a Request

/**
 Create request.

 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
+ (instancetype)requestWithURL:(NSURL *)url;

/// @name Initializing a Request

/**
 Initialize request.

 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
- (instancetype)initWithURL:(NSURL *)url;

/// @name Request Serialization

- (NSData *)serializedRequestBody;

/// @name Loading a Request

/**
 Create and load a request.

 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
+ (instancetype)loadRequestWithURL:(NSURL *)url success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;

/**
 Create connection and load the request.
 
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
- (void)loadRequestWithSuccess:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;

/**
 Create connection and load request.
 */
- (void)loadRequest;

@end
