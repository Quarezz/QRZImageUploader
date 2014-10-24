//
//  QRZImageUploader.h
//  ImageUploader
//
//  Created by Ruslan Nikolaev on 22.10.14.
//  Copyright (c) 2014 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol QRZImageUploaderProgressDelegate

-(void) uploaderDidSendData: (int64_t) bytesSent totalBytesSent:(int64_t)totalBytesSent
   totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

@end
typedef void (^Completion)(NSData *responseData,NSError *responseError);

@interface QRZImageUploader : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
{
    Completion mCompletionBlock;
    NSMutableData *mResponseData;
}

@property (nonatomic, strong) id<QRZImageUploaderProgressDelegate> delegate;

@property (nonatomic, strong, readonly) NSURLSession *session;
@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;

// Use this to adjust session and request configuration
@property (nonatomic, strong) NSURLSession *customSession;
@property (nonatomic, strong) NSMutableURLRequest *customRequest;

@property (nonatomic, strong, readonly) NSString *boundary;
@property (nonatomic, strong, readonly) NSURL *url;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDictionary *params;

-(id) initWithUrl: (NSURL *) url boundary: (NSString *) boundary;

-(void) uploadWithCompletion: (void (^)(NSData *responseData,NSError *responseError)) completion;
-(void) cancel;
-(void) resume;


@end
