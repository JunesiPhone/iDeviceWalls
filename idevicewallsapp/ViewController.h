//
//  ViewController.h
//  iDeviceWalls
//
//  Created by Edward Winget on 10/4/15.
//  Copyright (c) 2015 JunesiPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLViewController.h"

@interface ViewController : UIViewController  <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UIImageView *previewImage;
    IBOutlet UIImageView *blurImage;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *setButton;
    IBOutlet UIButton *backButton;
    BOOL theBool;
    IBOutlet UIProgressView* myProgressView;
    NSTimer *myTimer;
    
}

@property(nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, retain) PLViewController *plView;

-(IBAction)saveWall:(id)sender;

-(IBAction)setWall:(id)sender;

-(IBAction)goBack:(id)sender;

@property (nonatomic, copy) void (^completionHandler)(BOOL);

- (void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;


@end

