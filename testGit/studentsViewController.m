//
//  studentsViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "studentsViewController.h"

@interface studentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation studentsViewController

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
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbycourse&id=%@", _courseID];
    NSURL *url = [NSURL URLWithString: urlString];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest: request delegate:self];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_students count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_students objectAtIndex:indexPath.row] objectForKey:@"StudentName"];
    cell.accessibilityValue = [[_students objectAtIndex:indexPath.row] objectForKey:@"StudentID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    NSString *weekdayFromJson = [NSString stringWithFormat:@"%@", [[_students objectAtIndex:indexPath.row] objectForKey:@"Weekday"]];
    NSString *weekday = [NSString stringWithFormat:@""];
    
    
    
    if ([weekdayFromJson isEqualToString:@"0"]) {
        weekday = [NSString stringWithFormat:@"Sunday"];
    }
    else if ([weekdayFromJson isEqualToString:@"1"]) {
        weekday = [NSString stringWithFormat:@"Monday"];
    }
    else if ([weekdayFromJson isEqualToString:@"2"]) {
        weekday = [NSString stringWithFormat:@"Tuesday"];
    }
    else if ([weekdayFromJson isEqualToString:@"3"]) {
        weekday = [NSString stringWithFormat:@"Wednesday"];
    }
    else if ([weekdayFromJson isEqualToString:@"4"]) {
        weekday = [NSString stringWithFormat:@"Thursday"];
    }
    else if ([weekdayFromJson isEqualToString:@"5"]) {
        weekday = [NSString stringWithFormat:@"Friday"];
    }
    else if ([weekdayFromJson isEqualToString:@"6"]) {
        weekday = [NSString stringWithFormat:@"Saturday"];
    }
    
    //[NSString stringWithFormat:@"%02d", 1];
    
    int hour = [[[_students objectAtIndex:indexPath.row] objectForKey:@"Hour"] intValue];
    int minute = [[[_students objectAtIndex:indexPath.row] objectForKey:@"Minute"] intValue];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%02d:%02d)", weekday, hour, minute];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.studentIDSender = cell.accessibilityValue;
    //self.itemNameSender = cell.textLabel.text;
    //[self performSegueWithIdentifier:@"CoursesToStudent" sender:self];
    
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
    
    _students = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
    [self.mainTableView reloadData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
