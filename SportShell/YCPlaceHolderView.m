//
//  YCPlaceHolderView.m
//  MytShell
//
//  Created by admin on 2019/5/17.
//  Copyright © 2019 SportShell. All rights reserved.
//

#import "YCPlaceHolderView.h"

@implementation YCPlaceHolderView

+ (id)   loadViewForXibWithName:(NSString*) xibName
{
    
    
    if (xibName.length==0) {
        
        xibName = [NSString stringWithUTF8String:object_getClassName(self)];
    }
    
    id view = [[[NSBundle mainBundle]  loadNibNamed:xibName owner:nil options:nil]  firstObject];
    
    return view;
}

+ (instancetype)  createYCPlaceHolderViewWithFrame:(CGRect) frame
{
    
    YCPlaceHolderView*  view =  [self  loadViewForXibWithName:nil];
    
    
    view.frame = frame;
    
    
    
    return view;
}

- (IBAction)reload:(id)sender {
    if (_block) {
        _block();
    }
}

@end
