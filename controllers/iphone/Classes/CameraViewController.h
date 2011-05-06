//
//  CameraViewController.h
//  TrickplayController
//
//  Created by Rex Fenley on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageEditorViewController.h"

@protocol CameraViewControllerDelegate <NSObject>

@required
- (void)finishedPickingImage:(UIImage *)image;
- (void)finishedSendingImage;
- (void)canceledPickingImage;

@end

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageEditorDelegate> {
    
    UIImagePickerController *imagePickerController;
    UIPopoverController *popOverController;
    ImageEditorViewController *imageEditor;
    
    UIImageView *mask;
    CGFloat targetWidth;
    CGFloat targetHeight;
    BOOL editable;
    
    NSInteger port;
    NSString *host;
    NSString *path;
    
    NSMutableArray *connections;
    
    id <CameraViewControllerDelegate> delegate;
}

@property (assign) BOOL editable;

@property (assign) id <CameraViewControllerDelegate> delegate;


- (id)initWithView:(UIView *)aView targetWidth:(CGFloat)width targetHeight:(CGFloat)height editable:(BOOL)is_editable mask:(UIImageView *)aMask;

- (void)setMask:(UIImageView *)mask;

- (void)startCamera;
- (void)openLibrary;

- (void)setupService:(NSInteger)thePort host:(NSString *)theHost path:(NSString *)thePath delegate:theDelegate;

@end
