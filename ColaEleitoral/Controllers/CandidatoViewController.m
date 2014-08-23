//
//  CandidatoViewController.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "CandidatoViewController.h"
#import "HttpConnection.h"

@interface CandidatoViewController () {
    NSInteger index;
}

@end

@implementation CandidatoViewController

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
    
    
    // Swipe Left
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    // SwipeRight
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    //[self.imgCandidato setImageWithURL:[candidato objectForKey:@"url_foto"] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    self.imgCandidato.layer.cornerRadius = self.imgCandidato.frame.size.width / 2;
    self.imgCandidato.clipsToBounds = YES;
    
    [self carregarCandidatos];
    
    
}

- (void) carregarCandidatos
{
    
    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", URL_CANDIDATOS, _estado, [NSNumber numberWithInteger:_cargoId]];
    [httpConnection callGetMethod:url options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"sucesso");
         index = 0;
         _candidatos = responseObject;
         [self exibirCandidato];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}

- (void) exibirCandidato
{
    NSDictionary *candidato = [_candidatos objectAtIndex:index];
    _labelNome.text = [candidato objectForKey:@"apelido"];
    [self.imgCandidato setImageWithURL:[candidato objectForKey:@"foto"] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
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


-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Left");
    [self exibirProximo];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Right");
    
    NSDictionary *candidato = [_candidatos objectAtIndex:index];
    
    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@", URL_AVALIA, [candidato objectForKey:@"id"], _colaId, [NSNumber numberWithInteger:_cargoId], _estado, @"y"];
    [httpConnection callGetMethod:url options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"sucesso");
         
         [self exibirProximo];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}

-(void) exibirProximo
{
    index++;
    if (index == 10) {
        [self carregarCandidatos];
    } else {
        [self exibirCandidato];
    }
}

@end
