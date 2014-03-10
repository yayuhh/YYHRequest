//
//  YYHRequest.m
//  YYHRequest
//
//  Created by Angelo Di Paolo on 3/8/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import "YYHRequest.h"

@interface YYHRequest ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, copy) NSURLResponse *response;
@property (nonatomic, copy) NSMutableData *responseData;
@property (nonatomic, copy) void (^successCallback)(NSData *data);
@property (nonatomic, copy) void (^failureCallback)(NSError *error);

@end

@implementation YYHRequest

#pragma mark - Accessors

+ (NSOperationQueue *)operationQueue {
    static NSOperationQueue *_operationQueue;
    
    if (!_operationQueue) {
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 4;
    }
    
    return _operationQueue;
}

- (NSMutableData *)responseData {
    if (!_responseData) {
        _responseData = [NSMutableData new];
    }
    
    return _responseData;
}

#pragma mark - Initializing a YYHRequest

+ (instancetype)requestWithURL:(NSURL *)url {
    return [[YYHRequest alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    
    if (self) {
        self.url = url;
    }
    
    return self;
}

#pragma mark - Callbacks

- (void)onSuccess:(void (^)(NSData *data))success {
    self.successCallback = success;
}


- (void)onFailure:(void (^)(NSError *error))failure {
    self.failureCallback = failure;
}

#pragma mark - Loading a Request

+ (instancetype)loadRequestWithURL:(NSURL *)url success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure {
    YYHRequest *request = [[YYHRequest alloc] initWithURL:url];
    request.successCallback = success;
    request.failureCallback = failure;
    [request loadRequest];
    return request;
}

- (void)loadRequest {
    self.connection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:NO];
    self.connection.delegateQueue = [YYHRequest operationQueue];
    [self.connection start];
}

- (void)responseReceived {
    self.successCallback(self.responseData);
}

#pragma mark - NSMutableURLRequest

- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.HTTPMethod = self.method ?: @"GET";
    
    for (NSString *key in self.headers) {
        [request setValue:self.headers[key] forHTTPHeaderField:key];
    }
    
    return request;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self responseReceived];
}

@end
