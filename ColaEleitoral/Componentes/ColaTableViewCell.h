//
//  ColaTableViewCell.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface ColaTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *cargoId;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;
@property (weak, nonatomic) IBOutlet UILabel *labelNumero;
@property (weak, nonatomic) IBOutlet UILabel *labelPartido;
@property (weak, nonatomic) IBOutlet UIImageView *imgCandidato;

@end
