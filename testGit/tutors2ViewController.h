//
//  tutors2ViewController.h
//  testGit
//
//  Created by Alex Bechmann on 24/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tutors2ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSArray *tutors;
@property NSMutableData *data;
@property NSString  *tutorIDSender;

@end
