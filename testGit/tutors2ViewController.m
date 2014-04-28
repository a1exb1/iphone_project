//
//  tutors2ViewController.m
//  testGit
//
//  Created by Alex Bechmann on 24/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "tutors2ViewController.h"
#import "coursesViewController.h"



@interface tutors2ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end


@implementation tutors2ViewController

- (void)menuViewControllerDidFinishWithMenuItemID:(NSInteger)menuItemID
{
     [self.slidingViewController resetTopView];
}



- (void)viewDidAppear:(BOOL)animated {
   }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    // Add a shadow to the top view so it looks like it is on top of the others
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Tell it which view should be created under left
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        //[(MenuViewController *)self.slidingViewController.underLeftViewController setCategoryList:self.toDoCategories];
        [(MenuViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
    }
    
    // Add the pan gesture to allow sliding
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
    if (selection) {
        [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%d&ts=%f", 1, [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest: request delegate:self];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tutors count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorName"];
    cell.accessibilityValue = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.tutorIDSender = cell.accessibilityValue;
    self.tutorNameSender = cell.textLabel.text;
    [self performSegueWithIdentifier:@"TutorsToCourses" sender:self];
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    _tutors = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
    [self.mainTableView reloadData];
    
    if ([_tutors count] == 0) {
        _statusLbl.text = @"No tutors, click the plus to add one";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        _statusLbl.hidden = YES;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    coursesViewController *item = segue.destinationViewController;
    item.tutorID = self.tutorIDSender;
    item.tutorName = self.tutorNameSender;
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



@end
