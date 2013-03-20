//
//  DownloadImages.m
//  Exercise3
//
//  Created by Madalina Miron on 12/19/12.
//  Copyright (c) 2012 Madalina Miron. All rights reserved.
//

#import "DownloadImagesNSURL.h"

@interface DownloadImagesNSURL ()

@property (nonatomic, strong)NSMutableData *receivedData;
@property (nonatomic, strong)NSString *imageURL;

@end


@implementation DownloadImagesNSURL

-(id)initWithUrl:(NSString*)urlToImage
{
	self = [super init];
	
	if (self) {
		self.imageURL = urlToImage;
	}
	return self;
}

-(void)downloadImage
{
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURL]
                                              cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        NSLog(@"Succeeded! Connection is done");
        self.receivedData = [[NSMutableData alloc]init];
        
    } else {
        NSLog(@"Failed! Connection is not done");
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    UIImage *downloadedImage = [[UIImage alloc] initWithData:self.receivedData];
    
    [self.delegate finishedDownloadingImage:downloadedImage fromPath:self.imageURL];
}


-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSCachedURLResponse *newCachedResponse = cachedResponse;
    
    if ([[[[cachedResponse response] URL] scheme] isEqual:@"https"]) {
        newCachedResponse = nil;
    } else {
        NSDictionary *newUserInfo;
        newUserInfo = [NSDictionary dictionaryWithObject:[NSDate date]
                                                  forKey:@"Cached Date"];
        newCachedResponse = [[NSCachedURLResponse alloc]
                             initWithResponse:[cachedResponse response]
                             data:[cachedResponse data]
                             userInfo:newUserInfo
                             storagePolicy:[cachedResponse storagePolicy]];
    }
    return newCachedResponse;
}

@end
