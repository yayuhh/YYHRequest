//
//  YYHRequestTests.m
//  YYHRequestTests
//
//  Created by Angelo Di Paolo on 3/8/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YYHRequest.h"

@interface YYHRequestTests : XCTestCase

@end

@implementation YYHRequestTests

- (void)testDefaultProperties {
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    YYHRequest *request = [YYHRequest requestWithURL:url];
    
    XCTAssertTrue([request.method isEqualToString:@"GET"]);
    XCTAssertTrue(request.completeOnMainThread);
    XCTAssertEqual(request.url, url);
}

- (void)testSetHeaderProperties {
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    YYHRequest *request = [YYHRequest requestWithURL:url];
    
    request.contentType = @"text/plain";
    request.userAgent = @"some test agent";
    
    XCTAssertEqual(request.headers[@"Content-Type"], request.contentType);
    XCTAssertEqual(request.headers[@"User-Agent"], request.userAgent);
}

@end
