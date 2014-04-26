//
//  studentNote.h
//  testGit
//
//  Created by Alex Bechmann on 26/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface studentNote : NSObject

@property long studentNoteID;
@property long studentID;
@property NSString *note;
@property NSDate *enteredDate;

-(void) loadByID: (long)noteID;


@end
