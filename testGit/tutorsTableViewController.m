//
//  tutorsTableViewController.m
//  testGit
//
//  Created by Alex Bechmann on 24/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "tutorsTableViewController.h"

@interface tutorsTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation tutorsTableViewController

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
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSURL *url = [NSURL URLWithString:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=1"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [[NSURLConnection alloc] initWithRequest: request delegate:self];

}

//-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
//{
//    _data = [[NSMutableData alloc]init];
//    
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
//{
//    [_data appendData:theData];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    _tutors = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
//    [self.mainTableView reloadData];
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [errorView show];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_tutors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //cell.textLabel.text = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorName"];
    
    
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


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
