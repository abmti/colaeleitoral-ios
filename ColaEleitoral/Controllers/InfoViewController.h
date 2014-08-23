//
//  InfoViewController.h
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property NSDictionary *candidato;
@property (weak, nonatomic) IBOutlet UILabel *labelMinibio;



@end
