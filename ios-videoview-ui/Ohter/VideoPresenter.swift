//
//  VideoPresenter.swift
//  VideoPlayerDemo
//
//  Created by Kushida　Eiji on 2016/12/04.
//  Copyright © 2016年 Kushida　Eiji. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoViewDataSource {
    func setButtonTitle(title: String)
    func setPlayTime(time: Float)
    func setPlayTimeText(text: String)
    func setSeekBarValue(value: Float)
}

final class VideoPresenter {
    
    var dataSource: VideoViewDataSource?
    var topOf: ViewController?
    
    init(topOf: ViewController?, dataSource: VideoViewDataSource?) {
        self.topOf = topOf
        self.dataSource = dataSource
    }
    
    func setupVideoView(path: String) {
        
        let avAsset = AVURLAsset(url: URL(fileURLWithPath: path),
                                 options: nil)
        let playerItem = AVPlayerItem(asset: avAsset)
        topOf?.videoPlayer = AVPlayer(playerItem: playerItem)
        
        guard let videoPlayer = topOf?.videoPlayer else{
            return
        }
        topOf?.playerView.player = videoPlayer
        dataSource?.setButtonTitle(title: "再生")

        //再生時間を取得する
        let playTime = setupSeekBar(avAsset: avAsset)
        dataSource?.setPlayTime(time: playTime)
        dataSource?.setPlayTimeText(text: "0s / \(Int(playTime))s")
        
        //経過時間を取得する
        setupElapsedTime(videoPlayer: videoPlayer, playTime: playTime)
    }
    
    fileprivate func setupSeekBar(avAsset: AVAsset) -> Float{
        
        let playTime = Float(CMTimeGetSeconds(avAsset.duration))
        topOf?.seekBar.minimumValue = 0
        topOf?.seekBar.maximumValue = playTime
        topOf?.seekBar.addTarget(topOf.self,
                                 action: Selector.onSliderValueChange,
                                 for: .valueChanged)
        return playTime
    }
    
    fileprivate func setupElapsedTime(videoPlayer: AVPlayer, playTime: Float) {
    
        let interval = 1.0
        let time : CMTime = CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC))
        videoPlayer.addPeriodicTimeObserver(forInterval: time,
                                            queue: nil,
                                            using: { [weak self] (time) -> Void in
            
            if let currentItem = videoPlayer.currentItem,
                let maximumValue = self?.topOf?.seekBar.maximumValue,
                let minimumValue = self?.topOf?.seekBar.minimumValue  {
                
                let duration = CMTimeGetSeconds(currentItem.duration)
                let currentTime = CMTimeGetSeconds(videoPlayer.currentTime())
                self?.dataSource?.setPlayTimeText(text: "\(Int(currentTime))s / \(Int(playTime))s")
                
                let value = Float(maximumValue - minimumValue) * Float(currentTime) / Float(duration) + Float(minimumValue)
                self?.dataSource?.setSeekBarValue(value: value)
            }
        })
    }
}
