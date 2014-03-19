//
//  YYHJSONRequestTests.m
//  YYHRequest
//
//  Created by Angelo Di Paolo on 3/19/14.
//  Copyright (c) 2014 Yayuhh. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YYHJSONRequest.h"

@interface YYHJSONRequestTests : XCTestCase

@end

@implementation YYHJSONRequestTests

- (void)testDefaultProperties {
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    YYHJSONRequest *request = [YYHJSONRequest requestWithURL:url];
        
    XCTAssertTrue([request.contentType isEqualToString:@"application/json"]);
    XCTAssertEqual(request.readingOptions, NSJSONReadingAllowFragments);
}

@end
