//
//  FZRouterEntry.m
//  MeiLiBa
//
//  Created by 吴福增 on 2018/12/13.
//  Copyright © 2018 恒颜互联网. All rights reserved.
//

#import "FZRouterEntry.h"

#import "FZRouter.h"

@implementation FZRouterEntry

-(instancetype)initWithUrl:(NSString*)url{
    //scheme://host:port/path?query=&params=
    if (self = [super init]) {
        if (!url.length) {
            NSLog(@"路由路径为空,请检查路径");
        }else{
            if (![url containsString:@"://"]) {
                NSLog(@"无法识别该路径,请检查路径");
            }else{
                //scheme://host:port/path?query=&params=
                NSArray* arr_scheme_link_param = [url componentsSeparatedByString:@"://"];
                self.scheme = arr_scheme_link_param.firstObject;
                NSString* link_param = arr_scheme_link_param.lastObject;
                //host:port/path?query=&params=
                if (![link_param containsString:@"?"]) {
                    //host:port/path
                    NSString * link = link_param;
                    if ([link containsString:@"/"]) {
                        //host:port/path
                        NSArray * arr_last_path = [link componentsSeparatedByString:@"/"];
                        NSString* host_port = arr_last_path.firstObject;
                        self.path = arr_last_path.lastObject;
                        //host:port
                        if ([host_port containsString:@":"]) {
                            //host:port
                            NSArray* arr_host_port = [host_port componentsSeparatedByString:@":"];
                            self.host = arr_host_port.firstObject;
                            self.port = arr_host_port.lastObject;
                        }else{
                            //host
                            //port
                            self.host = host_port;
                            self.port = host_port;
                        }
                     }else{
                         //host:port
                         //path
                         if ([link containsString:@":"]) {
                             //host:port
                             NSArray* arr_host_port = [link componentsSeparatedByString:@":"];
                             self.host = arr_host_port.firstObject;
                             self.port = arr_host_port.lastObject;
                         }else{
                             //host
                             //port
                             //path
                             self.host = link;
                             self.port = link;
                             self.path = link;
                         }
                    }
                }else{
                    //host:port/path?query=&params=
                    NSArray * arr_link_param = [link_param componentsSeparatedByString:@"?"];
                    
                    NSString * link = arr_link_param.firstObject;
                    //link : host:port/path?
                    if ([link containsString:@"/"]) {
                        //host:port/path
                        NSArray * arr_last_path = [link componentsSeparatedByString:@"/"];
                        NSString* host_port = arr_last_path.firstObject;
                        self.path = arr_last_path.lastObject;
                        //host:port
                        if ([host_port containsString:@":"]) {
                            //host:port
                            NSArray* arr_host_port = [host_port componentsSeparatedByString:@":"];
                            self.host = arr_host_port.firstObject;
                            self.port = arr_host_port.lastObject;
                        }else{
                            //host
                            //port
                            self.host = host_port;
                            self.port = host_port;
                        }
                    }else{
                        //host:port
                        //path
                        //host:port
                        if ([link containsString:@":"]) {
                            //host:port
                            NSArray* arr_host_port = [link componentsSeparatedByString:@":"];
                            self.host = arr_host_port.firstObject;
                            self.port = arr_host_port.lastObject;
                        }else{
                            //host
                            //port
                            //path
                            self.host = link;
                            self.port = link;
                            self.path = link;
                        }
                    }
                    
                    NSString * param = arr_link_param.lastObject;
                    //param : query=&params=
                    
                    if (![param containsString:@"&"]) {
                        //param : query=
                        //param : params=
                        if (![param containsString:@"="]) {
                            //param : query
                            //param : params
                        }else{
                            //param : query=
                            //param : params=
                            NSArray* arr_query_param = [param componentsSeparatedByString:@"="];
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            NSString * key = arr_query_param.firstObject?arr_query_param.firstObject:@"NotFound";
                            params[key] = arr_query_param.lastObject;
                            
                            if ([key isEqualToString:@"q"]||[key isEqualToString:@"a"]) {
                                //param : query=
                                self.query = params[key];
                            }else{
                                //param : params=
                               self.params = params;
                            }
                        }
                        
                    }else{
                        //param : query=&params=
                        //param : params=&params=
                        NSArray* arr_query_params = [param componentsSeparatedByString:@"&"];
                        NSMutableDictionary * params = [NSMutableDictionary dictionary];
                        for (int i = 0; i < arr_query_params.count; i++) {
                            
                            NSString * key_value     = arr_query_params[i];
                            NSArray  * arr_key_value = [key_value componentsSeparatedByString:@"="];
                            
                            NSString * key   = arr_key_value.firstObject;
                            NSString * value = arr_key_value.lastObject;
                            
                            if (i == 1 && ([key isEqualToString:@"q"]||[key isEqualToString:@"a"])) {
                                //param : query=&params=
                                self.query = value;
                            }else{
                                //param : params=&params=
                                params[key] = value;
                            }
                        }
                        self.params = params;
                    }
                }
            }
        }
        //classNmae
        self.className = [FZRouter globalRouter].dic_routes[self.path];
        if (self.path.length && self.className.length) {
            NSMutableString * temp = [[NSMutableString alloc]initWithString:url];
            NSRange range = [temp rangeOfString:self.path];
            [temp replaceCharactersInRange:range withString:self.className];
            //routerUrl
            self.routerUrl = temp;
        }
    }
    return self;
}



@end
