//
//  NSObject+WQQuickSearchFileManager.h
//  WQQuickSearchFileManager
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 jolimark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQQuickSearchFileManagerDelegate <NSObject>
- (void)selectedFilePath:(NSString *)path;
@end

@interface WQQuickSearchFileManager : NSObject
@property (nonatomic, weak) id<WQQuickSearchFileManagerDelegate> delegate;
- (void)showRootDirectory:(NSString *)rootPath;
@end
