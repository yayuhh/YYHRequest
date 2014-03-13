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

+ (NSOperationQueue *)sharedRequestQueue {
    static NSOperationQueue *_sharedRequestQueue;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedRequestQueue = [NSOperationQueue new];
        _sharedRequestQueue.name = @"YYHRequest Connection Queue";
        _sharedRequestQueue.maxConcurrentOperationCount = 4;
    });
    
    return _sharedRequestQueue;
}

- (NSOperationQueue *)requestQueue {
    if (!_requestQueue) {
        _requestQueue = [YYHRequest sharedRequestQueue];
    }
    
    return _requestQueue;
}

- (NSMutableData *)responseData {
    if (!_responseData) {
        _responseData = [NSMutableData new];
    }
    
    return _responseData;
}

- (NSMutableDictionary *)headers {
    if (!_headers) {
        _headers = [NSMutableDictionary new];
    }
    
    return _headers;
}

- (void)setUserAgent:(NSString *)userAgent {
    self.headers[@"User-Agent"] = userAgent;
}

- (NSString *)userAgent {
    return self.headers[@"User-Agent"];
}

#pragma mark - Initializing a YYHRequest

+ (instancetype)requestWithURL:(NSURL *)url {
    return [[YYHRequest alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    
    if (self) {
        self.url = url;
        self.completeOnMainThread = YES;
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
    self.connection.delegateQueue = self.requestQueue;
    [self.connection start];
}

- (void)responseReceived {
    if (self.successCallback) {
        self.successCallback(self.responseData);
    }
}

- (void)requestFailed:(NSError *)error {
    if (self.failureCallback) {
        self.failureCallback(error);
    }
}

#pragma mark - NSMutableURLRequest

- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.HTTPMethod = self.method ?: @"GET";
    request.HTTPBody = self.body;
    
    for (NSString *key in self.headers) {
        [request setValue:self.headers[key] forHTTPHeaderField:key];
    }
    
    return request;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.shouldCompleteOnMainThread) {
        [self performSelectorOnMainThread:@selector(requestFailed:) withObject:error waitUntilDone:[NSThread isMainThread]];
    } else {
        [self requestFailed:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.shouldCompleteOnMainThread) {
        [self performSelectorOnMainThread:@selector(responseReceived) withObject:nil waitUntilDone:[NSThread isMainThread]];
    } else {
        [self responseReceived];
    }
}

@end
