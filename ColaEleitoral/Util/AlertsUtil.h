//
//  AlertsUtil.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface AlertsUtil : NSObject<MBProgressHUDDelegate>

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) MBProgressHUD *HUD;

-(id)initWithView:(UIView *)view;

-(void) exibirModalAguarde:(NSString *)msg;
-(void) ocultarModalAguarde;
-(void) removerModalAguarde;
-(void) exibirAlertaError:(NSString *)msg;


@end
