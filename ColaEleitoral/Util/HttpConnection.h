//
//  HttpConnection.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AlertsUtil.h"


@interface HttpConnection : NSObject

@property (nonatomic, strong) AlertsUtil * alert;

-(id)initWithView:(UIView *)view;

-(void)callGetMethod:(NSString *)url options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
