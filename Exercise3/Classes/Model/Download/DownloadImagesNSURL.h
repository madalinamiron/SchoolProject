//
//  DownloadImages.h
//  Exercise3
//
//  Created by Madalina Miron on 12/19/12.
//  Copyright (c) 2012 Madalina Miron. All rights reserved.
//

@protocol DownloadeImagesNSURLDelegate   //define delegate protocol
@required
-(void)finishedDownloadingImage:(UIImage*)img fromPath:(NSString *)urlToImage; // function to be implemented in another class
@end

#import <Foundation/Foundation.h>

@interface DownloadImagesNSURL : NSObject

@property (nonatomic, strong)id<DownloadeImagesNSURLDelegate>delegate;

-(void)downloadImage;
-(id)initWithUrl:(NSString*)urlToImage;

@end
