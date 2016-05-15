//
//  SWShareScreenShot.h
//  ScreenShot
//
//  Created by Anastasiia Staiko on 4/12/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface SWShareScreenShot : NSObject <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {

    @private
    UIViewController *viewController;

}

@property (readonly, nonatomic, strong) NSMutableDictionary *images;

+ (SWShareScreenShot*)shareManager;
- (void)keepImageByCurrentViewController:(UIViewController*)viewController withName:(NSString*)name;
- (void)removeImagesByName:(NSString*)name;

@end
