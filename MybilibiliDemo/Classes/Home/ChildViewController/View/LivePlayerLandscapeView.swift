//
//  LivePlayerLandscapeView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/10.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播横屏页面
// @use LivePlayerView.swift
// @since 1.0.5
// @author 赵林洋
class LivePlayerLandscapeView: UIView {

  // MARK: - Property
  
  weak var delegatePlayer: IJKMediaPlayback?
  
  var landscapeViewSwitchPortraitClosure: ((_ landscapeView: LivePlayerLandscapeView) -> Void)?
  
  fileprivate var _overlayView: UIView
  
  fileprivate var _topView: UIVisualEffectView
  fileprivate var _bottomView: UIVisualEffectView
  fileprivate var _gifView: UIVisualEffectView
  
  fileprivate var _titleLabel: UILabel // 直播标题标签
  
  fileprivate var _detailLabel: UILabel // 详情标签（xxxx人正在围观）
  
  fileprivate var _portraitButton: UIButton // 转换为竖屏按钮
  
  fileprivate var _backgroundPlayButton: UIButton // 后台播放按钮
  
  fileprivate var _qualityButton: UIButton // 调节画质按钮
  
  fileprivate var _scaleButton: UIButton // 屏幕比例按钮
  
  fileprivate var _sendGiftButton: UIButton // 送礼物按钮
  
  fileprivate var _shareButton: UIButton // 分享按钮
  
  fileprivate var _settingButton: UIButton // 设置按钮
  
  fileprivate var _playButton: UIButton // 播放按钮
  
  fileprivate var _danmakuButton: UIButton // 弹幕按钮
  
  fileprivate var _addDanmakuButton: UIButton // 添加弹幕按钮
  
  fileprivate var _muteButton: UIButton // 静音按钮 
  
  fileprivate var _lockButton: UIButton // 锁屏按钮
  
  fileprivate var _volumeSlider: UISlider! // 音量滑杆
  
  fileprivate var _isHiddenOverlay: Bool // 是否显示覆盖层
  
  fileprivate var _isVolume: Bool // 是否在调节音量
  
  fileprivate var _currentVolume: CGFloat = 0 // 记录当前音量

  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _overlayView = UIView(frame: .zero)
    _topView = UIVisualEffectView(frame: .zero)
    _bottomView = UIVisualEffectView(frame: .zero)
    _gifView = UIVisualEffectView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _detailLabel = UILabel(frame: .zero)
    _portraitButton = UIButton(type: .custom)
    _backgroundPlayButton = UIButton(type: .custom)
    _qualityButton = UIButton(type: .custom)
    _scaleButton = UIButton(type: .custom)
    _sendGiftButton = UIButton(type: .custom)
    _shareButton = UIButton(type: .custom)
    _settingButton = UIButton(type: .custom)
    _playButton = UIButton(type: .custom)
    _danmakuButton = UIButton(type: .custom)
    _addDanmakuButton = UIButton(type: .custom)
    _muteButton = UIButton(type: .custom)
    _lockButton = UIButton(type: .custom)
    _isHiddenOverlay = true
    _isVolume = false
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    guard let keyPath = keyPath, keyPath != "" else { return }
    if keyPath == "outputVolume" {
      let outputVolume = AVAudioSession.sharedInstance().outputVolume
      if outputVolume == 0 {
        _muteButton.isSelected = true
      } else {
        _currentVolume = CGFloat(outputVolume)
        _muteButton.isSelected = false
      }
    }
  }
}

extension LivePlayerLandscapeView {
  
  @objc fileprivate func _palyButtonDidClick(_ sender: UIButton) {
    
   _changePlayStatus()
  }
  
  @objc fileprivate func _portraitButtonDidClick(_ sender: UIButton) {
    
    landscapeViewSwitchPortraitClosure?(self)
  }
  
  @objc fileprivate func _muteButtonDidClick(_ sender: UIButton) {
    
    if _muteButton.isSelected == true {
      _volumeSlider.value = Float(_currentVolume)
    } else {
      _volumeSlider.value = 0
    }
    _muteButton.isSelected = !_muteButton.isSelected
  }
  
  fileprivate func _changePlayStatus() {
    
    guard let delegatePlayer = delegatePlayer else { return }
    if delegatePlayer.isPlaying() {
      delegatePlayer.pause()
    } else {
      delegatePlayer.play()
    }
    _playButton.isSelected = delegatePlayer.isPlaying()
  }
  
