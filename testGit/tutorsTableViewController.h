//
//  tutorsTableViewController.h
//  testGit
//
//  Created by Alex Bechmann on 24/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tutorsTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource>

@property NSArray *tutors;
@property NSMutableData *data;


@end
