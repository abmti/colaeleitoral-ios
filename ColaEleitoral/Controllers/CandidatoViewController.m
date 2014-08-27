//
//  CandidatoViewController.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "CandidatoViewController.h"
#import "HttpConnection.h"
#import "InfoViewController.h"

@interface CandidatoViewController () {
    NSInteger index;
    BOOL processando;
    UISwipeGestureRecognizer * swipeleft;
    UISwipeGestureRecognizer * swiperight;
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
    
    self.alert = [[AlertsUtil alloc]initWithView:self.view];
    
    [self addGestures];
    
    //[self.imgCandidato setImageWithURL:[candidato objectForKey:@"url_foto"] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    self.imgCandidato.layer.cornerRadius = self.imgCandidato.frame.size.width / 2;
    self.imgCandidato.clipsToBounds = YES;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    [httpConnection callGetMethod:URL_PARTIDOS options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"sucesso");
         
         [_partidoField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:) shouldShowPlaceholder:YES];
         
         _partidos = responseObject;
         [_partidoField setItemListDictionary:_partidos optsKey:@"partidoId" optsLabel:@"sigla" optsSelecione:YES];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
    [self carregarCandidatos];
    
}

- (void) addGestures
{
    // Swipe Left
    swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    // SwipeRight
    swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
}

- (void) carregarCandidatos
{
    
    NSString *partido = @"n";
    if (_partidoField.text.length > 0) {
        partido = _partidoField.textKey;
    }
    
    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@", URL_CANDIDATOS, _estado, [NSNumber numberWithInteger:_cargoId], partido];
    [httpConnection callGetMethod:url options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"sucesso");
         index = 0;
         _candidatos = responseObject;
         if([_candidatos count] > 0) {
             [self exibirCandidato];
         } else {
             [self.alert exibirAlertaError:@"Não foi encontrado nenhum candidato"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}

- (void) exibirCandidato
{
    NSDictionary *candidato = [_candidatos objectAtIndex:index];
    _labelApelido.text = [candidato objectForKey:@"apelido"];
    _labelNome.text = [candidato objectForKey:@"nome"];
    _labelCargo.text = [candidato objectForKey:@"cargo"];
    _labelPartido.text = [candidato objectForKey:@"partido"];
    
    [self.imgCandidato setImageWithURL:[candidato objectForKey:@"foto"] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    CGRect frame2 = self.view.frame;
    frame2.origin.x = 0;
    
    [UIView animateWithDuration:0.33f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         [self.view setFrame:frame2];
                     }
                     completion:^(BOOL finished){
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueInfo"]) {
        InfoViewController *ivc = (InfoViewController*) segue.destinationViewController;
        NSDictionary *candidato = [_candidatos objectAtIndex:index];
        ivc.candidato = candidato;
    }
}



-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Left");
    
    CGRect frame = self.view.frame;
    frame.origin.x = -320;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         [self.view setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         
                         CGRect frame2 = self.view.frame;
                         frame2.origin.x = 320;
                         self.view.frame = frame2;
                         [self exibirProximo];
                     }];
    
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Right");
    CGRect frame = self.view.frame;
    frame.origin.x = 320;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         [self.view setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         CGRect frame2 = self.view.frame;
                         frame2.origin.x = 320;
                         self.view.frame = frame2;
                         [self completeRight];
                     }];
    
}

-(void)completeRight
{
    if(index+1 >= [_candidatos count]) {
        [self exibirProximo];
        return;
    }
    
    NSDictionary *candidato = [_candidatos objectAtIndex:index];
    
    NSString *partido = @"n";
    if (_partidoField.text.length > 0) {
        partido = _partidoField.textKey;
    }
    
    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@", URL_AVALIA, [candidato objectForKey:@"id"], _colaId, [NSNumber numberWithInteger:_cargoId], _estado, @"y", partido];
    [httpConnection callGetMethod:url options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"sucesso");
         [self.alert exibirAlertaBottom:@"Adicionado a cola com sucesso." error:NO duracao:3];
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
        if(index >= [_candidatos count]) {
            index = 0;
        }
        [self exibirCandidato];
    }
}

-(void)doneAction:(UIBarButtonItem*)barButton
{
    [_partidoField resignFirstResponder];
    [self carregarCandidatos];
}

@end
