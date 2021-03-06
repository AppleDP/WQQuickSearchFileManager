//
//  NSObject+WQQuickSearchFileManager.h
//  WQQuickSearchFileManager
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 jolimark. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef WQSearchFileCtrl
#undef WQSearchFileCtrl
#endif
#define WQSearchFileCtrl [WQQuickSearchFileManager shareInstance]

@protocol WQQuickSearchFileManagerDelegate <NSObject>
- (void)selectedFilePath:(NSString *)path;
@end

@interface WQQuickSearchFileManager : NSObject
@property (nonatomic, weak) id<WQQuickSearchFileManagerDelegate> delegate;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIColor *titleColor;

+ (instancetype)shareInstance;

- (void)showRootDirectory:(NSString *)rootPath;
@end
