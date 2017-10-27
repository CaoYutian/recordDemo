//
//  ViewController.m
//  录音播放录音
//
//  Created by Sunshine on 2017/9/11.
//  Copyright © 2017年 Sunshine. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RecorderManager.h"
#import "PlayerManager.h"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempRecord.data"]

@interface ViewController ()

//播放器
//@property (strong, nonatomic) AVPlayer * player;
@property (strong, nonatomic) AVPlayerItem * palyItem;

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVPlayer *player; //播放器

@property (strong, nonatomic) RecorderManager * recorderJIa;
@property (nonatomic, strong) PlayerManager *playJIa;

@property (nonatomic,strong) NSString *filePath;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _recorderJIa = [RecorderManager initRecorder];
    _recorderJIa.recordName = @"kkk.aac";
    
}

#pragma mark 开始录音
- (IBAction)startRecord:(id)sender {
    [_recorderJIa startRecorder];
}

#pragma mark 停止录音
- (IBAction)stopRecord:(id)sender {
    [_recorderJIa stopRecorder];
}

#pragma mark 暂停录音
- (IBAction)suspendedRecord:(id)sender {
    [_recorderJIa pauseRecorder];
}

#pragma mark 继续录音
- (IBAction)ContinueRecord:(id)sender {
    [_recorderJIa pauseToStartRecorder];
}

#pragma mark 播放录音
- (IBAction)playRecord:(UIButton *)sender {
    
//    NSURL * audioUrl  = [NSURL fileURLWithPath:[RecordFile stringByAppendingString:@"kkk.aac"]];
//    _palyItem = [[AVPlayerItem alloc]initWithURL:audioUrl];
//    _player = [[AVPlayer alloc] initWithPlayerItem:_palyItem];
//    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//    [sender.layer addSublayer:playerLayer];
//    [_player play];
    
    _playJIa = [PlayerManager initPlay];
    [_playJIa playAudioWithUrlStr:[RecordFile stringByAppendingString:@"kkk.aac"] PlayerLayer:sender.frame];

}

#pragma mark 暂停播放
- (IBAction)suspendedPlay:(id)sender {
    NSLog(@"暂停播放");
    [_playJIa pausePalyAudio];
}

#pragma mark 添加背景音乐
- (IBAction)syntheticRecord:(id)sender {
    NSLog(@"合成录音");
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"醉赤壁" ofType:@"mp3"];
    NSURL *audioUrl  = [NSURL fileURLWithPath:[RecordFile stringByAppendingString:@"kkk.aac"]];
    NSURL *audioUrl2 = [NSURL fileURLWithPath:audioPath];
    
    AVURLAsset *audioAsset = [AVURLAsset assetWithURL:audioUrl];
    AVURLAsset *audioAsset2 = [AVURLAsset assetWithURL:audioUrl2];

    AVMutableComposition *compostion = [AVMutableComposition composition];
    AVMutableCompositionTrack *video = [compostion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    [video insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:[audioAsset2 tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:nil];
    AVMutableCompositionTrack *video2 = [compostion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    [video2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:nil];
    
    /*
     批量插入音轨到文件最后
     CMTimeRange range = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
     [video insertTimeRanges:@[[NSValue valueWithCMTimeRange:range],[NSValue valueWithCMTimeRange:range]] ofTracks:@[[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject,[audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject] atTime:kCMTimeZero error:nil];
     */
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:compostion presetName:AVAssetExportPresetAppleM4A];
    NSString *outPutFilePath = [[self.filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Audio.m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];
    session.outputFileType = @"com.apple.m4a-audio";
    session.shouldOptimizeForNetworkUse = YES;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath]) {
            // 调用播放方法
            [self playAudio:[NSURL fileURLWithPath:outPutFilePath]];
        }
        else {
            NSLog(@"输出错误");
        }
    }];

}

- (void)playAudio:(NSURL *)url {
    // 传入地址
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    // 播放器
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    // 播放器layer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.frame;
    // 视频填充模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 添加到imageview的layer上
    [self.view.layer addSublayer:playerLayer];
    // 隐藏提示框 开始播放
    // 播放
    [player play];
}

- (NSString *)filePath
{
    if (!_filePath)
    {
        _filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        _filePath = [_filePath stringByAppendingPathComponent:@"user"];
        NSFileManager *manage = [NSFileManager defaultManager];
        if ([manage createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            _filePath = [_filePath stringByAppendingPathComponent:@"testAudio.aac"];
        }
    }
    
    return _filePath;
}


- (IBAction)deleteRecord:(id)sender {
    [_recorderJIa deleteRecord];
}

@end
