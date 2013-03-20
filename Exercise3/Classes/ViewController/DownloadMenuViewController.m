//
//  DownloadMenuViewController.m
//  Exercise3
//
//  Created by Madalina Miron on 1/21/13.
//  Copyright (c) 2013 Madalina Miron. All rights reserved.
//

#import "DownloadMenuViewController.h"

@interface DownloadMenuViewController ()

@end

@implementation DownloadMenuViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NSURLConnection"]) {
        ScrollDownloadImagesViewController *ctrl = (ScrollDownloadImagesViewController*)[segue destinationViewController];
        [ctrl setDownloadType:DownloadTypeNSURLConnection];
    }
    else if ([[segue identifier] isEqualToString:@"GCD"]){
        ScrollDownloadImagesViewController *ctrl = (ScrollDownloadImagesViewController*)[segue destinationViewController];
        [ctrl setDownloadType:DownloadTypeGCD];
    }
    else if ([[segue identifier] isEqualToString:@"NSOperationQueue"]){
        ScrollDownloadImagesViewController *ctrl = (ScrollDownloadImagesViewController*)[segue destinationViewController];
        [ctrl setDownloadType:DownloadTypeNSOperationQueue];
    }
    else if([[segue identifier] isEqualToString:@"NSThread"]){
        ScrollDownloadImagesViewController *ctrl = (ScrollDownloadImagesViewController*)[segue destinationViewController];
        [ctrl setDownloadType:DownloadTypeNSThread];
    }
}

@end
