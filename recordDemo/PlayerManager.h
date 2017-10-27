//
//  PlayerManager.h
//  录音播放录音
//
//  Created by Sunshine on 2017/9/12.
//  Copyright © 2017年 Sunshine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStateFailed,     // 播放失败
    PlayerStateBuffering,  // 缓冲中
    PlayerStatePlaying,    // 播放中
    PlayerStateStopped,    // 停止播放
    PlayerStatePause       // 暂停播放
};

@interface PlayerManager : NSObject

//播放器
@property (strong, nonatomic) AVPlayer * player;
@property (strong, nonatomic) AVPlayerItem * palyItem;

/** 播发器的几种状态 */
@property (nonatomic, assign) PlayerState playState;
/**
 *  监听音频播放结束
 */
@property (copy, nonatomic) void(^audioPlayEnd)(void);
/**
 *  总时间
 */
@property (strong, nonatomic) NSString *totalTime;

/**
 *  获取缓冲时间
 */
@property (assign, nonatomic) CGFloat totalDurationTime;

/**
 *  快速初始化
 */
+(PlayerManager *)initPlay;
/**
 *  播放音频
 *
 *  @param url 音频的url字符串
 */
-(void)playAudioWithUrlStr:(NSString *)url PlayerLayer:(CGRect)layerFrame;
/**
 *  停止播放语音
 */
-(void)stopPalyAudio;

/**
 *  暂停播放语音
 */
-(void)pausePalyAudio;

/**
 *  暂停 to 播放语音
 */
-(void)pauseToPalyAudio;


/**
 *  重置播放器
 */
-(void)resetAudioPlay;


@end
