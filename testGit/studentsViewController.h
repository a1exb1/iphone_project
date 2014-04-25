//
//  studentsViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface studentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString *courseID;

@property NSArray *students;
@property NSMutableData *data;
@property NSString  *studentIDSender;

@end
