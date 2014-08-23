//
//  ColaTableViewController.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColaTableViewController : UITableViewController

@property(strong, nonatomic) NSString *estado;
@property(strong, nonatomic) NSString *colaId;
@property(strong, nonatomic) NSMutableArray *cargos;

@end
