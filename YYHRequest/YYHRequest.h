//
//  YYHRequest.h
//  YYHRequest
//
//  Created by Angelo Di Paolo on 3/8/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYHRequest : NSObject <NSURLConnectionDataDelegate>

/**
 NSURLResponse receied from request.
 */
@property (nonatomic, readonly, copy) NSURLResponse *response;

// @name Sending a Request

+ (YYHRequest *)requestWithURL:(NSURL *)url success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;

@end
