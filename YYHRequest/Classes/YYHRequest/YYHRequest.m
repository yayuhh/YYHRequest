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

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary new];
    }
    
    return _parameters;
}

- (void)setUserAgent:(NSString *)userAgent {
    self.headers[@"User-Agent"] = userAgent;
}

- (NSString *)userAgent {
    return self.headers[@"User-Agent"];
}

- (void)setContentType:(NSString *)contentType {
    self.headers[@"Content-Type"] = contentType;
}

- (NSString *)contentType {
    return self.headers[@"Content-Type"];
}

#pragma mark - Initializing a YYHRequest

+ (instancetype)requestWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    
    if (self) {
        self.url = url;
        self.method = @"GET";
        self.completeOnMainThread = YES;
    }
    
    return self;
}

#pragma mark - Loading the Request

+ (instancetype)loadRequestWithURL:(NSURL *)url success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure {
    YYHRequest *request = [[YYHRequest alloc] initWithURL:url];
    [request loadRequestWithSuccess:success failure:failure];
    return request;
}

- (void)loadRequestWithSuccess:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure {
    self.successCallback = success;
    self.failureCallback = failure;
    [self loadRequest];
}

- (void)loadRequest {
    if (self.parameters) {
        [self serializeRequestParameters];
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:NO];
    self.connection.delegateQueue = self.requestQueue;
    [self.connection start];
}

#pragma mark - Handling the Response

- (void)onSuccess:(void (^)(NSData *data))success {
    self.successCallback = success;
}


- (void)onFailure:(void (^)(NSError *error))failure {
    self.failureCallback = failure;
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

#pragma mark - Request Parameters

- (void)serializeRequestParameters {
    if (!self.contentType) {
        self.contentType = @"application/x-www-form-urlencoded";
    }
    
    if ([self.method isEqualToString:@"GET"]) {
        self.url = [self queryParametersURL];
    } else {
        self.body = [self serializedRequestBody];
    }
}

- (NSData *)serializedRequestBody {
    return [[self queryString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)queryParametersURL {
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", [self.url absoluteString], [self queryString]];
    return [NSURL URLWithString:urlString];
}

- (NSString *)queryString {
    NSMutableArray *encodedParameters = [NSMutableArray arrayWithCapacity:self.parameters.count];
    
    for (NSString *key in self.parameters) {
        NSString *value = self.parameters[key];
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *encodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [encodedParameters addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }
    }
    
    return [encodedParameters componentsJoinedByString:@"&"];
}

#pragma mark - NSMutableURLRequest

- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.HTTPMethod = self.method;
    request.HTTPBody = self.body;
    
    for (NSString *key in self.headers) {
        [request setValue:self.headers[key] forHTTPHeaderField:key];
    }
    
    if (self.body.length) {
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.body.length] forHTTPHeaderField:@"Content-Length"];
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
