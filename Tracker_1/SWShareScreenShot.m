//
//  SWShareScreenShot.m
//  ScreenShot
//
//  Created by Anastasiia Staiko on 4/12/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "SWShareScreenShot.h"

@implementation SWShareScreenShot

@synthesize images = _images;

+ (SWShareScreenShot*)shareManager{
    /*
     GCD for ARC
     */
    static SWShareScreenShot *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}


- (UIImage*)screenshot
{
    // Create a graphics context with the target size
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
//    else
//        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // renderInContext: renders in the coordinate space of the layer
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)keepImageByCurrentViewController:(UIViewController*)viewController withName:(NSString*)name{
    
    if (self.images == nil) {
        _images = [NSMutableDictionary dictionary];
    }
    
    [_images setObject:[self screenshot] forKey:name];
    
}

- (void)removeImagesByName:(NSString *)name{
    if (self.images) {
        [self.images removeObjectForKey:name];
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    
    if (viewController) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
