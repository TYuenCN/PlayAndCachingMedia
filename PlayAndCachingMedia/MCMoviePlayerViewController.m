//
//  MCMoviePlayerViewController.m
//  MicroBusinessCard
//
//  Created by Lukay on 14-2-18.
//  Copyright (c) 2014年 com.lukay.mbc. All rights reserved.
//

#import "MCMoviePlayerViewController.h"

@interface MCMoviePlayerViewController ()

@end

@implementation MCMoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
