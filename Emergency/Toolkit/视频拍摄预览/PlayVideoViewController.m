//
//  PlayVideoViewController.m
//  VideoRecord
//
//  Created by guimingsu on 15/4/27.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoViewController ()<UITextFieldDelegate>

@end

@implementation PlayVideoViewController
{
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    AVPlayerItem *playerItem;
    UIImageView* playImg;
}

@synthesize videoURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"预览";
    float videoWidth = _SCREEN_WIDTH;
    
//    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//    playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
     playerItem=[AVPlayerItem playerItemWithURL:videoURL];
    
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, videoWidth, _SCREEN_HEIGHT - 64-120);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [self.view addGestureRecognizer:playTap];
    
    [self pressPlayButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    playImg.center = CGPointMake(_SCREEN_WIDTH/2, playerLayer.frame.size.height/2);
    [playImg setImage:[UIImage imageNamed:@"videoPlay"]];
    [playerLayer addSublayer:playImg.layer];
    playImg.hidden = YES;
    
    UIButton *dismButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    dismButton.center = CGPointMake(_SCREEN_WIDTH/2, _SCREEN_HEIGHT-64-60);
    dismButton.layer.cornerRadius = 4;
    dismButton.layer.borderColor =[UIColor whiteColor].CGColor;
    dismButton.layer.borderWidth = 1;
    [dismButton setTitle:@"取 消" forState:UIControlStateNormal];
    dismButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [dismButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismButton addTarget:self action:@selector(dismClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismButton];
    
}

-(void)playOrPause
{
    
    if (playImg.isHidden) {
        playImg.hidden = NO;
        [player pause];
        
    }else{
        playImg.hidden = YES;
        [player play];
    }
}

- (void)pressPlayButton
{
    [playerItem seekToTime:kCMTimeZero];
    [player play];
}

- (void)playingEnd:(NSNotification *)notification
{
    [self dismClick];
}

- (void)dismClick
{
    [player pause];
    player = nil;
    playerItem = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
