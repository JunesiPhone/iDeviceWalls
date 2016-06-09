//
//  PLViewController.m
//  idevicewallsapp
//
//  Created by Edward Winget on 6/8/16.
//  Copyright © 2016 junesiphone. All rights reserved.
//
#import "ViewController.h"
#import "PLViewController.h"

@interface PLViewController ()

@end

@implementation PLViewController


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [prefs valueForKey:@"url"];
    
    NSString *currentURL = urlString;
    NSURL *url = [NSURL URLWithString:currentURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    self = [self initWithUIImage:img];
    self.saveWallpaperData = YES;
    
    return self;
}



- (void)viewDidLoad {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        ViewController *NVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        [self presentViewController:NVC animated:YES completion:nil];
    });
}
@end