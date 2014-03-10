YYHRequest
==========

Simple asynchronous networking class built on `NSURLConnection` and `NSOperationQueue`

## Usage

Create and load a request

    NSURL *url = [NSURL URLWithString:@"http://foo.bar"];

    [YYHRequest loadRequestWithURL:url success:^(NSData *data) {

    } failure:^(NSError *error) {

    }];

Create request and load manually.

    YYHRequest *request = [YYHRequest requestWithURL:url];

    [request onSuccess:^(NSData *data) {
        // request complete
    }];

    [request loadRequest];
