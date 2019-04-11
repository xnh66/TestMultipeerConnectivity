//
//  MCViewController.h
//  TestMultipeerConnectivity
//
//  Created by xuninghao on 2019/4/8.
//  Copyright © 2019 Xxxxxxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCViewController : UIViewController

@property (nonatomic, assign) int testType;

@property (nonatomic, weak) UIViewController *superVC;

@end

NS_ASSUME_NONNULL_END
