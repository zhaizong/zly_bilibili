//
//  VideoPlayerViewController.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/11/27.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit
import IJKMediaFramework

// 视频播放控制器
// @use 用于番剧详情页 BangumiDetailViewController.swift
// @since 1.0.5
// @author 赵林洋
class VideoPlayerViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  var urlString: String? {
    didSet {
      guard let urlString = urlString, urlString != "" else { return }
      _url = URL(string: urlString)
    }
  }
  
  fileprivate var _url: URL!
  
  fileprivate var _player: IJKMediaPlayback!
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get {
      return .landscape
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    _setupApperance()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIApplication.shared.statusBarStyle = .lightContent
    UIApplication.shared.isStatusBarHidden = false
    
    _installMovieNotificationObservers()
    
//    准备播放
    if _player.isPlaying() == true {
      _player.prepareToPlay()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    _player.shutdown()
    
    UIApplication.shared.isStatusBarHidden = false
    UIApplication.shared.statusBarStyle = .default
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.videoStoryboard().instantiateViewController(withIdentifier: "VideoPlayerViewController")
    return vc as! T
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}

extension VideoPlayerViewController {
  
  fileprivate func _installMovieNotificationObservers() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(_playerLoadStateDidChangeNotification(_:)), name: .IJKMPMoviePlayerLoadStateDidChange, object: _player)
    
  }
  
  @objc fileprivate func _playerLoadStateDidChangeNotification(_ notification: Notification) {
    
    let loadState = _player.loadState
    if loadState == .playthroughOK {
      debugPrint("loadState == playthroughOK: \(loadState)")
    } else if loadState == .stalled {
      debugPrint("loadState == stalled: \(loadState)")
    } else {
      debugPrint("loadState == ???: \(loadState)")
    }
  }
  
}

extension VideoPlayerViewController {
  
  fileprivate func _setupApperance() {
    
//    设置log信息打印
    IJKFFMoviePlayerController.setLogReport(true)
//    设置log等级
    IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_DEBUG)
//    检查当前FFmpeg版本是否匹配
    IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
//    IJKFFOptions 是对视频的配置信息
    if let options = IJKFFOptions.byDefault() {
//      是否要展示配置信息指示器(默认为NO)
      options.showHudView = false
//      配置Player
      _player = IJKFFMoviePlayerController(contentURL: _url, with: options)
      _player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      _player.view.frame = view.bounds
      _player.scalingMode = .aspectFit
      _player.shouldAutoplay = true
      view.autoresizesSubviews = true
      view.addSubview(_player.view)
      
//      视频控制界面
//      let videoControl = VideoPlayerControlView(frame: view.bounds)
//      videoControl.delegatePlayer = _player
//      view.addSubview(videoControl)
//      videoControl.backButtonTouchUpInsideClosure = { [weak self] in
//        guard let weakSelf = self else { return }
//        weakSelf.dismiss(animated: true, completion: nil)
//      }
    }
    
  }
  
}
