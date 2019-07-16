//
//  FZRouter.m
//  MeiLiBa
//
//  Created by 吴福增 on 2018/12/13.
//  Copyright © 2018 恒颜互联网. All rights reserved.
//

/**
 路由路径规则定义
 local://host:port/path?Query=&params=
 
 local://Domin/VCIdentification?q=funcName&param1=value1&param2=value2&param1=value3
 
 local://www.xxx.com/VCIdentification?q=funcName&param1=value1&param2=value2&param1=value3
 
 @throw [NSException exceptionWithName:@"NavigationControllerNotProvided"
 reason:@"Router#navigationController has not been set to a UINavigationController instance"
 userInfo:nil];
 */

#import "FZRouter.h"

@interface FZRouter ()
 
@end
@implementation FZRouter

/** 全局路由 */
+(instancetype)globalRouter{
    static FZRouter *_globalRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalRouter = [[FZRouter alloc] init];
    });
    return _globalRouter;
}


#pragma mark -- config ---

/** 注册路由 */
+(void)registerRoutesWithProfile:(NSString *)profile{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:profile ofType:@"plist"];
    if (filePath.length) {
        NSDictionary *dic_routes = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (dic_routes) {
            [[FZRouter globalRouter].dic_routes addEntriesFromDictionary:dic_routes];
        }
    } else {
        NSLog(@"<<<<<<<< Error:no found profile：%@.plist >>>>>>>",profile);
        
    }
}
+(void)addRouteWithKey:(NSString *)key vcName:(NSString *)vcName{
    NSMutableDictionary *routes = [FZRouter globalRouter].dic_routes;
    if (routes[key]) {
        NSLog(@"<<<<<<<< Error:%@ route already exists >>>>>>>",key);
    }else{
        routes[key] = vcName;
    }
}
/** 移除路由 */
+(void)removeRouteWithKey:(NSString *)key{
    [[FZRouter globalRouter].dic_routes removeObjectForKey:key];
}
+(void)removeAllRoutes{
    [[FZRouter globalRouter].dic_routes removeAllObjects];
}

+(NSString*)local:(NSString *)key{
    return [NSString stringWithFormat:@"%@://%@",[FZRouter globalRouter].localScheme,key];
}

#pragma mark -- open ---

+(void)openExternal:(NSString *)url {
    NSURL *URL = [NSURL URLWithString:url];
    if ([ [UIApplication sharedApplication] canOpenURL:URL]){
        if (@available(iOS 10.0,*)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }
}

+(void)open:(NSString *)path{
    [FZRouter open:path target:nil];
}

+(void)open:(NSString *)path target:(UIViewController * _Nullable)target{
    [FZRouter open:path target:target callBack:nil];
}

+(void)open:(NSString *)path target:(UIViewController * _Nullable)target callBack:(void(^_Nullable)(NSDictionary * _Nullable userInfo))callBack{
    
    FZRouterEntry* entry = [[FZRouterEntry alloc]initWithUrl:path];
    
    NSLog(@"route:%@",entry.routerUrl);
    
    if ([path containsString:@"http"]) {
        UIViewController *currentViewController = [UIViewController fz_currentViewController];
        if (NSClassFromString(entry.className) == [currentViewController class] &&
            [entry.routerUrl isEqualToString:path]) {
            //刷新
            entry.callbackBlock = callBack;
            UIViewController* html = [FZRouter globalRouter].URLHandler(path,entry);
            SEL refreshSEL = NSSelectorFromString(@"fz_refresh");
            if ([html  respondsToSelector:refreshSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [html  performSelector:refreshSEL withObject:nil];
#pragma clang diagnostic pop
            }else{
                NSLog(@"类[%@]-(void)fz_refresh;方法无法响应",NSStringFromClass([html class]))；
            }
        } else {
            //访问网页
            if ([FZRouter globalRouter].URLHandler) {
                entry.callbackBlock = callBack;
                UIViewController* html = [FZRouter globalRouter].URLHandler(path,entry);
                
                if (target.navigationController) {
                    [target.navigationController pushViewController:html animated:YES];
                } else {
                    if (currentViewController.navigationController) {
                        [currentViewController.navigationController pushViewController:html animated:YES];
                    }else{
                        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:html];
                        [currentViewController presentViewController:navc animated:YES completion:nil];
                    }
                }
            }
        }
        
    } else if ([entry.routerUrl hasPrefix:[FZRouter local:@""]]) {
        
        if (target.navigationController) {
            if (NSClassFromString(entry.className) == [target class]) {
                //REFRESHHandler(target);
                [FZRouter refresh:entry target:target callBack:callBack];
            }else{
                [FZRouter push:entry target:target.navigationController callBack:callBack];
                //PUSHHandler(target.navigationController);
            }
        } else {
            //PRESENTHandler();
            [FZRouter present:entry target:target callBack:callBack];
        }
    } else{
        NSLog(@"Error:\"%@\" cannot be recognized",path);
    }
}

+(void)refresh:(FZRouterEntry* )entry target:(UIViewController * _Nullable)target callBack:(void(^_Nullable)(NSDictionary * _Nullable userInfo))callBack{
    
    //Class obj = NSClassFromString(entry.className);
    [target fz_configPropertiesWithParams:entry.params];
    entry.callbackBlock = callBack;
    target.fz_entry = entry;
    SEL refreshSEL = NSSelectorFromString(@"fz_refresh");
    if ([target  respondsToSelector:refreshSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target  performSelector:refreshSEL withObject:nil];
#pragma clang diagnostic pop
    }
}

+(void)push:(FZRouterEntry* )entry target:(UIViewController * _Nullable)target callBack:(void(^_Nullable)(NSDictionary * _Nullable userInfo))callBack{
    
    Class obj = NSClassFromString(entry.className);
    
    /** append */
    void (^APPENDHandler)(UINavigationController *nc) = ^(UINavigationController *nc){
        UIViewController *vc = [obj new];
        [vc fz_configPropertiesWithParams:entry.params];
        entry.callbackBlock = callBack;
        //To Do: vc 持有 entry
        vc.fz_entry = entry;
        [nc pushViewController:vc animated:YES];
    };
    
    if ([FZRouter globalRouter].isUnique) {
        NSMutableArray *viewControllers = [target.navigationController.viewControllers mutableCopy];
        __block NSInteger index = -1;
        [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull viewController, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([viewController isKindOfClass:obj]) {
                index = idx;
                * stop = YES;
            }
        }];
        if (index == 0) {
            [target.navigationController popToRootViewControllerAnimated:NO];
            [FZRouter refresh:entry target:target callBack:callBack];
        }else if (index > 0) {
            UIViewController *temp = viewControllers[index];
            [temp fz_configPropertiesWithParams:entry.params];
            entry.callbackBlock = callBack;
            temp.fz_entry = entry;
            [viewControllers removeObjectAtIndex:index];
            //[viewControllers addObject:temp];
            [target.navigationController setViewControllers:[viewControllers copy] animated:NO];
            [target.navigationController pushViewController:temp animated:YES];
        }else{
            //ROOTHandler();
            if ([FZRouter root:entry target:target callBack:callBack] == false) {
                APPENDHandler(target.navigationController);
            }
        }
    }else{
        APPENDHandler(target.navigationController);
    }
}


