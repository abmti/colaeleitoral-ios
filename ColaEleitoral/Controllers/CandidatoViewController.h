//
//  CandidatoViewController.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertsUtil.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "IQKeyboardManager.h"
#import "IQDropDownTextField.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface CandidatoViewController : UIViewController

@property (nonatomic, strong) AlertsUtil * alert;

@property NSMutableArray *partidos;
@property NSString *colaId;
@property NSString *estado;
@property NSInteger cargoId;
@property (strong, nonatomic) NSMutableArray *candidatos;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *partidoField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *viewCandidato;
@property (weak, nonatomic) IBOutlet UILabel *labelNumero;
@property (weak, nonatomic) IBOutlet UIImageView *imgCandidato;
@property (weak, nonatomic) IBOutlet UILabel *labelApelido;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;
@property (weak, nonatomic) IBOutlet UILabel *labelCargo;
@property (weak, nonatomic) IBOutlet UILabel *labelPartido;


@end
