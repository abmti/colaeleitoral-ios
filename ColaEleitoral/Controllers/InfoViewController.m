//
//  InfoViewController.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _labelMinibio.numberOfLines = 0;
    _labelMinibio.text = [_candidato objectForKey:@"miniBio"];
    //CGFloat heightLabel = [self getRectText:_labelMinibio.text];
    CGFloat heightLabel = 50;
    CGRect frameLabel = _labelMinibio.frame;
    frameLabel.origin = CGPointMake(10, 6);
    frameLabel.size = CGSizeMake(300, heightLabel);
    _labelMinibio.frame = frameLabel;
    
    [self setTitle:[_candidato objectForKey:@"apelido"]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(CGFloat)getRectText:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:12];
    //UIFont *font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:21];
    //CGSize maximumLabelSize = CGSizeMake(296,9999);
    //CGSize expectedLabelSize = [text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    //int a = expectedLabelSize.height+35;
    //return a;
    CGSize constraint = CGSizeMake(296,NSUIntegerMax);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [str boundingRectWithSize:constraint
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 attributes:attributes
                                    context:nil];
    return rect.size.height;
}



@end
