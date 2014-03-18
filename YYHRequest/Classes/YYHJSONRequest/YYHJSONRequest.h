//
//  YYHJSONRequest.h
//  YYHRequest Example
//
//  Created by Angelo Di Paolo on 3/12/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import "YYHRequest.h"

/**
 Simple and lightweight class for loading asynchronous HTTP requests w/ JSON. Built on `NSURLConnection` and `NSOperationQueue`. Uses `NSJSONSerialization` for reading and writing JSON.

 ## Usage

     [YYHJSONRequest loadJSONWithURL:[NSURL URLWithString:@"http://foo.bar/json"] success:^(id json) {
        // json response
    } failure:^(NSError *error) {
        // failure
    }];

 */
@interface YYHJSONRequest : YYHRequest

/// @name Configuring a Request

/**
 Options for reading the JSON data and creating the Foundation objects.
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

/**
 Options for writing JSON data.
 */
@property (nonatomic, assign) NSJSONWritingOptions writingOptions;

/**
 Set callback block to be invoked when the JSON request has loaded successfully.
 */
- (void)onJSONSuccess:(void (^)(id json))success;

/// @name Loading a JSON Request

/**
 Create and load a JSON request.
 
 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
+ (instancetype)loadJSONWithURL:(NSURL *)url success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 Load a JSON request.
 
 @param url NSURL used to load the request.
 @param success Called when request has loaded successfully.
 @param failure Called when request fails to load.
 */
- (void)loadJSONWithSuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
