//
//  YYHJSONRequest.m
//  YYHRequest Example
//
//  Created by Angelo Di Paolo on 3/12/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import "YYHJSONRequest.h"

@interface YYHJSONRequest ()

@property (nonatomic, copy) void (^successCallback)(id json);
@property (nonatomic, copy) void (^failureCallback)(NSError *error);

@end

@implementation YYHJSONRequest

- (instancetype)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    
    if (self) {
        self.contentType = @"application/json";
        self.writingOptions = 0;
        self.readingOptions = NSJSONReadingAllowFragments;
        
        [self onSuccess:^(NSData *data) {
            [self handleJSONResponse:data];
        }];
    }
    
    return self;
}

- (NSData *)serializedRequestBody {
    NSError *error;
    NSData *serializedBody = [NSJSONSerialization dataWithJSONObject:self.parameters options:self.writingOptions error:&error];
    
    if (error) {
        NSLog(@"[YYHJSONRequest serializedRequestBody] error: %@", error);
    }
    
    return serializedBody;
}

+ (instancetype)loadJSONWithURL:(NSURL *)url success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    YYHJSONRequest *request = [YYHJSONRequest requestWithURL:url];
    [request loadJSONWithSuccess:success failure:failure];
    return request;
}

- (void)loadJSONWithSuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    [self loadRequestWithSuccess:^(NSData *data) {
        [self handleJSONResponse:data];
    } failure:failure];
}

- (void)handleJSONResponse:(NSData *)data {
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&error];
    
    if (error) {
        self.failureCallback(error);
    } else if (self.successCallback) {
        self.successCallback(json);
    }
}

- (void)onJSONSuccess:(void (^)(id json))success {
    self.successCallback = success;
}

- (void)onFailure:(void (^)(NSError *error))failure {
    self.failureCallback = failure;
}

@end
