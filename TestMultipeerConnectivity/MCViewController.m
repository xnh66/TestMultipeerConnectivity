//
//  MCViewController.m
//  TestMultipeerConnectivity
//
//  Created by xuninghao on 2019/4/8.
//  Copyright © 2019 Xxxxxxu. All rights reserved.
//

#import "MCViewController.h"
#import "MultipeerSession.h"

@interface MCViewController ()

@property (nonatomic, strong) MultipeerSession *multipeerSession;

@end

@implementation MCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.multipeerSession  = [[MultipeerSession alloc] initWithType:self.testType];
    self.multipeerSession.superVC = self;
}
- (IBAction)start:(id)sender {
    if(self.multipeerSession)
        [self.multipeerSession start];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)stop:(id)sender {
    [self.multipeerSession stop];
}

static int i = 0;
- (IBAction)sendMessage:(id)sender
{
    [self.multipeerSession sendData:i++];
}

- (void)dealloc
{
    NSLog(@"xnh: MCViewController deallocing");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
