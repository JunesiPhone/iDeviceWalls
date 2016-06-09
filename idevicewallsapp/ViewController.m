//
//  ViewController.m
//  iDeviceWalls
//
//  Created by Edward Winget on 10/4/15.
//  Copyright (c) 2015 JunesiPhone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
            completionHandler(UIBackgroundFetchResultNewData);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //fade out image that fixes white flash
    loadingImageView.alpha = 1.0f;
    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        loadingImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [loadingImageView removeFromSuperview];
        });
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    theBool = true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    myProgressView.hidden = false;
    myProgressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.05;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}

BOOL blurred;
BOOL wViewController;
@synthesize loadingImageView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //style saveButton
    saveButton.layer.cornerRadius = 3.0f;
    saveButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    saveButton.hidden = YES;
    
    setButton.layer.cornerRadius = 3.0f;
    setButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    setButton.hidden = YES;
    
    backButton.layer.cornerRadius = 3.0f;
    backButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    backButton.hidden = YES;
    
    //set webview url
    NSURL *url = [NSURL URLWithString:@"http://idevicewalls.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [webView setDelegate: self];
    
    //stop white flash by loading image
    UIImage *loadingImage = [UIImage imageNamed:@"webview.png"];
    loadingImageView = [[UIImageView alloc] initWithImage:loadingImage];
    loadingImageView.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"webview.png"],
                                        nil];
    [self.view addSubview:loadingImageView];
    
    //pull down to refresh webview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webView.scrollView addSubview:refreshControl];
    
    //add swipe gesture to webview
    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture)];
    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionRight;
    swipeRightGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRightGesture];
}

- (void)handleSwipeGesture {
    
    //move webview back a page
    [webView goBack];
    
    //make sure save items are hidden
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        blurImage.hidden = YES;
        previewImage.hidden = YES;
    });
    
    //set offset for animation
    CGRect offset = webView.frame;
    offset.origin.x = -320;
    webView.frame = offset;
    
    //end of animation
    CGRect frame = webView.frame;
    frame.origin.x = 0;
    webView.hidden = NO;
    
    //animate it
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.25];
    webView.frame = frame;
    [UIView commitAnimations];
}


-(void)handleRefresh:(UIRefreshControl *)refresh {
    
    // Reload website
    NSString *fullURL = @"http://idevicewalls.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    [refresh endRefreshing];
}


- (BOOL)webView:(UIWebView *)changewebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    webView.hidden = YES;
    
    //make sure webview is showing
    CGRect frame = webView.frame;
    frame.origin.x = 0;
    webView.hidden = NO;
    
    //enable interaction
    [webView setUserInteractionEnabled:YES];
    
    //get url
    NSURL *url = [request URL];
    NSString *URLString = [url absoluteString];
    NSString *extension = [url pathExtension];
    
    //image types
    NSArray *imageExtensions = @[@"png", @"jpg", @"gif",@"PNG"];
    
    //if url has image extention do stuff
    if ([imageExtensions containsObject:extension]) {
        
        //if image hide webview
        webView.hidden = YES;
        CGRect webFrame = webView.frame;
        webFrame.origin.x = -800;
        
        //get image data
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: URLString]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData: data];
                previewImage.image = image;
                blurImage.image = image;
                blurImage.hidden = NO;
                previewImage.hidden = NO;
                saveButton.hidden = NO;
                setButton.hidden = NO;
                backButton.hidden = NO;
            });
            
        });
        
        //disable interaction so we can track swipe
        [previewImage setUserInteractionEnabled:NO];
        [blurImage setUserInteractionEnabled:NO];
        [webView setUserInteractionEnabled:NO];
        
        
        //center image
        previewImage.center = self.view.center;
        
        //add blur effect if not applied
        if(!blurred){
            blurred = YES;
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.frame = webView.bounds;
            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [blurImage addSubview:blurEffectView];
        }
    }else{
        saveButton.hidden = YES;
        setButton.hidden = YES;
        backButton.hidden = YES;
    }
    return YES;
}

-(IBAction)setWall:(id)sender {
    
    blurred = false;
    NSString *currentURL = webView.request.URL.absoluteString;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:currentURL forKey:@"url"];

    PLViewController *NVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PLViewController"];
    [self presentViewController:NVC animated:YES completion:nil];
}

//save to camera roll, display popup
-(IBAction)saveWall:(id)sender {
    NSString *currentURL = webView.request.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:currentURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iDeviceWalls"
                                                    message:@"Wallpaper saved to your camera roll."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

//page back from image preview
-(IBAction)goBack:(id)sender{
    [self handleSwipeGesture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
