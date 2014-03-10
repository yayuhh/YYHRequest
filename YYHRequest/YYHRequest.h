//
//  YYHRequest.h
//  YYHRequest
//
//  Created by Angelo Di Paolo on 3/8/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Lightweight class for loading HTTP requests. Built on `NSURLConnection` and `NSOperationQueue`.
 */
@interface YYHRequest : NSObject <NSURLConnectionDataDelegate>

/**
 NSURL used to load the request.
 */
@property (nonatomic, copy) NSURL *url;

/**
 Called when request has loaded successfully.
 */
@property (nonatomic, copy) void (^successCallback)(NSData *data);

/**
 Called when request fails to load.
 */
@property (nonatomic, copy) void (^failureCallback)(NSError *error);

/**
 NSURLResponse object representing the state of the received response.
 */
@property (nonatomic, readonly, copy) NSURLResponse *response;

// @name Creating a Request

/**
 Create request.
 
 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
+ (instancetype)requestWithURL:(NSURL *)url;

// @name Initializing a Request

/**
 Initialize request.
 
 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
- (instancetype)initWithURL:(NSURL *)url;

// @name Loading a Request

/**
 Create and load a request.
 
 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
+ (instancetype)loadRequestWithURL:(NSURL *)url success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;

/**
 Create connection and load request.
 */
- (void)loadRequest;

@end
