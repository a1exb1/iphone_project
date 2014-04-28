//
//  menuViewController.h
//  testGit
//
//  Created by Thomas Kjær Christensen on 28/04/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate;


@interface MenuViewController : UIViewController
@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *categoryList;
@end


@protocol MenuViewControllerDelegate
-(void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId;
@end