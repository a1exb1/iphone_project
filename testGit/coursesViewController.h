//
//  coursesViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coursesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString *tutorID;

@property NSArray *courses;
@property NSMutableData *data;
@property NSString  *courseIDSender;

@end
