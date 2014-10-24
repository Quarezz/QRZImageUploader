//
//  QRZImageUploader.m
//  ImageUploader
//
//  Created by Ruslan Nikolaev on 22.10.14.
//  Copyright (c) 2014 Ruslan Nikolaev. All rights reserved.
//

#import "QRZImageUploader.h"

@implementation QRZImageUploader

-(id) initWithUrl: (NSURL *) url boundary: (NSString *) boundary
{
    if (self = [super init])
    {
        _url = url;
        _boundary = boundary;
        
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:Nil];
    }
    return self;
}


-(void) uploadWithCompletion: (void (^)(NSData *responseData,NSError *responseError)) completion
{
    mCompletionBlock = completion;
    
    NSMutableURLRequest *request;
    if (!_customRequest)
        request = [[NSMutableURLRequest alloc] initWithURL:_url];
    else
        request = _customRequest;
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",_boundary] forHTTPHeaderField:@"Content-Type"];
    
    // Starting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",_boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Params
    for (int i=0;i<_params.allKeys.count;i++)
    {
        NSString *key = [_params.allKeys objectAtIndex:i];
        NSString *value = [_params[key] stringValue];
        
        if (key && value)
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // Image
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:UIImageJPEGRepresentation(_image,1.0)];
    
    // Ending boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",_boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];

    if (!_customSession)
        _task = [_session dataTaskWithRequest:request];
    else
        _task = [_customSession dataTaskWithRequest:request];
    
    [_task resume];
}

-(void) cancel
{
    [_task cancel];
}

-(void) resume
{
    [_task resume];
}

#pragma mark -
#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    mResponseData = [[NSMutableData alloc] init];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [mResponseData appendData:data];
}

#pragma mark -
#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    // Implement ssl handling
    
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

#pragma mark -
#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
{
    if (_delegate)
    {
        [_delegate uploaderDidSendData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    mCompletionBlock(nil,error);
}

@end