  @objc fileprivate func _tapAction(_ tapGesture: UITapGestureRecognizer) {
    
    guard tapGesture.state == .recognized else { return }
    if _isHiddenOverlay == true {
      _hideOverlay()
    } else {
      _showOverlay()
    }
  }
  
  @objc fileprivate func _doubleTapAction(_ doubleTapGesture: UITapGestureRecognizer) {
    
    _showOverlay()
    
    _changePlayStatus()
  }
  
  @objc fileprivate func _panAction(_ panGesture: UIPanGestureRecognizer) {
    
    let locationPoint = panGesture.location(in: panGesture.view)
    let veloctyPoint = panGesture.velocity(in: panGesture.view)
    switch panGesture.state {
    case .began:
      let x = fabs(veloctyPoint.x)
      let y = fabs(veloctyPoint.y)
      if x < y {
        if locationPoint.x > st_width / 2 {
          _isVolume = true
        } else {
          _isVolume = false
        }
      }
    case .changed:
      _verticalMoved(veloctyPoint.y)
    case .ended:
      _isVolume = false
    default:
      break
    }
  }
  
  fileprivate func _verticalMoved(_ value: CGFloat) {
    
    if _isVolume == true {
      _volumeSlider.value = _volumeSlider.value - Float(value) / 10000
    } else {
      UIScreen.main.brightness = UIScreen.main.brightness - value / 10000
    }
  }
  
  @objc fileprivate func _hideOverlay() {
    
    UIApplication.shared.isStatusBarHidden = true
    
    guard _isHiddenOverlay == true else { return }
    
    UIView.animate(withDuration: 0.35, animations: {
      self._overlayView.alpha = 0
    }, completion: { (finished: Bool) in
      self._isHiddenOverlay = false
    })
  }
  
  fileprivate func _showOverlay() {
    
    UIApplication.shared.isStatusBarHidden = false
    UIApplication.shared.statusBarStyle = .lightContent
    
    guard _isHiddenOverlay == false else { return }
    _isHiddenOverlay = true
    UIView.animate(withDuration: 0.35, animations: {
      self._overlayView.alpha = 1
    }, completion: { (finished: Bool) in
      self._autoFadeOutOverlay()
    })
  }
  
  fileprivate func _autoFadeOutOverlay() {
    
    guard _isHiddenOverlay == true else { return }
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(_hideOverlay), object: nil)
    perform(#selector(_hideOverlay), with: nil, afterDelay: 3.0)
  }
  
  fileprivate func _configureVolume() {
    
    let volumeView = MPVolumeView(frame: .zero)
    _volumeSlider = nil
    for view in volumeView.subviews {
      if view.self.description == "MPVolumeSlider" {
        _volumeSlider = view as! UISlider
        break
      }
    }
    
    NotificationCenter.default.addObserver(AVAudioSession.sharedInstance(), forKeyPath: "outputVolume", options: .new, context: nil)
    
    // TODO: - 使用这个category的应用不会随着手机静音键打开而静音, 可在手机静音下播放声音. 后面再完善.
    /*do {
     let success = try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
     } catch let error {
     debugPrint(error)
     }*/
  }
  
}

extension LivePlayerLandscapeView {
  
  fileprivate func _setupGesture() {
    
    let tap = UITapGestureRecognizer(target: self, action: nil)
    
    let doubleTap = UITapGestureRecognizer(target: self, action: nil)
    doubleTap.numberOfTapsRequired = 2
    
    addGestureRecognizer(tap)
    addGestureRecognizer(doubleTap)
    
    tap.require(toFail: doubleTap)
    
    let pan = UIPanGestureRecognizer(target: self, action: nil)
    addGestureRecognizer(pan)
  }
  
