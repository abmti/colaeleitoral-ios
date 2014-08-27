//
//  ViewController.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "ViewController.h"
#import "EstadosTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _btnComecar.hidden = YES;
    
    UITapGestureRecognizer * answerOneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    answerOneTapGesture.numberOfTapsRequired = 1;
    answerOneTapGesture.delegate = self;
    [self.view addGestureRecognizer:answerOneTapGesture];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickView:(id)sender {
    EstadosTableViewController *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"estadosView"];
    [self.navigationController pushViewController: evc animated:YES];
}

@end
