//
//  MultipeerSession.h
//  TestMultipeerConnectivity
//
//  Created by xuninghao on 2019/4/8.
//  Copyright © 2019 Xxxxxxu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MultipeerConnectivity/MultipeerConnectivity.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultipeerSession : NSObject <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *broser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

@property (nonatomic, weak) UIViewController *superVC;

// type 0 broser;
// type 1 advertiser;
// type 2 both broser and advertiser;
-(instancetype)initWithType:(int) type;

-(void)start;

-(void)stop;

-(void)sendData:(int)num;

@end

NS_ASSUME_NONNULL_END
