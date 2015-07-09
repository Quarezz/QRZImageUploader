//
//  QRZMultipartBuilder.h
//  ImageUploader
//
//  Created by Ruslan Nikolaev on 22.10.14.
//  Copyright (c) 2014 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRZMultipartBuilder : NSObject

@property (nonatomic, strong, readonly) NSString *boundary;

@property (nonatomic, strong) NSDictionary *attributes;

-(id) initWithBoundary: (NSString *) boundary;

-(NSData *) buildHTTPBody;

@end
