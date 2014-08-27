//
//  ColaTableViewController.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "ColaTableViewController.h"
#import "HttpConnection.h"
#import "ColaTableViewCell.h"
#import "CandidatoViewController.h"

@interface ColaTableViewController ()

@end

@implementation ColaTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [ud objectForKey:@"deviceid"];
    
    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", URL_COLA, _estado, uid];
    [httpConnection callGetMethod:url options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         _cargos = [[NSMutableArray alloc]init];
         
         for(NSDictionary *c in [responseObject objectForKey:@"cola_cargo"]) {
             NSMutableDictionary *cargo = [c mutableCopy];
             [cargo setObject:[[c objectForKey:@"candidatos"] mutableCopy] forKey:@"candidatos"];
             [_cargos addObject:[cargo mutableCopy]];
         }
         
         _colaId = [(NSDictionary*)[responseObject objectForKey:@"_id"] objectForKey:@"$oid"];
         
         [ud setObject:_estado forKey:@"estado"];
         [ud setObject:_colaId forKey:@"colaId"];
         [ud synchronize];
         
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_cargos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *candidatos = [(NSDictionary*)[_cargos objectAtIndex:section] objectForKey:@"candidatos"];
    if ([candidatos count] == 0) {
        return 1;
    }
    return [candidatos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"%@", [NSNumber numberWithInteger:indexPath.row]);
    NSDictionary *cargo = [_cargos objectAtIndex:indexPath.section];
    NSArray *candidatos = [cargo objectForKey:@"candidatos"];
    ColaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([candidatos count] == 0) {
        
        UIImage* imageD = [UIImage imageNamed:@"profile_empty.png"];
        [cell.imgCandidato setImage:imageD];
        cell.labelNome.text = @"";
        cell.labelNumero.text = @"Selecione o candidato";
        cell.labelPartido.text = @"";
        
    } else {
        
        NSDictionary *candidato = [candidatos objectAtIndex:indexPath.row];
        cell.cargoId = [cargo objectForKey:@"id_cargo"];
        cell.labelNome.text = [candidato objectForKey:@"apelido"];
        cell.labelNumero.text = [candidato objectForKey:@"numero"];
        cell.labelPartido.text = [candidato objectForKey:@"partido"];
        [cell.imgCandidato setImageWithURL:[candidato objectForKey:@"foto"] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
    }
    
    cell.tag = [[cargo objectForKey:@"id_cargo"] intValue];
    cell.imgCandidato.layer.cornerRadius = cell.imgCandidato.frame.size.width / 2;
    cell.imgCandidato.clipsToBounds = YES;
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *cargo = [_cargos objectAtIndex:section];
    return [cargo objectForKey:@"nome_cargo"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *cargo = [_cargos objectAtIndex:indexPath.section];
    NSMutableArray *candidatos = [cargo objectForKey:@"candidatos"];
    if([candidatos count] == 0) {
        return NO;
    }
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSMutableDictionary *cargo = [_cargos objectAtIndex:indexPath.section];
        NSMutableArray *candidatos = [cargo objectForKey:@"candidatos"];
        NSMutableDictionary *candidato = [candidatos objectAtIndex:indexPath.row];
        
        HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@", URL_REMOVE, _colaId, [(NSDictionary*)[cargo objectForKey:@"_id"] objectForKey:@"$oid"], [candidato objectForKey:@"id"]];
        [httpConnection callGetMethod:url options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"sucesso");
             
             [candidatos removeObjectAtIndex:indexPath.row];
             if([candidatos count] == 0) {
                 [tableView reloadData];
             } else {
                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", [error localizedDescription]);
         }];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"segueCandidatos"]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        CandidatoViewController *cvc = (CandidatoViewController*) segue.destinationViewController;
        cvc.estado = _estado;
        cvc.colaId = _colaId;
        cvc.cargoId = cell.tag;
    }
    
}


@end
