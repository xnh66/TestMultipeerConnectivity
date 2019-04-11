//
//  ViewController.m
//  TestMultipeerConnectivity
//
//  Created by xuninghao on 2019/4/8.
//  Copyright © 2019 Xxxxxxu. All rights reserved.
//

#import "ViewController.h"
#import "MCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startBroser:(id)sender {
    [self performSegueWithIdentifier:@"forBroser" sender:sender];
}

- (IBAction)startAdvertise:(id)sender {
    [self performSegueWithIdentifier:@"forAdver" sender:sender];
}

- (IBAction)startBroserAndAdvertise:(id)sender {
    [self performSegueWithIdentifier:@"forBroserAndAdver" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier  isEqual: @"forBroser"])
    {
        MCViewController *mcVC = (MCViewController *)segue.destinationViewController;
        mcVC.testType = 0;
    }
    else if([segue.identifier isEqual: @"forAdver"])
    {
        MCViewController *mcVC = (MCViewController *)segue.destinationViewController;
        mcVC.testType = 1;
    }
    else if([segue.identifier isEqual:@"forBroserAndAdver"])
    {
        MCViewController *mcVC = (MCViewController *)segue.destinationViewController;
        mcVC.testType = 2;
    }
}

@end
