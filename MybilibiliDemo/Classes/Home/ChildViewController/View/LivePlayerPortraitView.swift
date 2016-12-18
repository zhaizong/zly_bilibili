//
//  LivePlayerPortraitView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/9.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播竖屏页面
// @use LivePlayerView.swift
// @since 1.0.5
// @author 赵林洋
class LivePlayerPortraitView: UIView {

  // MARK: - Property
  
  weak var delegatePlayer: IJKMediaPlayback?
  
  var portraitViewBackButtonClosure: (() -> Void)?
  var portraitViewFullScreenClosure: (() -> Void)?
  
  fileprivate lazy var _emitterLayer: CAEmitterLayer = {
    let lazilyCreatedEmitterLayer = CAEmitterLayer()
//    发射器在xy平面的中心位置
    lazilyCreatedEmitterLayer.emitterPosition = CGPoint(x: BBK_Screen_Width - 50, y: BBK_Screen_Height - 50)
//    发射器的尺寸大小
    lazilyCreatedEmitterLayer.emitterSize = CGSize(width: 20, height: 20)
//    渲染模式
    lazilyCreatedEmitterLayer.renderMode = kCAEmitterLayerUnordered
//    开启三维效果
    lazilyCreatedEmitterLayer.preservesDepth = true
    var array: [CAEmitterCell] = []
//    创建粒子
    for index in 1...9 {
//      发射单元
      let stepCell = CAEmitterCell()
//      粒子的创建速率，默认为1/s
      stepCell.birthRate = 5
//      粒子存活时间
      stepCell.lifetime = Float(arc4random_uniform(4) + 1)
//      粒子的生存时间容差
      stepCell.lifetimeRange = 1.5
      
      let image = UIImage(named: "good\(index)_30x30")!
//      粒子显示的内容
      stepCell.contents = image.cgImage
//      粒子的运动速度
      stepCell.velocity = CGFloat(arc4random_uniform(100) + 100)
//      粒子速度的容差
      stepCell.velocityRange = 80
//      粒子在xy平面的发射角度
      stepCell.emissionLongitude = CGFloat(M_PI + M_PI_2)
//      粒子发射角度的容差
      stepCell.emissionRange = CGFloat(M_PI_2 / 6)
//      缩放比例
      stepCell.scale = 0.5
      
      array.append(stepCell)
    }
    lazilyCreatedEmitterLayer.emitterCells = array
    self.layer.insertSublayer(lazilyCreatedEmitterLayer, at: 0)
    return lazilyCreatedEmitterLayer
  }() // 粒子动画
  
  fileprivate var _topImageView: UIImageView
  fileprivate var _bottomImageView: UIImageView
  fileprivate var _overlayView: UIView // 用来响应事件的View
  fileprivate var _backButton: UIButton // 返回按钮
  fileprivate var _smallPauseButton: UIButton // 小型暂停按钮
  fileprivate var _normalPauseButton: UIButton // 大型暂停按钮
  fileprivate var _fullScreenButton: UIButton // 全屏按钮
  
  fileprivate var _volumeSlider: UISlider! // 音量滑杆
  
  fileprivate var _isHiddenOverlay: Bool // 是否显示覆盖层
  fileprivate var _isVolume: Bool // 是否在调节音量
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _topImageView = UIImageView(frame: .zero)
    _bottomImageView = UIImageView(frame: .zero)
    _overlayView = UIView(frame: .zero)
    _backButton = UIButton(type: .custom)
    _smallPauseButton = UIButton(type: .custom)
    _normalPauseButton = UIButton(type: .custom)
    _fullScreenButton = UIButton(type: .custom)
//    _volumeSlider = UISlider(frame: .zero)
    
    _isHiddenOverlay = true
    _isVolume = false
    super.init(frame: frame)
    _setupApperance()
    _layoutSubviews()
    
    _setupGesture()
    
    _autoFadeOutOverlay()
    
    _configureVolume()
    
    // TODO: - 配置亮度View
    
    _emitterLayer.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    _emitterLayer.isHidden = true
    
    if st_height == BBK_Screen_Height {
      _emitterLayer.isHidden = false
    } else {
      _emitterLayer.isHidden = true
    }
  }

}

extension LivePlayerPortraitView {
  
  @objc fileprivate func _backButtonDidClick(_ sender: UIButton) {
    
    portraitViewBackButtonClosure?()
  }
  
  @objc fileprivate func _smallPauseButtonDidClick(_ sender: UIButton) {
    
    _changePlayStatus()
  }
  
  @objc fileprivate func _normalPauseButtonDidClick(_ sender: UIButton) {
    
    _changePlayStatus()
  }
  
