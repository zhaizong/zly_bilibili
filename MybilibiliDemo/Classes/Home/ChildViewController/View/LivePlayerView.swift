//
//  LivePlayerView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit
import IJKMediaFramework

// 直播详情播放器页面
// @use LiveDetailViewController.swift
// @since 1.0.5
// @author 赵林洋
enum LivePlayerFullScreenStyle: Int {
  case none
  case phone // 手机直播
  case normal // 普通横屏
}

class LivePlayerView: UIView {

  // MARK: - Property
  
  var videoUrl: URL? {
    didSet {
      guard let videoUrl = videoUrl else { return }
      
      IJKFFMoviePlayerController.setLogReport(false)
      IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_SILENT)
      IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
      
      _player = IJKFFMoviePlayerController(contentURL: videoUrl, with: nil)
      _player.view.frame = bounds
      _player.scalingMode = scaleMode
      _player.shouldAutoplay = true
      _player.setPauseInBackground(true)
      addSubview(_player.view)
      
      bringSubview(toFront: _livePortraitView)
      
      _setupNotifications()
    }
  }// 视频url
  
  var scaleMode: IJKMPMovieScalingMode! // 视频拉伸模式
  
  var liveStyle: LivePlayerFullScreenStyle = .none {
    didSet {
      _liveLandscapeView = LivePlayerLandscapeView(frame: .zero)
      _liveLandscapeView.isHidden = true
      _liveLandscapeView.delegatePlayer = _player
      addSubview(_liveLandscapeView)
      bringSubview(toFront: _liveLandscapeView)
    }
  } // 视频全屏模式类型
  
  var thumbnailImageAtCurrentTime: UIImage! {
    get {
      guard _player != nil else { return nil }
      return _player.thumbnailImageAtCurrentTime()
    }
  }
  
  var liveSource: BBCLiveSource?
  
  var livePlayerViewBackClosure: (() -> Void)?
  var livePlayerViewFullScreenClosure: (() -> Void)?
  
  fileprivate var _player: IJKMediaPlayback!
  
  fileprivate var _livePortraitView: LivePlayerPortraitView
  
  fileprivate var _liveLandscapeView: LivePlayerLandscapeView
  
  fileprivate var _bufferingTimer: Timer!
  
  fileprivate var _livePlaceholderImageView: UIImageView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _livePortraitView = LivePlayerPortraitView(frame: .zero)
    _liveLandscapeView = LivePlayerLandscapeView(frame: .zero)
    _livePlaceholderImageView = UIImageView(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    _player.view.frame = bounds
    
    _livePortraitView.frame = bounds
    
    if liveStyle == .normal {
      _liveLandscapeView.frame = bounds
    }
    
    layoutIfNeeded()
  }
  
  deinit {
    if _bufferingTimer != nil {
      _bufferingTimer.invalidate()
      _bufferingTimer = nil
    }
    NotificationCenter.default.removeObserver(self)
    UIDevice.current.endGeneratingDeviceOrientationNotifications()
  }
  
  func prepareToPlay() {
    
    _player.prepareToPlay()
  }
  
  func shutdown() {
    
    _player.shutdown()
    _player = nil
    UIApplication.shared.isStatusBarHidden = false
  }
}

extension LivePlayerView {
  
  fileprivate func _setupNotifications() {
    
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    
    NotificationCenter.default.addObserver(self, selector: #selector(_observerDeviceOrientationNotification), name: .UIDeviceOrientationDidChange, object: nil)
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(registerBufferWithNotification(_:)), name: .IJKMPMoviePlayerLoadStateDidChange, object: _player)
  }
  
  @objc fileprivate func _observerDeviceOrientationNotification() {
    
    let orientation = UIDevice.current.orientation
//    let interfaceOrientation = orientation as! UIInterfaceOrientation
    switch orientation {
    case .faceDown:
      debugPrint("手机倒立")
    case .portrait:
      _livePortraitView.isHidden = false
      _liveLandscapeView.isHidden = true
    case .landscapeLeft:
      _livePortraitView.isHidden = true
      _liveLandscapeView.isHidden = false
      UIApplication.shared.isStatusBarHidden = true
    case .landscapeRight:
      _livePortraitView.isHidden = true
      _liveLandscapeView.isHidden = false
      UIApplication.shared.isStatusBarHidden = true
    default:
      break
    }
  }
  
  func registerBufferWithNotification(_ notification: Notification) {
    
    //    释放资源
//    _bufferingTimer.invalidate()
    
    if let object = notification.object {
      let player = object as! IJKFFMoviePlayerController
      if player.loadState == .stalled {
        debugPrint("缓冲开始")
        //        开启定时器
        _bufferingTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(_buffering), userInfo: nil, repeats: true)
        RunLoop.main.add(_bufferingTimer, forMode: .commonModes)
      } else if player.loadState == [.playable, .playthroughOK] {
        debugPrint("缓冲结束")
        if _bufferingTimer != nil {
          _bufferingTimer.invalidate()
        }
      }
    }
  }
  
  @objc fileprivate func _buffering() {
    
    debugPrint("当前缓冲进度为: \(_player?.bufferingProgress)")
  }
  
  fileprivate func _setupApperance() {
    
    _livePlaceholderImageView.image = UIImage(named: "live_biliv_ico")
    addSubview(_livePlaceholderImageView)
    _livePlaceholderImageView.snp.makeConstraints { (make) in
      make.left.top.equalTo(16)
    }
    
    scaleMode = .aspectFill
    liveStyle = .normal
    
    BBKForceRotationScreen.interfaceOrientation(.portrait)
    
    _livePortraitView = LivePlayerPortraitView(frame: .zero)
    addSubview(_livePortraitView)
    _livePortraitView.portraitViewBackButtonClosure = { [weak self] in
      guard let weakSelf = self else { return }
      weakSelf.livePlayerViewBackClosure?()
    }
    _livePortraitView.portraitViewFullScreenClosure = { [weak self] in
      guard let weakSelf = self else { return }
      if weakSelf.liveStyle == .phone {
        weakSelf.livePlayerViewFullScreenClosure?()
      } else if weakSelf.liveStyle == .normal {
        BBKForceRotationScreen.interfaceOrientation(.landscapeRight)
      }
    }
    
  }
  
}
