//
//  NSObject+WQQuickSearchFileManager.m
//  WQQuickSearchFileManager
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 jolimark. All rights reserved.
//

#import "WQQuickSearchFileManager.h"

#define WQRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface WQQuickSearchFileManager ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) NSArray<NSString *> *contentsDirectory;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *freshBtn;
@property (nonatomic, weak) UIButton *okBtn;
@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UITableView *tableV;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *rootPath;
@end

@implementation WQQuickSearchFileManager
- (void)setContentsDirectory:(NSArray<NSString *> *)contentsDirectory {
    if (_contentsDirectory == nil) {
        _contentsDirectory = [[NSArray alloc] init];
    }
    _contentsDirectory = contentsDirectory;
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    self.view.backgroundColor = themeColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLab.textColor = titleColor;
}

- (void)showRootDirectory:(NSString *)rootPath {
    self.rootPath = rootPath;
    UIWindow *window = [UIWindow new];
    self.window = window;
    [self.window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.windowLevel = UIWindowLevelStatusBar - 1;
    self.window.backgroundColor = [UIColor colorWithRed:0
                                                  green:0
                                                   blue:0
                                                  alpha:0];
    // view frame
    CGRect wFrame = self.window.frame;
    CGRect initFrame = CGRectMake(CGRectGetWidth(wFrame)*1/10,
                                  CGRectGetHeight(wFrame),
                                  CGRectGetWidth(wFrame)*4/5,
                                  CGRectGetHeight(wFrame)*4/5);
    CGRect vFrame = CGRectMake(CGRectGetWidth(wFrame)*1/10,
                               CGRectGetHeight(wFrame)*1/10,
                               CGRectGetWidth(wFrame)*4/5,
                               CGRectGetHeight(wFrame)*4/5);
    // view
    UIView *view = [[UIView alloc] initWithFrame:initFrame];
    view.backgroundColor = self.themeColor ? self.themeColor : WQRGB(36, 182, 223, 1);
    view.layer.cornerRadius = 10.f;
    view.layer.masksToBounds = YES;
    
    // title label
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                  0,
                                                                  CGRectGetWidth(vFrame) - 120,
                                                                  44)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = NSLocalizedStringFromTable(@"File Manager", @"WQLocalized", nil);
    titleLab.textColor = self.titleColor ? self.titleColor : WQRGB(0, 0, 0, 1);
    [view addSubview:titleLab];
    
    // back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.enabled = NO;
    [backBtn setTitle:NSLocalizedStringFromTable(@"Back", @"WQLocalized", nil)
           forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"Back"]
             forState:UIControlStateNormal];
    [backBtn addTarget:self
              action:@selector(backClick:)
    forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(5, 0, 50, 44);
    [view addSubview:backBtn];
    
    // fresh button
    UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    freshBtn.enabled = NO;
    [freshBtn setImage:[UIImage imageNamed:@"Refresh"]
              forState:UIControlStateNormal];
    [freshBtn addTarget:self
              action:@selector(freshClick:)
    forControlEvents:UIControlEventTouchUpInside];
    freshBtn.frame = CGRectMake(CGRectGetWidth(vFrame) - 50,
                             0,
                             50,
                             44);
    [view addSubview:freshBtn];
    
    // table view
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(-1,
                                                                        44,
                                                                        CGRectGetWidth(vFrame) + 2,
                                                                        CGRectGetHeight(vFrame) - 83)
                                                       style:UITableViewStylePlain];
    tableV.layer.borderWidth = 1;
    tableV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableV.allowsMultipleSelection = NO;
    [tableV registerClass:[UITableViewCell class]
   forCellReuseIdentifier:@"WQCell"];
    tableV.delegate = self;
    tableV.dataSource = self;
    [view addSubview:tableV];
    
    // ok button
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.enabled = NO;
    [okBtn setTitle:NSLocalizedStringFromTable(@"Ok", @"WQLocalized", nil)
           forState:UIControlStateNormal];
    [okBtn setBackgroundColor:[UIColor whiteColor]];
    [okBtn addTarget:self
              action:@selector(okClick:)
    forControlEvents:UIControlEventTouchUpInside];
    okBtn.frame = CGRectMake(CGRectGetWidth(vFrame)/2.0,
                             CGRectGetHeight(vFrame) - 40,
                             CGRectGetWidth(vFrame)/2.0 + 1,
                             41);
    [view addSubview:okBtn];
    
    // cancel button
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitleColor:[UIColor redColor]
                    forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"WQLocalized", nil)
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelClick:)
        forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(-1,
                                 CGRectGetHeight(vFrame) - 40,
                                 CGRectGetWidth(vFrame)/2.0 + 2,
                                 41);
    [view addSubview:cancelBtn];
    
    // 全局变量
    self.view = view;
    self.titleLab = titleLab;
    self.backBtn = backBtn;
    self.freshBtn = freshBtn;
    self.tableV = tableV;
    self.okBtn = okBtn;
    self.cancelBtn = cancelBtn;
    [self.window addSubview:view];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.frame = vFrame;
                         self.window.backgroundColor = [UIColor colorWithRed:0
                                                                       green:0
                                                                        blue:0
                                                                       alpha:0.5];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.freshBtn.enabled = YES;
                             [self reloadNextDiretory:self.rootPath];
                         }
                     }];
}

