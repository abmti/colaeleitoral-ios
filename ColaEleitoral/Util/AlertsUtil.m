//
//  AlertsUtil.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "AlertsUtil.h"

@implementation AlertsUtil

-(id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        self.view = view;
    }
    return self;
}

-(void) exibirModalAguarde:(NSString *)msg
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.layer.zPosition = 0;
        [self.view addSubview:self.HUD];
        self.HUD.delegate = self;
        self.HUD.labelText = msg;
    }
    
    [self.HUD show:YES];
}

-(void) ocultarModalAguarde
{
    if (self.HUD)
    {
        [self.HUD show:NO];
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
}

-(void)removerModalAguarde
{
    if (self.HUD)
    {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
}

-(void) exibirAlertaError:(NSString *)msg
{
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [error show];
}


#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[self removerModalAguarde];
}


@end
