//
//  ViewController.h
//  Exercise3
//
//  Created by Madalina Miron on 12/18/12.
//  Copyright (c) 2012 Madalina Miron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum DownloadTypes {
    DownloadTypeNSURLConnection = 0,
    DownloadTypeGCD,
    DownloadTypeNSOperationQueue,
    DownloadTypeNSThread,
    DownloadTypeLastType
} DownloadTypes;

@interface ScrollDownloadImagesViewController : UIViewController

@property (nonatomic, assign)DownloadTypes downloadType;

@end
