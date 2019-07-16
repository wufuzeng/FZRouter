//
//  FZRouter.h
//  MeiLiBa
//
//  Created by 吴福增 on 2018/12/13.
//  Copyright © 2018 恒颜互联网. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FZRouterEntry.h"

#import "UIViewController+FZRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FZRouter : NSObject

/** 路由配置 */
@property (nonatomic,strong) NSMutableDictionary *dic_routes;

/** app Scheme (xxx://) */
@property (nonatomic,strong) NSString *localScheme;
/** 导航控制器 */
@property (nonatomic,strong) UINavigationController *navigationController;
/** 网页处理 */
@property (nonatomic,copy) UIViewController *(^URLHandler)(NSString * path,FZRouterEntry* entry);
/** 确保界面唯一性 */
@property (nonatomic,assign,getter=isUnique) BOOL unique;

/** 全局路由 */
+(instancetype)globalRouter;
/** 注册路由 */
+(void)registerRoutesWithProfile:(NSString *)profile;
+(void)addRouteWithKey:(NSString *)key vcName:(NSString *)vcName;
/** 移除路由 */
+(void)removeRouteWithKey:(NSString *)key;
+(void)removeAllRoutes;

+(NSString*)local:(NSString*)key;

/** 外部打开连接 */
+(void)openExternal:(NSString *)url;

/** 内部打开 */
+(void)open:(NSString *)path;
+(void)open:(NSString *)path target:(UIViewController * _Nullable)target;
+(void)open:(NSString *)path target:(UIViewController * _Nullable)target callBack:(void(^_Nullable)(NSDictionary * _Nullable userInfo)) callBack;



@end

NS_ASSUME_NONNULL_END
