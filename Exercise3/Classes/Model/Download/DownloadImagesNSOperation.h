//
//  DownloadImagesNSOperation.h
//  Exercise3
//
//  Created by Madalina Miron on 1/21/13.
//  Copyright (c) 2013 Madalina Miron. All rights reserved.
//
@protocol DownloadImagesNSOperationDelegate   //define delegate protocol
@required
-(void)finishedDownloadingImageWithNSOperation:(UIImage*)img fromPath:(NSString *)urlToImage; // function to be implemented in another class
@end

#import <Foundation/Foundation.h>

@interface DownloadImagesNSOperation : NSOperation

@property (nonatomic, strong)id<DownloadImagesNSOperationDelegate>delegate;

-(id)initWithString:(NSString*)string;

@end
