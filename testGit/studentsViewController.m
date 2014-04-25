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

@end

@implementation studentsViewController
NSArray *daysOfWeekArray;


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
                                nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
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
    
    if(section == 0){
        return [_students count];
    }
    
    
    return [_students count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];

    int weekdayFromJson = [[[_students objectAtIndex:indexPath.row] objectForKey:@"Weekday"] intValue];
    NSString *weekday = [NSString stringWithFormat:@""];
    
    weekday = [daysOfWeekArray objectAtIndex: weekdayFromJson];
    
    int hour = [[[_students objectAtIndex:indexPath.row] objectForKey:@"Hour"] intValue];
    int minute = [[[_students objectAtIndex:indexPath.row] objectForKey:@"Minute"] intValue];

    int row1 = [[_uniqueWeekdays objectAtIndex:indexPath.section] intValue];
    
    if (weekdayFromJson == row1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%02d:%02d - %@", hour, minute, [[_students objectAtIndex:indexPath.row] objectForKey:@"StudentName"]];
        cell.accessibilityValue = [[_students objectAtIndex:indexPath.row] objectForKey:@"StudentID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.studentIDSender = cell.accessibilityValue;
    //self.itemNameSender = cell.textLabel.text;
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
    
    for (id tempObject in _uniqueWeekdays) {
        NSLog(@"Single element: %@", tempObject);
    }
    
    [self.mainTableView reloadData];
    
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
    
    editStudentViewController *item = segue.destinationViewController;
    item.studentID = self.studentIDSender;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