  @objc fileprivate func _fullScreenButtonDidClick(_ sender: UIButton) {
    
    portraitViewFullScreenClosure?()
  }
  
  fileprivate func _changePlayStatus() {
    
    guard let delegatePlayer = delegatePlayer else { return }
    if delegatePlayer.isPlaying() {
      delegatePlayer.pause()
    } else {
      delegatePlayer.play()
    }
    _smallPauseButton.isSelected = delegatePlayer.isPlaying()
    _normalPauseButton.isSelected = delegatePlayer.isPlaying()
  }
  
  @objc fileprivate func _tapAction(_ tapGesture: UITapGestureRecognizer) {
    
    guard tapGesture.state == .recognized else { return }
    if _isHiddenOverlay == true {
      _hideOverlay()
    } else {
      _showOverlay()
    }
  }
  
  @objc fileprivate func _doubleTapAction(_ tapGesture: UITapGestureRecognizer) {
    
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
  
}

extension LivePlayerPortraitView {
  
  @objc fileprivate func _hideOverlay() {
    
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
    // TODO: - 使用这个category的应用不会随着手机静音键打开而静音, 可在手机静音下播放声音. 后面再完善.
    /*do {
     let success = try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
     } catch let error {
     debugPrint(error)
     }*/
  }
  
}

extension LivePlayerPortraitView {
  
  fileprivate func _setupGesture() {
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(_tapAction(_:)))
    
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(_doubleTapAction(_:)))
    doubleTap.numberOfTapsRequired = 2
    
    addGestureRecognizer(tap)
    addGestureRecognizer(doubleTap)
    
    tap.require(toFail: doubleTap)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(_panAction(_:)))
    addGestureRecognizer(pan)
  }
  
  fileprivate func _setupApperance() {
    
    _topImageView.image = UIImage(named: "palyer_top_bg")
    
    _bottomImageView.image = UIImage(named: "palyer_bottom_bg")
    
    _backButton.frame = .zero
    _backButton.setImage(UIImage(named: "common_backShadow"), for: .normal)
    _backButton.addTarget(self, action: #selector(_backButtonDidClick(_:)), for: .touchUpInside)
    
    _smallPauseButton.frame = .zero
    _smallPauseButton.setImage(UIImage(named: "player_pause_bottom_window"), for: .normal)
    _smallPauseButton.addTarget(self, action: #selector(_smallPauseButtonDidClick(_:)), for: .touchUpInside)
    
    _normalPauseButton.frame = .zero
    _normalPauseButton.setImage(UIImage(named: "player_pause"), for: .normal)
    _normalPauseButton.addTarget(self, action: #selector(_smallPauseButtonDidClick(_:)), for: .touchUpInside)
    
    _fullScreenButton.frame = .zero
    _fullScreenButton.setImage(UIImage(named: "player_fullScreen_iphone"), for: .normal)
    _fullScreenButton.addTarget(self, action: #selector(_fullScreenButtonDidClick(_:)), for: .touchUpInside)
    
    addSubview(_overlayView)
    _overlayView.addSubview(_backButton)
    _overlayView.addSubview(_smallPauseButton)
    _overlayView.addSubview(_normalPauseButton)
    _overlayView.addSubview(_fullScreenButton)
//    addSubview(_volumeSlider)
    _overlayView.addSubview(_topImageView)
    _overlayView.addSubview(_bottomImageView)
  }
  
  fileprivate func _layoutSubviews() {
    
    _overlayView.snp.makeConstraints { (make) in
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
      make.top.equalTo(snp.top)
      make.bottom.equalTo(snp.bottom)
    }
    
    _topImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(_overlayView.snp.leading)
      make.trailing.equalTo(_overlayView.snp.trailing)
      make.top.equalTo(_overlayView.snp.top)
      make.height.equalTo(30)
    }
    
    _backButton.snp.makeConstraints { (make) in
      make.leading.equalTo(12)
      make.top.equalTo(_topImageView.snp.bottom).offset(-8)
      make.size.equalTo(44)
    }
    
    _bottomImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.bottom.equalTo(0)
      make.height.equalTo(30)
    }
    
    _smallPauseButton.snp.makeConstraints { (make) in
      make.leading.equalTo(16)
      make.bottom.equalTo(16)
    }
    
    _normalPauseButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(16)
      make.width.equalTo(50)
      make.height.equalTo(45)
    }
    
    _fullScreenButton.snp.makeConstraints { (make) in
      make.size.equalTo(44)
      make.top.equalTo(_normalPauseButton.snp.bottom).offset(16)
      make.bottom.equalTo(0)
      make.centerX.equalTo(_normalPauseButton.snp.centerX)
    }
    
  }
  
}
