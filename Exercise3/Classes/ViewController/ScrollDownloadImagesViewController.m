//
//  ViewController.m
//  Exercise3
//
//  Created by Madalina Miron on 12/18/12.
//  Copyright (c) 2012 Madalina Miron. All rights reserved.
//

#import "ScrollDownloadImagesViewController.h"
#import "DownloadImagesNSOperation.h"
#import "DownloadImagesNSURL.h"

@interface ScrollDownloadImagesViewController ()<DownloadeImagesNSURLDelegate , UIScrollViewDelegate , DownloadImagesNSOperationDelegate>
{
    dispatch_queue_t queue;
}

@property (nonatomic, strong)IBOutlet UIScrollView *imagesScrollView;
@property (nonatomic, strong)IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong)IBOutlet UIActivityIndicatorView *ai;
@property (nonatomic, strong)UIImageView *postedImageView;
@property (nonatomic, strong)NSArray *imageURLArray;

@end

@implementation ScrollDownloadImagesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageURLArray = @[@"http://farm1.staticflickr.com/239/521008124_85ec64f28f.jpg",
    @"http://1.bp.blogspot.com/-z4EUTdCvXUE/UDaL3ZthTRI/AAAAAAAAAjY/KWoI7I1o1lY/s1600/yellow+crayon.png" ,
    @"http://www.clker.com/cliparts/h/F/z/P/V/e/crayon-md.png",
    @"https://twimg0-a.akamaihd.net/profile_images/752349976/Carolina-crayon-PNG.png",
    @"http://www.clipartpal.com/_thumbs/pd/education/crayon_orange.png"];
    
    self.imagesScrollView.contentSize = CGSizeMake(self.imagesScrollView.frame.size.width * self.imageURLArray.count, self.imagesScrollView.frame.size.height);
    self.pageControl.numberOfPages = self.imageURLArray.count;
    
    [self downloadUsingDownloadType:self.downloadType];
    
    // alloc & init activity indicator and add it to scrollView
    self.ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imagesScrollView addSubview:self.ai];

}

-(void)downloadUsingDownloadType:(DownloadTypes)type;
{    
    [self.ai startAnimating];// start animating activity indicator
    
    NSMutableArray *imageToDownloadArray = [[NSMutableArray alloc] init];
    NSString *docDirectory = [self applicationDocumentsDirectory];
    NSString *imagesPath = [docDirectory stringByAppendingPathComponent:@"Images"];
    for (NSString* string in self.imageURLArray) {
        
        NSString *imageName = [string lastPathComponent];//get last path from string
        
        NSString *imagePath = [imagesPath stringByAppendingPathComponent:imageName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagesPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            [imageToDownloadArray addObject:string]; //added url to download
        }
        else
        {
            [self setImage:[UIImage imageWithContentsOfFile:imagePath] fromPath:string];
        }
    }
    
    if (![imageToDownloadArray count]) {
        return;
    }
    
    switch (type) {
        case DownloadTypeNSURLConnection:
        {
            [self downloadImagesWithNSURLConnection:imageToDownloadArray];
        }
            break;
        case DownloadTypeGCD:
        {
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            [self downloadImagesWithGCD:imageToDownloadArray];
        }
            break;
        case DownloadTypeNSOperationQueue:
        {
            [self downloadImagesWithNSOperationQueue:imageToDownloadArray];
        }
            break;
        case DownloadTypeNSThread:
        {
            [self downloadImagesWithNSThread:imageToDownloadArray];
        }
            break;
        default:
            break;
    }
}

#pragma mark - NSURLConnection

-(void)downloadImagesWithNSURLConnection:(NSArray*)imageArray
{  
    for (NSString* string in imageArray) {
        DownloadImagesNSURL *downloadImageObj = [[DownloadImagesNSURL alloc] initWithUrl:string];
        [downloadImageObj setDelegate:self]; //set delegate
        
        // Start downloading the image with self as delegate receiver
        [downloadImageObj downloadImage];
    }
}