  fileprivate func _setupApperance() {
    
    _isHiddenOverlay = true
    _overlayView.alpha = 1
    
    _topView.effect = UIBlurEffect(style: .dark)
    _topView.contentView.isOpaque = true
    _bottomView.effect = UIBlurEffect(style: .dark)
    _gifView.effect = UIBlurEffect(style: .dark)
    // topView
    _portraitButton.setImage(UIImage(named: "icnav_back_light"), for: .normal)
    _portraitButton.addTarget(self, action: #selector(_portraitButtonDidClick(_:)), for: .touchUpInside)
    
    _titleLabel.text = "我是标题[]~(￣▽￣)~*"
    _titleLabel.textColor = UIColor.white
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    _titleLabel.textAlignment = .left
    
    _backgroundPlayButton.setTitle("后台播放", for: .normal)
    _backgroundPlayButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    
    _qualityButton.setTitle("超清", for: .normal)
    _qualityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    
    _scaleButton.setTitle("比例", for: .normal)
    _scaleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    // bottomView
    _shareButton.setImage(UIImage(named: "player_share_icon"), for: .normal)
    
    _detailLabel.text = "xxxx人正在围观"
    _detailLabel.textColor = UIColor.white
    _detailLabel.font = UIFont.systemFont(ofSize: 14)
    _detailLabel.textAlignment = .left
    
    _settingButton.setImage(UIImage(named: "player_panel_setup"), for: .normal)
    
    _danmakuButton.setImage(UIImage(named: "icmpv_toggle_danmaku_hided_light"), for: .normal)
    _addDanmakuButton.setImage(UIImage(named: "icmpv_add_danmaku_light"), for: .normal)
    
    _playButton.setImage(UIImage(named: "player_pause_bottom_window"), for: .normal)
    _playButton.setImage(UIImage(named: "player_play_bottom_window"), for: .selected)
    _playButton.addTarget(self, action: #selector(_palyButtonDidClick(_:)), for: .touchUpInside)
    
    _muteButton.setImage(UIImage(named: "icmpv_volume_light"), for: .normal)
    _muteButton.addTarget(self, action: #selector(_muteButtonDidClick(_:)), for: .touchUpInside)
    
    _lockButton.setImage(UIImage(named: "player_lock"), for: .normal)
    
    _sendGiftButton.setImage(UIImage(named: "player_live_sendGiftButton"), for: .normal)
    
    addSubview(_overlayView)
    _overlayView.addSubview(_topView)
    _overlayView.addSubview(_bottomView)
    _overlayView.addSubview(_gifView)
    
    _topView.addSubview(_portraitButton)
    _topView.addSubview(_titleLabel)
    _topView.addSubview(_backgroundPlayButton)
    _topView.addSubview(_qualityButton)
    _topView.addSubview(_scaleButton)
    
    _bottomView.addSubview(_shareButton)
    _bottomView.addSubview(_detailLabel)
    _bottomView.addSubview(_settingButton)
    _bottomView.addSubview(_danmakuButton)
    _bottomView.addSubview(_addDanmakuButton)
    _bottomView.addSubview(_playButton)
    _bottomView.addSubview(_muteButton)
    _bottomView.addSubview(_lockButton)
    
    _gifView.addSubview(_sendGiftButton)
  }
  
  fileprivate func _layoutSubviews() {
    
    _overlayView.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.bottom.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
    }
    
    _topView.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(64)
    }
    _portraitButton.snp.makeConstraints { (make) in
      make.leading.equalTo(0)
      make.bottom.equalTo(0)
      make.size.equalTo(44)
    }
    _titleLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(_portraitButton.snp.trailing).offset(8)
      make.centerY.equalTo(_portraitButton.snp.centerY)
    }
    _scaleButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(16)
      make.centerY.equalTo(_titleLabel.snp.centerY)
    }
    _qualityButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(_scaleButton.snp.leading).offset(-16)
      make.centerY.equalTo(_titleLabel.snp.centerY)
    }
    _backgroundPlayButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(_qualityButton.snp.leading).offset(-16)
      make.centerY.equalTo(_titleLabel.snp.centerY)
    }
    
    _bottomView.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(44)
    }
    _shareButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.leading.equalTo(16)
    }
    _detailLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.leading.equalTo(_shareButton.snp.trailing).offset(8)
    }
    _playButton.snp.makeConstraints { (make) in
      make.center.equalTo(0)
      make.size.equalTo(40)
    }
    _danmakuButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.size.equalTo(44)
      make.trailing.equalTo(_playButton.snp.leading).offset(-8)
    }
    _settingButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.size.equalTo(44)
      make.trailing.equalTo(_danmakuButton.snp.leading).offset(-8)
    }
    _addDanmakuButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.size.equalTo(44)
      make.leading.equalTo(_playButton.snp.trailing).offset(8)
    }
    _muteButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.size.equalTo(44)
      make.leading.equalTo(_addDanmakuButton.snp.trailing).offset(8)
    }
    _lockButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.size.equalTo(44)
      make.trailing.equalTo(0)
    }
    
    _gifView.snp.makeConstraints { (make) in
      make.trailing.equalTo(-4)
      make.size.equalTo(64)
      make.bottom.equalTo(_bottomView.snp.top).offset(-4)
    }
    _sendGiftButton.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.bottom.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
    }
    
  }
  
}
