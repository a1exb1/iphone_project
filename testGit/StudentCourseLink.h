//
//  StudentCourseLink.h
//  testGit
//
//  Created by Alex Bechmann on 26/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentCourseLink : NSObject

@property long StudentCourseLinkID;
@property long StudentID;
@property long CourseID;
@property int Duration;
@property NSDate *DateTime;

-(void) load;
-(void) loadByID: (long)linkID;
-(void) save;
-(void) deleteLink;

@end
