# 你刚好需要，我刚好出现，请赏一颗小星星.

<p align="center" >
路由处理逻辑
</p>
<img src="https://github.com/wufuzeng/FZRouter/blob/master/Screenshots/FZRouter%E5%A4%84%E7%90%86%E6%9C%BA%E5%88%B6.png" title="" float=left width = '1000px'>
 
# FZRouter
##  特征
- [x]  1.  本地路由路径参照Web URL格式设计。
- [x]  2.  支持本地和web路由。
- [x]  3. 支持路由界面唯一性。
- [x]  4. 支持顶层界面刷新。


[![CI Status](https://img.shields.io/travis/wufuzeng/FZRouter.svg?style=flat)](https://travis-ci.org/wufuzeng/FZRouter)
[![Version](https://img.shields.io/cocoapods/v/FZRouter.svg?style=flat)](https://cocoapods.org/pods/FZRouter)
[![License](https://img.shields.io/cocoapods/l/FZRouter.svg?style=flat)](https://cocoapods.org/pods/FZRouter)
[![Platform](https://img.shields.io/cocoapods/p/FZRouter.svg?style=flat)](https://cocoapods.org/pods/FZRouter)

## 例

要运行示例项目，请克隆repo，然后从Example目录运行 ”pod install“。

## 要求
```objective-c

RouterProfile.plist 

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>path</key><string>[path映射的VC界面类名]</string>
    </dict>
</plist>

```

## 安装

FZRouter 可通过[CocoaPods](https://cocoapods.org)获得. 要安装它，只需将以下行添加到Podfile文件

```ruby
pod 'FZRouter'
```

## 怎样使用

* Objective-C
-  1. info.plist -> URL Types ->URL Schemes ->"local / [自定义]".
-  2. 新建全局路由配置文件“RouterProfile.plist”.
-  3. 配置路由单例。
-  4. 

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    [code]...

    [FZRouter globalRouter].localScheme = @"local";
    [FZRouter globalRouter].unique = true;
    [FZRouter registerRoutesWithProfile:@"RouterProfile"];

    [code]...

}

-(void)skipAction:(UIButton *)sender{

    /**
     * 路由路径规则定义
     * local://host:port/path?Query=&params=
     * local://Domin/VCIdentification?q=funcName&param1=value1&param2=value2&param1=value3
     */

    [FZRouter open:@"local://path?key1=value1&key2=value2"];
}


//Objective-C代码

```

* Swift

```swift

//swif代码

```


## 作者

wufuzeng, wufuzeng_lucky@sina.com
### 纵有疾风起，人生不言弃

## 许可证

FZRouter is available under the MIT license. See the LICENSE file for more info.
