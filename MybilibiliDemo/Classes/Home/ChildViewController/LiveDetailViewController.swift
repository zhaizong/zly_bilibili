//
//  LiveDetailViewController.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播详情控制器
// @use
// @since 1.0.5
// @author 赵林洋
class LiveDetailViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  var liveSource: BBCLiveSource? {
    didSet {
      guard let liveSource = liveSource else { return }
      _liveSource = liveSource
    }
  }
  
  fileprivate var _playerView: LivePlayerView!
  
  fileprivate var _liveSource: BBCLiveSource!
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get {
      return .allButUpsideDown
    }
  }
  
  override var shouldAutorotate: Bool {
    get {
      return _liveSource.broadcastType != 1
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
    
    _playerView.prepareToPlay()
    UIApplication.shared.isStatusBarHidden = false
    UIApplication.shared.statusBarStyle = .lightContent
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    _playerView.shutdown()
    
    tabBarController?.tabBar.isHidden = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.videoStoryboard().instantiateViewController(withIdentifier: "LiveDetailViewController")
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

extension LiveDetailViewController {
  
  fileprivate func _setupApperance() {
    
    view.backgroundColor = UIColor.white
    
    UIApplication.shared.isStatusBarHidden = true
    
    _playerView = LivePlayerView(frame: .zero)
    _playerView.videoUrl = URL(string: _liveSource.playUrl)
    if _liveSource.broadcastType == 1 {
      _playerView.liveStyle = .phone
    } else {
      _playerView.liveStyle = .normal
    }
    _playerView.scaleMode = .aspectFit
    view.addSubview(_playerView)
    _playerView.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.snp.top)
      make.left.equalTo(self.view.snp.left)
      make.height.equalTo(self._playerView.snp.width).multipliedBy(9.0 / 16.0).priority(750)
    }
    _playerView.livePlayerViewBackClosure = { [weak self] in
      guard let weakSelf = self else { return }
      _ = weakSelf.navigationController?.popViewController(animated: true)
    }
    _playerView.livePlayerViewFullScreenClosure = { [weak self] in
      guard let weakSelf = self else { return }
      weakSelf._playerView.snp.updateConstraints({ (make) in
        make.height.equalTo(BBK_Screen_Height)
      })
    }
  }
  
  
}
