//
//  YCPlaceHolderView.h
//  MytShell
//
//  Created by admin on 2019/5/17.
//  Copyright © 2019 SportShell. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YCPlaceHolderViewBlock)(void);

@interface YCPlaceHolderView : UIView
@property (nonatomic, copy) YCPlaceHolderViewBlock block;
+ (instancetype)  createYCPlaceHolderViewWithFrame:(CGRect) frame;
@end

NS_ASSUME_NONNULL_END
