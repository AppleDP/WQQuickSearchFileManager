//
//  ViewController.m
//  WQQuickSearchFileManager
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 jolimark. All rights reserved.
//

#import "ViewController.h"
#import "WQQuickSearchFileManager.h"

@interface ViewController ()
<
    WQQuickSearchFileManagerDelegate
>
@property (nonatomic, strong) WQQuickSearchFileManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (nonatomic, copy) NSString *rootPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[WQQuickSearchFileManager alloc] init];
    self.manager.delegate = self;
    self.manager.titleColor = [UIColor whiteColor];
    NSLog(@"%@",NSHomeDirectory());
}

- (void)createWindow {
}

- (void)removeWindow {
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openDcument:(UIButton *)sender {
    self.rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask,
                                                        YES)[0];
    self.lab.text = [NSString stringWithFormat:@"Root: %@",self.rootPath];
    [self.manager showRootDirectory:self.rootPath];
}

- (IBAction)openCaches:(UIButton *)sender {
    self.rootPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                        NSUserDomainMask,
                                                        YES)[0];
    self.lab.text = [NSString stringWithFormat:@"Root: %@",self.rootPath];
    [self.manager showRootDirectory:self.rootPath];
}

- (void)selectedFilePath:(NSString *)path {
    NSLog(@"path: %@",path);
    self.lab.text = [NSString stringWithFormat:@"File path: %@",path];
}
@end








