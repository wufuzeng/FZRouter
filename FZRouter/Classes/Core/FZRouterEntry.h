//
//  FZRouterEntry.h
//  MeiLiBa
//
//  Created by 吴福增 on 2018/12/13.
//  Copyright © 2018 恒颜互联网. All rights reserved.
//

// scheme://host:port/path?Query=&params=

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZRouterEntry : NSObject

@property (nonatomic,strong) NSString *scheme;
@property (nonatomic,strong) NSString *host;
@property (nonatomic,strong) NSString *port;
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSString *query;
@property (nonatomic,strong) NSDictionary *params;

@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *routerUrl;

/** 路由对应的回调处理事件 */
@property (nonatomic,copy) void(^callbackBlock)(NSDictionary *userInfo);

-(instancetype)initWithUrl:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
