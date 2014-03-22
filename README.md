YYHRequest
==========

[![Build Status](https://travis-ci.org/yayuhh/YYHRequest.png?branch=master)](https://travis-ci.org/yayuhh/YYHRequest)
[![Stories in Ready](https://badge.waffle.io/yayuhh/yyhrequest.png?label=ready&title=Ready)](https://waffle.io/yayuhh/yyhrequest)

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

## Getting Started

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

## Usage

### Load a Request

    NSURL *url = [NSURL URLWithString:@"/"];

    [YYHRequest loadRequestWithURL:url success:^(NSData *data) {
        // request complete
    } failure:^(NSError *error) {
        // request failed
    }];

HTTP

    GET /

### Customize a Request

    // set request method
    request.method = @"PUT";

    // set HTTP headers using headers dictionary
    request.headers[@"User-Agent"] = @"value";

    // set header values via properties
    request.userAgent = @"value";

HTTP

    PUT /
    User-Agent: value
    Content-Type: application/x-www-form-urlencoded

### Sending Query Parameters

    YYHRequest *request = [YYHRequest requestWithURL:[NSURL URLWithString:@"/"]];
    request.parameters[@"foo"] = @"bar";

HTTP

    GET /?foo=bar

### Posting Data

    YYHRequest *request = [YYHRequest requestWithURL:[NSURL URLWithString:@"/"]];
    request.method = @"POST";
    request.parameters[@"foo"] = @"bar";

HTTP

    POST /
    Content-Type: application/x-www-form-urlencoded
    foo=bar

### Posting JSON

    YYHJSONRequest *request = [YYHJSONRequest requestWithURL:[NSURL URLWithString:@"/"]];
    request.method = @"POST";
    request.parameters[@"foo"] = @"bar";

HTTP

    POST /
    Content-Type: application/json
    {"foo":"bar"}


## Documentation

See the [documentation](http://cocoadocs.org/docsets/YYHRequest) for more information.

## Changes

[Change log](https://github.com/angelodipaolo/YYHRequest/blob/master/history.md)
