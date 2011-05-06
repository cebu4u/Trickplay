//
//  ImageEditorViewController.m
//  TrickplayController
//
//  Created by Rex Fenley on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageEditorViewController.h"


@implementation ImageEditorViewController

@synthesize imageToEdit;
@synthesize targetWidth;
@synthesize targetHeight;
@synthesize mask;
@synthesize toolbar;
@synthesize label;
@synthesize imageEditorDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Image Editing

- (void)editImage:(UIImage *)image {
    if (!image) {
        image = imageToEdit;
    }

    imageView = [[GestureImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - toolbar.frame.size.height);
    [self.view addSubview:imageView];
    if (mask) {
        [self.view addSubview:mask];
    }
    [toolbar.superview bringSubviewToFront:toolbar];
    [label.superview bringSubviewToFront:label];
}

- (UIImage*)imageByCropping:(GestureImageView *)imageViewToCrop toRect:(CGRect)rect {
    UIImage *imageToCrop = imageViewToCrop.image;
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, rect.size.width/2, rect.size.height/2);
    CGContextRotateCTM(context, imageViewToCrop.totalRotation);
    CGContextScaleCTM(context, imageViewToCrop.totalScale, imageViewToCrop.totalScale);
    //CGContextConcatCTM(context, imageToCrop.transform);
    CGContextTranslateCTM(context, -rect.size.width/2, -rect.size.height/2);
    CGContextTranslateCTM(context, imageViewToCrop.xTranslation * rect.size.width/imageViewToCrop.frame.size.width, imageViewToCrop.yTranslation * rect.size.height/imageViewToCrop.frame.size.height);
    
    [imageToCrop drawInRect:rect];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retImage;
}

- (IBAction)doneEditing {
    UIImage *croppedImage = [self imageByCropping:imageView toRect:CGRectMake(0.0, 0.0, (targetWidth > 0.0 ? targetWidth : imageView.image.size.width), (targetHeight > 0.0 ? targetHeight : imageView.image.size.height))];
    [imageEditorDelegate doneEditing:croppedImage];
}

- (IBAction)cancelEditing {
    [imageEditorDelegate cancelEditing];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [self editImage:imageToEdit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (toolbar) {
        [toolbar release];
        toolbar = nil;
    }
    if (label) {
        [label release];
        label = nil;
    }
    self.mask = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    if (toolbar) {
        [toolbar release];
        toolbar = nil;
    }
    if (label) {
        [label release];
        label = nil;
    }
    self.mask = nil;
    if (imageToEdit) {
        [imageToEdit release];
    }
    if (imageView) {
        [imageView release];
    }
    
    [super dealloc];
}

@end