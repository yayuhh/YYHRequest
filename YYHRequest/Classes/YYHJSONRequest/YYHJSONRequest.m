//
//  YYHJSONRequest.m
//  YYHRequest Example
//
//  Created by Angelo Di Paolo on 3/12/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import "YYHJSONRequest.h"

@implementation YYHJSONRequest

- (instancetype)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    
    if (self) {
        self.contentType = @"application/json";
    }
    
    return self;
}

- (NSData *)serializedRequestBody {
    NSError *error;
    NSData *serializedBody = [NSJSONSerialization dataWithJSONObject:self.parameters options:0 error:&error];
    
    if (error) {
        NSLog(@"[YYHJSONRequest serializedRequestBody] error: %@", error);
    }
    
    return serializedBody;
}

@end