+(void)present:(FZRouterEntry* )entry target:(UIViewController * _Nullable)target callBack:(void(^_Nullable)(NSDictionary * _Nullable userInfo))callBack{
    
    Class obj = NSClassFromString(entry.className);
    
    UIViewController *currentViewController = [UIViewController fz_currentViewController];
    
    if (NSClassFromString(entry.className) == [currentViewController class]) {
        [FZRouter refresh:entry target:currentViewController callBack:callBack];
    }else{
        if (currentViewController.navigationController) {
            [FZRouter push:entry target:currentViewController callBack:callBack];
        }else{
            UIViewController *vc = [obj new];
            [vc fz_configPropertiesWithParams:entry.params];
            entry.callbackBlock = callBack;
            //To Do: vc 持有 entry
            vc.fz_entry = entry;
            UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
            [currentViewController presentViewController:navc animated:YES completion:nil];
        }
    }
}

+(BOOL)root:(FZRouterEntry* )entry target:(UIViewController * _Nullable)target callBack:(void(^_Nullable)(NSDictionary * _Nullable userInfo))callBack{
    
    Class obj = NSClassFromString(entry.className);
    
    UIViewController *root = [[UIApplication sharedApplication].delegate.window rootViewController];
    if ([root isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)root;
        UIViewController *sel = tab.selectedViewController;
        
        if ([sel isKindOfClass:[UINavigationController class]]) {
            UINavigationController *vc = (UINavigationController *)sel;
            if (vc.viewControllers.firstObject) {
                sel = vc.viewControllers.firstObject;
            }else{
                sel = [UIViewController fz_currentViewController];
            }
        }
        
        for (int i = 0; i < tab.viewControllers.count; i++) {
            if (i == tab.selectedIndex) {
                continue;
            }else{
                UIViewController *vc = tab.viewControllers[i];
                if ([vc isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nc = (UINavigationController *)vc;
                    if (nc.viewControllers.firstObject) {
                        vc = nc.viewControllers.firstObject;
                    }else{
                        continue;
                    }
                }
                
                if ([vc isKindOfClass:obj]) {
                    if (vc.navigationController) {
                        [vc.navigationController popToRootViewControllerAnimated:NO];
                    }else if (vc.presentedViewController){
                        [vc.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                    }
                    [FZRouter refresh:entry target:vc callBack:callBack];
                    [tab setSelectedIndex:i];
                    return YES;
                }else{
                    continue;
                }
            }
        }
        return NO;
    }else{
        return NO;
    }
}

#pragma mark -- Lazy Func ---

-(NSMutableDictionary *)dic_routes{
    if (_dic_routes == nil) {
        _dic_routes = [NSMutableDictionary dictionary];
    }
    return _dic_routes;
} 

@end
