//
//  EstadoTableViewCell.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface EstadoTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *estado;
@property (weak, nonatomic) IBOutlet UIImageView *bandeira;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;

@end
