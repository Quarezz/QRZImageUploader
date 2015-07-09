//
//  QRZMultipartBuilder.m
//  ImageUploader
//
//  Created by Ruslan Nikolaev on 22.10.14.
//  Copyright (c) 2014 Ruslan Nikolaev. All rights reserved.
//

#import "QRZMultipartBuilder.h"

@implementation QRZMultipartBuilder

-(id) initWithBoundary: (NSString *) boundary
{
    if (self = [super init])
    {
        _boundary = boundary;
    }
    return self;
}

-(NSData *) buildHTTPBody
{
    NSMutableData *body = [[NSMutableData alloc] init];
    
    // Starting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",_boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Params
    for (int i=0;i<self.attributes.allKeys.count;i++)
    {
        NSString *key = [self.attributes.allKeys objectAtIndex:i];
        id value = [self.attributes[key] stringValue];
        
        if (key && value)
        {
            if ([value isKindOfClass:[NSString class]])
            {
                // Text
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            if ([value isKindOfClass:[UIImage class]])
            {
                // Image
                [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:UIImageJPEGRepresentation(value,1.0)];
            }
        }
    }

    // Ending boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",_boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

@end
