QRZMultipartBuilder
================

A little class-helper for image upload on iOS. With it's help you wouldn't have to spend hours trying to format your POST request.

```objc

QRZMultipartBuilder *builder = [[QRZMultipartBuilder alloc] initWithBoundary: @""];
[builder setAttributes: @{   
                            @"file_id": @"123",
                            @"file": [UIImage imageNamed:@"yourImage"];
                        }];
NSData *body = [builder buildHTTPBody];

```
