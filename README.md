# WQQuickSearchFileManager
快速查看文件
<p align="center" >
  <img src="https://raw.githubusercontent.com/AppleDP/WQRefresh/master/WQRefresh/EffectGif/Header0_Footer1.gif" alt="快速查看文件" title="快速查看文件"><br/>
 </p>
# Usage
```objective-c
    self.manager = [[WQQuickSearchFileManager alloc] init];
    self.manager.delegate = self;
    self.rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask,
                                                        YES)[0];
    [self.manager showRootDirectory:self.rootPath];
```
