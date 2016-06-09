//
//  PLWallpaperImageViewController.h
//  idevicewallsapp
//
//  Created by Edward Winget on 6/8/16.
//  Copyright © 2016 junesiphone. All rights reserved.
//

#ifndef PLWallpaperImageViewController_h
#define PLWallpaperImageViewController_h


#endif /* PLWallpaperImageViewController_h */

typedef NS_ENUM(NSUInteger, PLWallpaperMode) {
    PLWallpaperModeBoth,
    PLWallpaperModeHomeScreen,
    PLWallpaperModeLockScreen
};

@interface PLWallpaperImageViewController : UIViewController // PLUIEditImageViewController

- (instancetype)initWithUIImage:(UIImage *)image;
- (void)_savePhoto;
- (void)loadView;
- (void)setupWallpaperPreview;

@property BOOL saveWallpaperData;
@property PLWallpaperMode wallpaperMode;

@end
