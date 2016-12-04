//
//  ViewController.swift
//  VideoPlayerDemo
//
//  Created by Kushida　Eiji on 2015/12/05.
//  Copyright © 2015年 Kushida　Eiji. All rights reserved.
//

import UIKit
import AVFoundation

extension Selector {
    
    static let onVideoEnd = #selector(ViewController.onVideoEnd)
    static let onSliderValueChange = #selector(ViewController.onSliderValueChange)
}

final class ViewController: UIViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var button: UIButton!    
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var playtimeLabel: UILabel!
    
    var videoPlayer:AVPlayer!
    var isPlay = false
    var playTime = Float(0)
    var presenter: VideoPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addVideoEnd()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeVideoEnd()
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if isPlay {
            videoPlayer.pause()
            setButtonTitle(title: "再生")
        } else {
            videoPlayer.play()
            setButtonTitle(title: "停止")
        }
        
        isPlay = !isPlay
    }
    
    //MARK:- Level2
    fileprivate func setup() {
        setupPresenter()
        setupVideoView()
    }
    
    fileprivate func addVideoEnd() {
        NotificationCenter.default.addObserver(self,
                                               selector: Selector.onVideoEnd,
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    fileprivate func removeVideoEnd() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
        
    }
    
    fileprivate func setupPresenter() {
        presenter = VideoPresenter(topOf: self, dataSource: self)
    }
    
    fileprivate func setupVideoView() {
        
        guard let path = Bundle.main.path(forResource: "dnld", ofType: "mp4") else {
            return
        }
        presenter?.setupVideoView(path: path)
    }
    
    
    //MARK:- Video Callbak
    func onSliderValueChange(_ sender : UISlider){
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(seekBar.value), Int32(NSEC_PER_SEC)))
    }
    
    func onVideoEnd() {
        
        setButtonTitle(title: "再生")
        setPlayTimeText(text: "0s / \(Int(playTime))s")
        setSeekBarValue(value: 0)
    }
}

extension ViewController: VideoViewDataSource {

    func setButtonTitle(title: String) {
        button.setTitle(title, for: UIControlState())
    }
    
    func setPlayTime(time: Float) {
        playTime = time
    }
    
    func setPlayTimeText(text: String) {
        playtimeLabel.text = text
    }
    
    func setSeekBarValue(value: Float) {
        seekBar.value = value
    }
}