- (void)hide {
    CGRect wFrame = self.window.frame;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.window.backgroundColor = [UIColor colorWithRed:0
                                                                       green:0
                                                                        blue:0
                                                                       alpha:0.0];
                         self.view.frame = CGRectMake(CGRectGetWidth(wFrame)*1/10,
                                                        CGRectGetHeight(wFrame),
                                                        CGRectGetWidth(wFrame)*4/5,
                                                        CGRectGetHeight(wFrame)*4/5);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.contentsDirectory = nil;
                             [self.tableV reloadData];
                             [self.view removeFromSuperview];
                             [self.window resignKeyWindow];
                             [self.window setHidden:YES];
                             self.window = nil;
                         }
                     }];
}

- (void)reloadNextDiretory:(NSString *)path {
    [self deleteTableViewCell:UITableViewRowAnimationLeft];
    [self fileDiretoryAcquisition:path];
    [self reloadTbleView:UITableViewRowAnimationRight];
}

- (void)reloadLastDiretory:(NSString *)path {
    [self deleteTableViewCell:UITableViewRowAnimationRight];
    [self fileDiretoryAcquisition:path];
    [self reloadTbleView:UITableViewRowAnimationLeft];
}

- (void)reloadRefreshDiretory:(NSString *)path {
    [self deleteTableViewCell:UITableViewRowAnimationTop];
    [self fileDiretoryAcquisition:path];
    [self reloadTbleView:UITableViewRowAnimationTop];
}

- (void)reloadTbleView:(UITableViewRowAnimation)animation {
    self.okBtn.enabled = NO;
    self.filePath = nil;
    NSMutableArray<NSIndexPath *> *arr = [[NSMutableArray alloc] init];
    for (int index = 0; index < self.contentsDirectory.count; index ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                    inSection:0];
        [arr addObject:indexPath];
    }
    [self.tableV beginUpdates];
    [self.tableV insertRowsAtIndexPaths:arr
                       withRowAnimation:animation];
    [self.tableV endUpdates];
}

- (void)deleteTableViewCell:(UITableViewRowAnimation)animation {
    NSMutableArray<NSIndexPath *> *arr = [[NSMutableArray alloc] init];
    for (int index = 0; index < self.contentsDirectory.count; index ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                    inSection:0];
        [arr addObject:indexPath];
    }
    [self.tableV beginUpdates];
    [self.tableV deleteRowsAtIndexPaths:arr
                       withRowAnimation:animation];
    self.contentsDirectory = nil;
    [self.tableV endUpdates];
}

- (void)fileDiretoryAcquisition:(NSString *)path {
    // 设置当前路径
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm changeCurrentDirectoryPath:path];
    
    // 当前路径所有文件以及文件夹
    self.contentsDirectory = [fm contentsOfDirectoryAtPath:path
                                                     error:nil];
}

- (UIImage *)imageWithFilePath:(NSString *)path {
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path
                                         isDirectory:&isDir];
    if (isDir) {
        return [UIImage imageNamed:@"Finder"];
    }else {
        NSString *extension = [[path pathExtension] lowercaseString];
        UIImage *image = nil;
        NSString *typePlist = [[NSBundle mainBundle] pathForResource:@"WQImageForExtension"
                                                              ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:typePlist];
        NSArray<NSString *> *exts = [dic allKeys];
        if ([exts containsObject:extension]) {
            NSString *imageName = dic[extension];
            image = [UIImage imageNamed:imageName];
        }else {
            image = [UIImage imageNamed:@"File"];
        }
        return image;
    }
}

- (void)backClick:(UIButton *)sender {
    NSString *currentPath = [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *lastPath = [currentPath stringByDeletingLastPathComponent];
    if ([lastPath isEqualToString:self.rootPath]) {
        sender.enabled = NO;
    }
    [self reloadLastDiretory:lastPath];
}

- (void)cancelClick:(UIButton *)sender {
    [self hide];
}

- (void)okClick:(UIButton *)sender {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(selectedFilePath:)]) {
        if (self.filePath) {
            [self.delegate selectedFilePath:self.filePath];
        }
    }
}

- (void)freshClick:(UIButton *)sender {
    NSString *currenPath = [[NSFileManager defaultManager] currentDirectoryPath];
    [self reloadRefreshDiretory:currenPath];
}


#pragma mark -- Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.contentsDirectory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WQCell"
                                                            forIndexPath:indexPath];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSString *fileName = self.contentsDirectory[indexPath.row];
    NSString *path = [[[NSFileManager defaultManager] currentDirectoryPath]
                      stringByAppendingPathComponent:fileName];
    cell.imageView.image = [self imageWithFilePath:path];
    cell.textLabel.text = fileName;
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.okBtn.enabled = YES;
    NSString *fileName = self.contentsDirectory[indexPath.row];
    NSString *currentPath = [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *filePath = [currentPath stringByAppendingPathComponent:fileName];
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath
                                         isDirectory:&isDir];
    if (isDir) {
        // 是文件夹
        [self reloadNextDiretory:filePath];
        self.backBtn.enabled = YES;
    }else {
        // 不是文件夹
        self.filePath = filePath;
    }
}
@end











