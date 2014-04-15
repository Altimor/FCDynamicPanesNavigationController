//
//  FCSampleViewController.m
//  FCDynamicPanesNavigationControllerDemo
//
//  Created by Florent Crivello on 4/15/14.
//  Copyright (c) 2014 Indri. All rights reserved.
//

#import "FCSampleViewController.h"
#import "FCDynamicPanesNavigationController.h"

@interface FCSampleViewController ()
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UIButton *mainButton;

@end

@implementation FCSampleViewController

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
	self.mainButton.layer.borderColor = [UIColor whiteColor].CGColor;
	self.mainButton.layer.borderWidth = 1.5f;
	self.mainButton.layer.cornerRadius = self.mainButton.frame.size.height / 2;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressMainButton:(id)sender {
	self.mainLabel.text = @"NOOOOO";
	self.mainButton.enabled = NO;
	[self.panesNavigationController popToViewController:self.parentViewController animated:YES];
}

@end
