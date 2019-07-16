//
//  UIViewController+FZRouter.m
//  MeiLiBa
//
//  Created by 吴福增 on 2018/12/24.
//  Copyright © 2018 恒颜互联网. All rights reserved.
//

#import "UIViewController+FZRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (FZRouter)

/** 当前控制器 */
+(UIViewController*)fz_currentViewController{
    UIViewController *topViewController = [[UIApplication sharedApplication].delegate.window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

-(FZRouterEntry *)fz_entry{
    return objc_getAssociatedObject(self, @selector(fz_entry));
}

-(void)setFz_entry:(FZRouterEntry *)fz_entry{  objc_setAssociatedObject(self,@selector(fz_entry),fz_entry,OBJC_ASSOCIATION_RETAIN);
}

-(void)fz_refresh{
    NSLog(@"请子类VC中重写-(void)fz_refresh方法");
}


-(NSArray *)fz_allPropertyNames{
    //属性名称数组
    NSMutableArray *props = [NSMutableArray array];
    //属性列表变量
    unsigned int outCount,i;
    //获取属性列表对象
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    return props;
}


-(void)fz_configPropertiesWithParams:(NSDictionary *)params{
    NSArray *propArray = [self fz_allPropertyNames];
    if ([params isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in params) {
            if ([propArray containsObject:key]) {
                if (params[key] && ![params[key] isKindOfClass:[NSNull class]]) {
                    if ([params[key] isKindOfClass:[NSString class]]) {
                        if (![params[key] isEqualToString:@"<null>"]) {
                            [self setValue:params[key] forKey:key];
                        } else {
                            [self setValue:nil forKey:key];
                        }
                    } else {
                        [self setValue:params[key] forKey:key];
                    }
                }
            } else {
                if (![key isEqualToString:@"id"]) {
                    NSLog(@"<Runtime> %@ >>Error:no found key:%@",self,key);
                }
            }
        }
    }
}




@end
