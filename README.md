YYHRequest
==========

Simple and lightweight class for loading asynchronous HTTP requests. Built on `NSURLConnection` and `NSOperationQueue`.

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

    [request onSuccess:^(NSData *data) {
        // request complete
    }];

    [request loadRequest];
