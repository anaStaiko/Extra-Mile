//
//  PopupView.m
//  popupView
//
//  Created by Anastasiia Staiko on 4/14/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "PopupView.h"
#import "UIViewController+popupViewController.h"
#import "PopupViewAnimationFade.h"

@implementation PopupView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    return self;
}

+ (instancetype)defaultPopupView{
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 300, 450)];
}


- (IBAction)dismissAction:(id)sender {
    
        [_parentVC dismissPopupView];
}



@end