-(void)finishedDownloadingImage:(UIImage*)image fromPath:(NSString *)urlToImage
{
    NSString *imageSavePath = [[self imagesFolder] stringByAppendingPathComponent:[urlToImage lastPathComponent]];
    [self saveImage:image atPath:imageSavePath];
    
    [self setImage:image fromPath:urlToImage];
}

#pragma mark - GCD

-(void)downloadImagesWithGCD:(NSArray*)imageArray
{
    for (NSString* string in imageArray) {
        dispatch_async(queue, ^{
            NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
            UIImage* image = [UIImage imageWithData:imageData];
            
            //save image
            NSString *imageSavePath = [[self imagesFolder] stringByAppendingPathComponent:[string lastPathComponent]];
            [self saveImage:image atPath:imageSavePath];
            
            [self.ai stopAnimating];
            self.ai.hidesWhenStopped = YES;
            //show image
            [self setImage:image fromPath:string];
        });
    }
}
#pragma mark - NSOperationQueue

-(void)downloadImagesWithNSOperationQueue:(NSArray*)imageArray
{
    NSOperationQueue *opQueue = [[NSOperationQueue alloc]init];
    for (NSString* string in imageArray)
    {
        DownloadImagesNSOperation *downloadImageOp = [[DownloadImagesNSOperation alloc] initWithString:string];
        [downloadImageOp setDelegate:self];
        [opQueue addOperation:downloadImageOp];
    }
}

-(void)finishedDownloadingImageWithNSOperation:(UIImage*)image fromPath:(NSString *)urlToImage
{
    NSString *imageSavePath = [[self imagesFolder] stringByAppendingPathComponent:[urlToImage lastPathComponent]];
    [self saveImage:image atPath:imageSavePath];
    
    [self setImage:image fromPath:urlToImage];
}

#pragma mark - NSThread

-(void)downloadImagesWithNSThread:(NSArray*)imageArray
{
    for (NSString* string in imageArray) {
        [NSThread detachNewThreadSelector:@selector(downloadImageFromURL:) toTarget:self withObject:string];
    }
}

-(void)downloadImageFromURL:(NSString*)string
{
    @autoreleasepool {
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
        UIImage* image = [UIImage imageWithData:imageData];
        
        NSString *imageSavePath = [[self imagesFolder] stringByAppendingPathComponent:[string lastPathComponent]];
        [self saveImage:image atPath:imageSavePath];
        
        [self setImage:image fromPath:string];
    }
}

#pragma mark - Common Methods

-(void)setImage:(UIImage*)image fromPath:(NSString *)urlToImage
{
    // stop animating activity indicator after download is done and hide it
    [self.ai stopAnimating];
    self.ai.hidesWhenStopped = YES;
    
    for (NSString* string in self.imageURLArray) {
        if (urlToImage == string)
        {
            NSUInteger integer = [self.imageURLArray indexOfObject:string];
            CGFloat xOrigin = (integer++) * 320;
            self.postedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,0,320,370)];
        }
    }
    [self.postedImageView setImage:image];
    [self.imagesScrollView addSubview:self.postedImageView];
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.imagesScrollView.frame.size.width;
    int page = floor((self.imagesScrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
    self.pageControl.currentPage = page;
}

#pragma mark - IBAction page control

-(IBAction)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.imagesScrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.imagesScrollView.frame.size;
    [self.imagesScrollView scrollRectToVisible:frame animated:YES];    
}

#pragma mark - File system methods

-(NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(NSString *)imagesFolder
{
    NSString *docDirectory = [self applicationDocumentsDirectory];
    NSString *imagesPath = [docDirectory stringByAppendingPathComponent:@"Images"];
    return imagesPath;
}

-(void)saveImage:(UIImage*)image atPath:(NSString*)path
{
    NSData *myImageData = nil;
    if ([[path pathExtension] isEqualToString:@"png"]) {
        myImageData = UIImagePNGRepresentation(image);
        
    } else if ([[path pathExtension] isEqualToString:@"jpg"]) {
        myImageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    if (myImageData) {
        BOOL written = [myImageData writeToFile:path atomically:YES];
        if (written) {
            NSLog(@"wrote file");
        } else {
            NSLog(@"did not write file");
        }
    }
}

@end
