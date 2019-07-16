//
//  UIViewController+FZRouter.h
//  MeiLiBa
//
//  Created by 吴福增 on 2018/12/24.
//  Copyright © 2018 恒颜互联网. All rights reserved.
//

/**
 主要为 路由回调服务
 */

#import <UIKit/UIKit.h>
#import "FZRouterEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FZRouter)
/** 路由实体 */
@property (nonatomic,strong) FZRouterEntry *fz_entry;
/** 当前控制器 */
+(UIViewController*)fz_currentViewController;
/** 刷新数据 */
-(void)fz_refresh;
/** 配置属性 */
-(void)fz_configPropertiesWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
