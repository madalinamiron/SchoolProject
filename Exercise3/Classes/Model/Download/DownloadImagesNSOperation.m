//
//  DownloadImagesNSOperation.m
//  Exercise3
//
//  Created by Madalina Miron on 1/21/13.
//  Copyright (c) 2013 Madalina Miron. All rights reserved.
//

#import "DownloadImagesNSOperation.h"

@interface DownloadImagesNSOperation()
{
    NSString* stringURL;
}
@end

@implementation DownloadImagesNSOperation


-(id)initWithString:(NSString*)string
{
    if (self == [super init]) {
        stringURL = string;
    }
    return self;
}

-(void)main
{
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
    UIImage* image = [UIImage imageWithData:imageData];
    [self.delegate finishedDownloadingImageWithNSOperation:image fromPath:stringURL];
}
@end
