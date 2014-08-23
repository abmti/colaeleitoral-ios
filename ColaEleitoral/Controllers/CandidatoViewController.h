//
//  CandidatoViewController.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface CandidatoViewController : UIViewController

@property NSString *colaId;
@property NSString *estado;
@property NSInteger cargoId;
@property (strong, nonatomic) NSMutableArray *candidatos;

@property (weak, nonatomic) IBOutlet UIImageView *imgCandidato;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;


@end
