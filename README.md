YYHRequest
==========

[![Build Status](https://travis-ci.org/angelodipaolo/YYHRequest.png?branch=master)](https://travis-ci.org/angelodipaolo/YYHRequest)

Simple and lightweight class for loading asynchronous HTTP requests. Built on `NSURLConnection` and `NSOperationQueue`. `YYHRequest` is not intended to be a full-featured networking framework but instead a simple wrapper to avoid the boilerplate of using `NSURLConnection` and `NSURLRequest` for simple networking tasks.

- Lightweight design - just a single wrapper class
- Avoid the boilerplate of `NSURLConnection` and `NSURLRequest` for simple networking tasks
- Simple API for setting request headers, query parameters, and form data
- Block-based `success` and `failure` callbacks for processing response data

## Installation

Install with [CocoaPods](http://cocoapods.org/).

    pod 'YYHRequest'

Install JSON support

    pod 'YYHRequest/JSON'

## Usage

Create and load a request

    NSURL *url = [NSURL URLWithString:@"http://foo.bar"];

    [YYHRequest loadRequestWithURL:url success:^(NSData *data) {
        // request complete
    } failure:^(NSError *error) {
        // request failed
    }];

Create request and load manually.

    YYHRequest *request = [YYHRequest requestWithURL:url];
    request.method = @"POST";
    request.headers[@"Accept"] = @"application/json"
    request.parameters[@"name"] = @"value";

    [request onSuccess:^(NSData *data) {
        // request complete
    }];

    [request loadRequest];

## Documentation

See the [documentation](http://cocoadocs.org/docsets/YYHRequest/0.0.2/) for more information.
