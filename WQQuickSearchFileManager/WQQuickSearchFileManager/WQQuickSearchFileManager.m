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

- (void)showRootDirectory:(NSString *)rootPath {
    self.rootPath = rootPath;
    UIWindow *window = [UIWindow new];
    self.window = window;
    [self.window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.windowLevel = UIWindowLevelStatusBar;
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
    view.backgroundColor = WQRGB(36, 182, 223, 1);
    view.layer.cornerRadius = 10.f;
    view.layer.masksToBounds = YES;
    
    // back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.enabled = NO;
    [backBtn setTitle:@"返回"
           forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"Back"]
             forState:UIControlStateNormal];
    [backBtn addTarget:self
              action:@selector(backClick:)
    forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 44);
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
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                        44,
                                                                        CGRectGetWidth(vFrame),
                                                                        CGRectGetHeight(vFrame) - 84)
                                                       style:UITableViewStylePlain];
    tableV.allowsMultipleSelection = NO;
    [tableV registerClass:[UITableViewCell class]
   forCellReuseIdentifier:@"WQCell"];
    tableV.delegate = self;
    tableV.dataSource = self;
    [view addSubview:tableV];
    
    // ok button
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.enabled = NO;
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setBackgroundColor:[UIColor whiteColor]];
    [okBtn addTarget:self
              action:@selector(okClick:)
    forControlEvents:UIControlEventTouchUpInside];
    okBtn.frame = CGRectMake(CGRectGetWidth(vFrame)/2.0,
                             CGRectGetHeight(vFrame) - 40,
                             CGRectGetWidth(vFrame)/2.0,
                             40);
    [view addSubview:okBtn];
    
    // cancel button
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitleColor:[UIColor redColor]
                    forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelClick:)
        forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0,
                                 CGRectGetHeight(vFrame) - 40,
                                 CGRectGetWidth(vFrame)/2.0,
                                 40);
    [view addSubview:cancelBtn];
    
    // 全局变量
    self.view = view;
    self.backBtn = backBtn;
    self.freshBtn = freshBtn;
    self.tableV = tableV;
    self.okBtn = okBtn;
    self.cancelBtn = cancelBtn;
    [self.window addSubview:view];
    [UIView animateWithDuration:0.8
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.4
                        options:0
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
                             NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                      NSUserDomainMask,
                                                                                      YES)[0];
                             [self reloadNextDiretory:rootPath];
                         }
                     }];
}

- (void)hide {
    CGRect wFrame = self.window.frame;
    [UIView animateWithDuration:0.3
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
    [self fileDiretoryAcquisition:path];
    [self reloadTbleView:UITableViewRowAnimationRight];
}

- (void)reloadLastDiretory:(NSString *)path {
    [self fileDiretoryAcquisition:path];
    [self reloadTbleView:UITableViewRowAnimationLeft];
}

- (void)reloadRefreshDiretory:(NSString *)path {
    [self fileDiretoryAcquisition:path];
    [self reloadTbleView:UITableViewRowAnimationTop];
}

- (void)reloadTbleView:(UITableViewRowAnimation)animation {
    self.okBtn.enabled = NO;
    self.filePath = nil;
    NSArray *tmp = self.contentsDirectory;
    self.contentsDirectory = nil;
    [self.tableV reloadData];
    self.contentsDirectory = tmp;
    NSMutableArray<NSIndexPath *> *arr = [[NSMutableArray alloc] init];
    for (int index = 0; index < self.contentsDirectory.count; index ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                    inSection:0];
        [arr addObject:indexPath];
    }
    [self.tableV insertRowsAtIndexPaths:arr
                       withRowAnimation:animation];
}

- (void)fileDiretoryAcquisition:(NSString *)path {
    // 设置当前路径
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm changeCurrentDirectoryPath:path];
    
    // 当前路径所有文件以及文件夹
    self.contentsDirectory = [fm contentsOfDirectoryAtPath:path
                                                     error:nil];
}

- (UIImage *)imageWithFileExtension:(NSString *)extension {
    extension = [extension lowercaseString];
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
    BOOL isDir = NO;
    NSString *fileName = self.contentsDirectory[indexPath.row];
    NSString *path = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] fileExistsAtPath:path
                                         isDirectory:&isDir];
    if (isDir) {
        cell.imageView.image = [UIImage imageNamed:@"Finder"];
    }else {
        NSString *extren = [[path pathExtension] lowercaseString];
        cell.imageView.image  = [self imageWithFileExtension:extren];
    }
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











