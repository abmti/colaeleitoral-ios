//
//  EstadosTableViewController.m
//  ColaEleitoral
//
//  Created by Adriano Medeiros on 23/08/14.
//  Copyright (c) 2014 Adriano Medeiros. All rights reserved.
//

#import "EstadosTableViewController.h"
#import "HttpConnection.h"
#import "ColaTableViewController.h"
#import "EstadoTableViewCell.h"

@interface EstadosTableViewController () {
    
    NSMutableArray *estados;
    
}

@end

@implementation EstadosTableViewController

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    estados = [[NSMutableArray alloc] init];
    
    //[estados addObject:@{@"sigla":@"DF", @"nome":@"Distrito Federal"}];
    //[estados addObject:@{@"sigla":@"SP", @"nome":@"São Paulo"}];

    HttpConnection *httpConnection = [[HttpConnection alloc] initWithView:self.view];
    
    [httpConnection callGetMethod:URL_ESTADOS options:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"sucesso");
        estados = responseObject;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [estados count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EstadoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *estado = [estados objectAtIndex:indexPath.row];
    
    cell.estado = [estado objectForKey:@"sigla"];
    cell.labelNome.text = [estado objectForKey:@"nome"];
    [cell.bandeira setImageWithURL:[estado objectForKey:@"bandeira"] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    
    if ([[segue identifier] isEqualToString:@"segueCola"]) {
        EstadoTableViewCell *cell = (EstadoTableViewCell*) sender;
        ColaTableViewController *ctvc = (ColaTableViewController*) segue.destinationViewController;
        ctvc.estado = cell.estado;
    }
    
}


@end
