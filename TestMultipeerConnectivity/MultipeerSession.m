//
//  MultipeerSession.m
//  TestMultipeerConnectivity
//
//  Created by xuninghao on 2019/4/8.
//  Copyright © 2019 Xxxxxxu. All rights reserved.
//

#import "MultipeerSession.h"

@interface MultipeerSession()
{
    int _type;
}

@end

@implementation MultipeerSession

static NSString *serviceType = @"mc-test-xnh";
-(instancetype)initWithType:(int)type
{
    if(self = [super init])
    {
        _type = type;
        
        _peerID = [[MCPeerID alloc] initWithDisplayName:
                            [[UIDevice currentDevice] name]];
        
        if(type <0 || type > 2)
            type = 2;
        
        _session = [[MCSession alloc] initWithPeer:_peerID securityIdentity:nil encryptionPreference:MCEncryptionRequired];
        _session.delegate = self;
        
        if(type == 2 || type == 0)
        {
            _broser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID
                                                       serviceType:serviceType];
            _broser.delegate = self;
        }
        
        if(type == 2 || type == 1)
        {
            _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID
                                                            discoveryInfo:nil
                                                              serviceType:serviceType];
            _advertiser.delegate = self;
        }
    }
    
    NSLog(@"xnh: MC init success: peer %@  session %p  broser %p  advertiser %p", _peerID.displayName, _session, _broser, _advertiser);
    return self;
}

-(void)start
{
    if(_type == 2 || _type == 0)
        [_broser startBrowsingForPeers];
    if(_type == 2 || _type == 1)
        [_advertiser startAdvertisingPeer];
}

-(void)stop
{
    if(self.broser)
        [self.broser stopBrowsingForPeers];
    if(self.advertiser)
        [self.advertiser stopAdvertisingPeer];
    [self.session disconnect];
}

-(void)sendData:(int)num
{
    NSNumber *nsNum = [[NSNumber alloc] initWithInt:num];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:nsNum requiringSecureCoding:YES error:nil];
    
    NSLog(@"xnh: MC send data %d to %d peers", num, [self.session.connectedPeers count]);

    if(self.session)
    {
        [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
    }
}

#pragma mark - MCSessionDelegate
-(void)session:(MCSession *)session peer:(nonnull MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"xnh: MCSessionDelegate session %p  peer %@  didchangeState %ld ", session,
          peerID.displayName, (long)state);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSNumber *nsNum = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSNumber class] fromData:data error:nil];
    
    if(nsNum)
    {
        NSLog(@"xnh: MCSessionDelegate session 1 %p  peer %@  didReceiveData %p Unarchive sucs %@",session, peerID.displayName, data, nsNum);
    }
    else
    {
        NSLog(@"xnh: MCSessionDelegate session 2 %p  peer %@  didReceiveData %p Unarchive failed as NSNumber",session, peerID.displayName, data);
    }
    
    NSArray *nsArr = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:data error:nil];
    
    if(nsArr)
    {
        NSLog(@"xnh: MCSessionDelegate session 3 %p  peer %@  didReceiveData %p Unarchive sucs %@",session, peerID.displayName, data, nsArr);
    }
    else
    {
        NSLog(@"xnh: MCSessionDelegate session 4 %p  peer %@  didReceiveData %p Unarchive failed as NSArray",session, peerID.displayName, data);
    }
}

- (void)session:(nonnull MCSession *)session didFinishReceivingResourceWithName:(nonnull NSString *)resourceName fromPeer:(nonnull MCPeerID *)peerID atURL:(nullable NSURL *)localURL withError:(nullable NSError *)error {
    //
}


- (void)session:(nonnull MCSession *)session didReceiveStream:(nonnull NSInputStream *)stream withName:(nonnull NSString *)streamName fromPeer:(nonnull MCPeerID *)peerID {
    //
}


- (void)session:(nonnull MCSession *)session didStartReceivingResourceWithName:(nonnull NSString *)resourceName fromPeer:(nonnull MCPeerID *)peerID withProgress:(nonnull NSProgress *)progress {
    //
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler
{
    NSLog(@"xnh: MCSessionDelegate session %p  didReceivecertificate from peer %@", session, peerID.displayName);
    certificateHandler(YES);
}

#pragma mark - MCNearbyServiceBrowserDelegate
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(nonnull MCPeerID *)peerID withDiscoveryInfo:(nullable NSDictionary<NSString *,NSString *> *)info
{
    NSLog(@"xnh: MCNearbyServiceBrowserDelegate browser %p  foundPeer %@ ", browser, peerID.displayName);
    [browser invitePeer:peerID toSession:self.session withContext:nil timeout:10];
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"xnh: MCNearbyServiceBrowserDelegate broser %p  lostPeer %@ ", browser, peerID.displayName);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
- (void)            advertiser:(MCNearbyServiceAdvertiser *)advertiser
  didReceiveInvitationFromPeer:(MCPeerID *)peerID
                   withContext:(nullable NSData *)context
             invitationHandler:(void (^)(BOOL accept, MCSession * __nullable session))invitationHandler
{
    NSLog(@"xnh: MCNearbyServiceAdvertiserDelegate advertiser %p  didReceiveInvitationFrom %@", advertiser, peerID.displayName);
    
    //弹窗提示接收者是否连接session
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"接收到%@的邀请", peerID.displayName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        invitationHandler(YES, self.session);
    }];
    [alert addAction:accept];
    UIAlertAction *reject = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        invitationHandler(NO, self.session);
    }];
    [alert addAction:reject];

    if(self.superVC)
        [self.superVC presentViewController:alert animated:YES completion:nil];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"xnh: MCNearbyServiceAdvertiserDelegate advertiser %p  didNotStartAdvertisingPeer due to %@", advertiser, [error localizedDescription]);
}

@end
