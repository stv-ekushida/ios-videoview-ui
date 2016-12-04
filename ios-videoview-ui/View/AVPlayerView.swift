//
//  AVPlayerView.swift
//  VideoPlayerDemo
//
//  Created by Kushida　Eiji on 2015/12/05.
//  Copyright © 2015年 Kushida　Eiji. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    
    var player: AVPlayer {
        get {
            let layer = self.layer as! AVPlayerLayer
            return layer.player!
        }
        set(newValue) {
            let layer = self.layer as! AVPlayerLayer
            layer.player = newValue
        }
    }
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
    
    func setVideoFillMode(_ mode: String) {
        let layer = self.layer as! AVPlayerLayer
        layer.videoGravity = mode
    }
}
