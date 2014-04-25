//
//  studentsViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "studentsViewController.h"
#import "editStudentViewController.h"

@interface studentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation studentsViewController
NSArray *daysOfWeekArray;
NSMutableArray *viewStudentsArray;

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
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbycourse&id=%@&ts=%f", _courseID, [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest: request delegate:self];
    
    daysOfWeekArray = [[NSArray alloc] initWithObjects:
                                @"Sunday",
                                @"Monday",
                                @"Tuesday",
                                @"Wednesday",
                                @"Friday",
                                @"Saturday",
                                @"Sunday",
                                nil];
    
    viewStudentsArray = [[NSMutableArray alloc] init];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:0.9372549019607843 green:0.9372549019607843 blue:0.9372549019607843 alpha:1]];
    [_mainTableView setBackgroundColor:[UIColor colorWithRed:0.9372549019607843 green:0.9372549019607843 blue:0.9372549019607843 alpha:1]];
    //_mainTableView.hidden = YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    int uniqueDay = [[_uniqueWeekdays objectAtIndex:section] intValue];
    NSString *uniqueDayString;
    uniqueDayString = [daysOfWeekArray objectAtIndex: uniqueDay];
    sectionName = uniqueDayString;
    
    return sectionName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_uniqueWeekdays count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[viewStudentsArray objectAtIndex:section] count];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    sectionArray = [viewStudentsArray objectAtIndex:indexPath.section];
    
    int weekdayFromJson = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Weekday"] intValue];
    NSString *weekday = [NSString stringWithFormat:@""];
    
    weekday = [daysOfWeekArray objectAtIndex: weekdayFromJson];
    int hour = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Hour"] intValue];
    int minute = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Minute"] intValue];

    cell.textLabel.text = [NSString stringWithFormat:@"%02d:%02d - %@", hour, minute, [[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentName"]];
    cell.accessibilityValue = [[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //_mainTableView.hidden = NO;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.studentIDSender = cell.accessibilityValue;
    [self performSegueWithIdentifier:@"StudentsToEditStudent" sender:self];
    
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc]init];
    _uniqueWeekdays = [[NSArray alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _students = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
    _uniqueWeekdays = [_students valueForKeyPath:@"@distinctUnionOfObjects.Weekday"];
    
    //sort array numerically
    _uniqueWeekdays = [_uniqueWeekdays sortedArrayUsingDescriptors:
                       @[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue"
                                                       ascending:YES]]];
    for (id weekday in _uniqueWeekdays) {
        NSMutableArray *listOfStudentsForArray = [[NSMutableArray alloc] init];
        for (id student in _students) {
            if([[student objectForKey:@"Weekday" ] isEqualToString:weekday]){
                [listOfStudentsForArray addObject:student];
            }
        }
        [viewStudentsArray addObject:listOfStudentsForArray];
    }
    [self.mainTableView reloadData];
    
    if ([_students count] == 0) {
        _statusLbl.text = @"No students, click the plus to add one";
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
    editStudentViewController *item = segue.destinationViewController;
    item.studentID = self.studentIDSender;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
