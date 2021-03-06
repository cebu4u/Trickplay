//
//  AsyncImageView.m
//  TrickplayController_v2
//
//  Created by Rex Fenley on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"


@implementation AsyncImageView

@synthesize dataCacheDelegate;
@synthesize otherDelegate;
@synthesize resourceKey;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize centerToSuperview;
@synthesize image;
@synthesize loaded;

- (void)setup {
    [self setBackgroundColor:[UIColor clearColor]];
    tileWidth = NO;
    tileHeight = NO;
    loaded = NO;
    self.image = nil;
}

- (id)init {
    if ((self = [super init])) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark Networking

- (void)loadImageFromURL:(NSURL *)url resourceKey:(id)key {
    if (connection) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data) {
        [data release];
        data = nil;
    }
    self.resourceKey = key;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connection) {
        NSLog(@"Connection to URL %@ could not be established", url);
        // make a broken link symbol in image
        [self on_loadedFailed:YES];
        return;
    }
    
    [self animateSpinner];
}

- (void)on_loadedFailed:(BOOL)failed {
    if (dataCacheDelegate) {
        [dataCacheDelegate dataReceived:nil resourcekey:resourceKey];
    }
    if (otherDelegate) {
        [otherDelegate on_loadedFailed:failed];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData {
    if (!data) {
        data = [[NSMutableData alloc] initWithCapacity:10000];
    }
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
    fprintf(stderr, "Connection did finish loading %s\n", [resourceKey UTF8String]);
    [connection cancel];
    [connection release];
    connection = nil;

    [self loadImageFromData:data];
    
    [data release];
    data = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
    NSLog(@"Image did fail with error: %@", error);
    [self on_loadedFailed:YES];
}

/*
- (UIImageView *)imageView {
    return self;
}
 */

#pragma mark -
#pragma mark ViewControl

- (void)animateSpinner {
    //spinny thing
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:loadingIndicator];
    [loadingIndicator release];
    loadingIndicator.hidesWhenStopped = YES;
    [loadingIndicator startAnimating];
}

- (void)loadImageFromData:(NSData *)theData {
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    self.image = [UIImage imageWithData:theData];
    /*
     UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
     // might need to change this to scale to fill
     imageView.contentMode = UIViewContentModeScaleAspectFit;
     imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
     */
    
    // If the width and/or height of the AsyncImageView was unspecified then
    // set as the natural width and/or height of the Image
    CGFloat width = (self.frame.size.width == 0.0) ? image.size.width : self.frame.size.width;
    CGFloat height = (self.frame.size.height == 0.0) ? image.size.height : self.frame.size.height;
    if (self.frame.size.width == 0.0 || self.frame.size.height == 0.0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    // send data to the delegate if it exists for caching
    if (dataCacheDelegate) {
        [dataCacheDelegate dataReceived:theData resourcekey:resourceKey];
    }
    if (otherDelegate) {
        [otherDelegate dataReceived:theData resourcekey:resourceKey];
        if (theData) {
            [otherDelegate on_loadedFailed:NO];
        } else {
            [otherDelegate on_loadedFailed:YES];
        }
    }
    
    [loadingIndicator stopAnimating];
    [loadingIndicator removeFromSuperview];
    
    loaded = YES;
    
    if (centerToSuperview) {
        self.center = CGPointMake(fabs(self.superview.center.x), fabs(self.superview.center.y));
    }
}

#pragma mark -
#pragma mark Graphics

- (void)setTileWidth:(BOOL)toTileWidth height:(BOOL)toTileHeight {
    tileWidth = toTileWidth;
    tileHeight = toTileHeight;
    
    if (tileWidth || tileHeight) {
        self.layer.needsDisplayOnBoundsChange = YES;
    } else {
        self.layer.needsDisplayOnBoundsChange = NO;
    }
    
    [self setNeedsDisplay];
}

//*
- (void)drawRect:(CGRect)rect {
    if (!self.image) {
        return;
    }
    
    if (tileHeight || tileWidth) {
        //Since we are retaining the image, we append with ret_ref.  this reminds us to release at a later date.
        CGImageRef image_ref = CGImageRetain(self.image.CGImage); 
        
        //This sets the tile to the native size of the image.  Change this value to adjust the size of an individual "tile."
        CGRect image_rect;
        if (!tileHeight) {
            image_rect = CGRectMake(0.0, image.size.height, image.size.width, self.bounds.size.height);
        } else if (!tileWidth) {
            image_rect = CGRectMake(0.0, 0.0, self.bounds.size.width, image.size.height);
        } else {
            image_rect = CGRectMake(0.0, 0.0, self.image.size.width, self.image.size.height);
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextClearRect(context, rect);
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawTiledImage(context, image_rect, image_ref);
        
        CGImageRelease(image_ref);
    } else {
        [image drawInRect:rect];
    }
}
//*/

#pragma mark -
#pragma mark Deallocation

- (void)dealloc {
    NSLog(@"AsyncImageView dealloc");
    self.dataCacheDelegate = nil;
    self.otherDelegate = nil;
    
    if (connection) {
        [connection cancel];
        [connection release];
    }
    if (data) {
        [data release];
    }
    if (resourceKey) {
        [resourceKey release];
    }
    
    self.image = nil;
    
    [super dealloc];
}

@end