//
//  VideoPlayerControlView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/11/25.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit
import IJKMediaFramework

// 视频播放控制界面
// @use
// @since 1.0.5
// @author 赵林洋
fileprivate enum PanDirection: Int {
  case horizontalMoved // 水平
  case verticalMoved // 垂直
}

fileprivate struct Commons {
  static let transValue: CGFloat = 180.0
}

class VideoPlayerControlView: UIView {

  // MARK: - IBOutlet
  
  @IBOutlet var videoPlayerControlMainView: UIView!
  
  @IBOutlet weak var overlayView: UIView! // 覆盖层
  
  /*竖屏*/
  
  @IBOutlet weak var smallPlayButtonPortrait: UIButton! // 竖屏播放按钮
  @IBOutlet weak var playButtonPortrait: UIButton! // 竖屏播放按钮(大)
  @IBOutlet weak var fullScreenPortrait: UIButton! // 竖屏全屏按钮
  @IBOutlet weak var backButtonPortrait: UIButton! // 竖屏返回按钮
  
  /*横屏*/
  
  @IBOutlet weak var playButtonLandscape: UIButton! // 横屏播放按钮
  @IBOutlet weak var slider: UISlider! // 横屏滑杆
  @IBOutlet weak var currentPlayerTimeLabelLandscape: UILabel! // 横屏当前播放时间标签
  @IBOutlet weak var totalPlayerTimeLabelLandscape: UILabel! // 横屏总播放时间标签
  @IBOutlet weak var progressViewLandscape: UIProgressView! // 横屏进度条
  @IBOutlet weak var backButtonLandscape: UIButton! // 横屏返回按钮
  
  
  
  // MARK: - Property
  
  var urlString: String? { // 用于普通投稿视频
    didSet {
      guard let urlString = urlString, urlString != "" else { return }
      
      IJKFFMoviePlayerController.setLogReport(false)
      IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_DEBUG)
      IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
      if let options = IJKFFOptions.byDefault() {
        if let url = URL(string: urlString) {
          _player = IJKFFMoviePlayerController(contentURL: url, with: options)
          _player.view.frame = bounds
          _player.scalingMode = .aspectFit
          _player.shouldAutoplay = true
          _player.setPauseInBackground(true)
          addSubview(_player.view)
          
          delegatePlayer = _player
          _player.pause()
        }
      }
    }
  }
  
  var backButtonTouchUpInsideClosure: (() -> Void)?
  
  weak var delegatePlayer: IJKMediaPlayback?
  
  fileprivate var _volumeViewSlider: UISlider! // 音量滑杆
  
  fileprivate var _isShowOverlay: Bool! // 是否显示覆盖层
  
  fileprivate var _isVolume: Bool! // 是否在调节音量
  
  fileprivate var _panDirection: PanDirection! // 保存滑动方向枚举值
  
  fileprivate var _sumTime: TimeInterval! // 用来保存快进的总时长
  
  fileprivate var _beginTime: TimeInterval! // 用来保存拖拽的起始时间
  
  fileprivate var _timer: Timer! // 计时器
  
  fileprivate var _bufferingTimer: Timer! // 缓存进度计时器
  
  fileprivate var _speedView: AdjustSpeedView! // 调节速度View
  
  fileprivate var _player: IJKMediaPlayback!

  // MARK: - Lifecycle
  
//  xib 加载完成后 与 fileOwner 建立连接调用
  override func awakeFromNib() {
    super.awakeFromNib()
    
    _isShowOverlay = true
    
    overlayView.alpha = 1
    
    _setupGesture()
    
//    _autoFadeOutOverlay()
    
    _configureVolume()
    
    // TODO: - 设置亮度View
    
//    设置调节速度View
    _speedView = AdjustSpeedView(frame: .zero)
    _speedView.layer.cornerRadius = 8
    _speedView.layer.masksToBounds = true
    addSubview(_speedView)
    _speedView.snp.makeConstraints { (make) in
      make.width.equalTo(150)
      make.height.equalTo(110)
      make.center.equalTo(_speedView.superview!)
    }
    _speedView.isHidden = true
    
    _setupTimer()
    
//    滑杆
    slider.value = 0
    slider.setThumbImage(UIImage(named: "icmpv_thumb_light"), for: .normal)
    
    smallPlayButtonPortrait.addTarget(self, action: #selector(_changePlayStatus), for: .touchUpInside)
    playButtonPortrait.addTarget(self, action: #selector(_changePlayStatus), for: .touchUpInside)
    playButtonLandscape.addTarget(self, action: #selector(_changePlayStatus), for: .touchUpInside)
    
    fullScreenPortrait.addTarget(self, action: #selector(_fullScreenButtonDidClick(_:)), for: .touchUpInside)
    
    backButtonPortrait.addTarget(self, action: #selector(_backButtonDidClick(_:)), for: .touchUpInside)
    backButtonLandscape.addTarget(self, action: #selector(_backButtonDidClick(_:)), for: .touchUpInside)
    
    
//    注册缓冲的通知
    NotificationCenter.default.addObserver(self, selector: #selector(registerBufferWithNotification(_:)), name: .IJKMPMoviePlayerLoadStateDidChange, object: nil)
  }
  
//  xib 加载时调用
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    videoPlayerControlMainView = Bundle.main.loadNibNamed("VideoPlayerControlView", owner: self, options: nil)?.last as! UIView!
    addSubview(videoPlayerControlMainView)
    
  }
  
  deinit {
    _timer.invalidate()
    _bufferingTimer.invalidate()
    _timer = nil
    _bufferingTimer = nil
    NotificationCenter.default.removeObserver(self)
  }
  
}

extension VideoPlayerControlView {
  
  func prepareToPlay() {
    
    _player.prepareToPlay()
  }
  
  func shutdown() {
    
    _player.shutdown()
    _player = nil
    UIApplication.shared.isStatusBarHidden = false
  }
  
  @objc fileprivate func _backButtonDidClick(_ sender: UIButton) {
    
    if BBKForceRotationScreen.isOrientationLandscape() == true {
      BBKForceRotationScreen.interfaceOrientation(.portrait)
    } else {
      backButtonTouchUpInsideClosure?()
      delegatePlayer?.stop()
    }
  }
  
  @objc fileprivate func _fullScreenButtonDidClick(_ sender: UIButton) {
    
    BBKForceRotationScreen.interfaceOrientation(.landscapeRight)
  }
  
}

extension VideoPlayerControlView {
  
  fileprivate func _setupGesture() {
    
//    单击
    let tap = UITapGestureRecognizer(target: self, action: #selector(_tapAction(_:)))
    addGestureRecognizer(tap)
    
//    双击(播放/暂停)
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(_doubleTapAction(_:)))
    doubleTap.numberOfTapsRequired = 2
    addGestureRecognizer(doubleTap)
    
    tap.require(toFail: doubleTap)
    
//    添加平移手势，用来控制音量、亮度、快进快退
    let pan = UIPanGestureRecognizer(target: self, action: #selector(_panAction(_:)))
    addGestureRecognizer(pan)
  }
  
//  自动延迟隐藏覆盖层
  fileprivate func _autoFadeOutOverlay() {
    
    guard _isShowOverlay == true else { return }
    
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(_hideOverlay), object: nil)
    perform(#selector(_hideOverlay), with: nil, afterDelay: 3.0)
  }
  
  @objc fileprivate func _changePlayStatus() {
    
    guard let delegatePlayer = delegatePlayer else { return }
    
    if delegatePlayer.isPlaying() {
      delegatePlayer.pause()
    } else {
      delegatePlayer.play()
    }
    playButtonLandscape.isSelected = delegatePlayer.isPlaying()
    playButtonPortrait.isSelected = delegatePlayer.isPlaying()
    smallPlayButtonPortrait.isSelected = delegatePlayer.isPlaying()
  }
  
//  获取系统音量
  fileprivate func _configureVolume() {
    
    let volumeView = MPVolumeView(frame: .zero)
    _volumeViewSlider = nil
    for view in volumeView.subviews {
      if view.self.description == "MPVolumeSlider" {
        _volumeViewSlider = view as! UISlider
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
  
//  设置timer
  fileprivate func _setupTimer() {
    
    _timer = Timer(timeInterval: 1.0, target: self, selector: #selector(_playerTimerAction), userInfo: nil, repeats: true)
    RunLoop.current.add(_timer, forMode: .commonModes)
  }
  
//  隐藏覆盖层
  @objc fileprivate func _hideOverlay() {
    
    guard _isShowOverlay == true else { return }
    
    UIApplication.shared.isStatusBarHidden = true
    UIView.animate(withDuration: 0.35, animations: {
      self.overlayView.alpha = 0
    }, completion: { (_ finished: Bool) in
      self._isShowOverlay = false
    })
  }
  
//  显示覆盖层
  fileprivate func _showOverlay() {
    
    guard _isShowOverlay == false else { return }
    
    UIApplication.shared.statusBarStyle = .lightContent
    UIApplication.shared.isStatusBarHidden = false
    UIView.animate(withDuration: 0.35, animations: {
      self.overlayView.alpha = 1
    }, completion: { (finished: Bool) in
      self._autoFadeOutOverlay()
    })
  }
  
//  水平移动
  fileprivate func _horizontalMoved(_ xValue: CGFloat) {
    
//    快进快退的方法
    if xValue < 0 {
      _speedView?.iconImageView.transform = CGAffineTransform.identity
    }
    if xValue > 0 {
      _speedView?.iconImageView.transform = CGAffineTransform(rotationAngle: Commons.transValue.angleTransRadian())
    }
//    每次滑动需要叠加时间
    _sumTime = _sumTime + Double(xValue) / 66
//    需要限定sumTime的范围
    if let delegatePlayer = delegatePlayer {
      let totalTime = delegatePlayer.duration
      if _sumTime > totalTime {
        _sumTime = totalTime
      }
      if _sumTime < 0 {
        _sumTime = 0
      }
//      当前快进的时间
      let nowTime = _durationStringWithTime(Int(_sumTime))
//      总时间
      let durationTime = _durationStringWithTime(Int(totalTime))
//      刷新speedView的数据源
      let speedViewDetailText = String(format: "%@ / %@", nowTime, durationTime)
      let speedViewSpeedText = String(format: "%ld秒 - 中速进退", Int(_sumTime - _beginTime))

      _speedView.timeLabel.text = speedViewDetailText
      _speedView.speedLabel.text = speedViewSpeedText
      
//      改变进度
      let progress = _sumTime / totalTime
      
      _speedView.progressView.progress = Float(progress)
      progressViewLandscape.progress = Float(progress)
      slider.value = Float(progress)
    }
  }
  
//  垂直移动
  fileprivate func _verticalMoved(_ yValue: CGFloat) {
    
    if _isVolume == true {
      _volumeViewSlider.value = _volumeViewSlider.value - Float(yValue) / 10000
    } else {
      UIScreen.main.brightness = UIScreen.main.brightness - yValue / 10000
    }
  }
  
  /**
   *  根据时长求出字符串
   *
   *  @param time 时长
   *
   *  @return 时长字符串
   */
  fileprivate func _durationStringWithTime(_ time: Int) -> String {
    
//    获取分钟
    let min = String(format: "%02ld", time / 60)
//    获取秒数
    let sec = String(format: "%02ld", time % 60)
    
    return String(format: "%@:%@", min, sec)
  }
  
}

extension VideoPlayerControlView {
  
  @objc fileprivate func _tapAction(_ tapGesture: UITapGestureRecognizer) {
    
    if tapGesture.state == .recognized {
      if _isShowOverlay == true {
        _showOverlay()
      } else {
        _hideOverlay()
      }
    }
  }
  
  @objc fileprivate func _doubleTapAction(_ tapGesture: UITapGestureRecognizer) {
    
//    显示控制层
    _showOverlay()
    
//    改变播放状态
    _changePlayStatus()
  }
  
  @objc fileprivate func _panAction(_ panGesture: UIPanGestureRecognizer) {
    
//    根据在view上Pan的位置，确定是调音量还是亮度
    let locationPoint = panGesture.location(in: panGesture.view)
//    响应水平移动和垂直移动
//    根据上次和本次移动的位置，算出一个速率的point
    let veloctyPoint = panGesture.velocity(in: panGesture.view)
    switch panGesture.state {
    case .began:
//      使用绝对值来判断移动的方向
      let x = fabs(veloctyPoint.x)
      let y = fabs(veloctyPoint.y)
      if x > y { // 水平移动
        _speedView?.isHidden = false
//        改变状态
        _panDirection = .horizontalMoved
//        暂停
        _timer.fireDate = Date.distantFuture
//        给时间Flag赋初值
        _beginTime = delegatePlayer?.currentPlaybackTime
        _sumTime = delegatePlayer?.currentPlaybackTime
      } else if x < y { // 垂直移动
//        改变状态
        _panDirection = .verticalMoved
        if locationPoint.x > st_width / 2 {
//          状态改为现实音量调节
          _isVolume = true
        } else {
//          状态改为现实亮度调节
          _isVolume = false
        }
      }
    case .changed:
      if _panDirection == .horizontalMoved {
//        水平移动只要x方向的值
        _horizontalMoved(veloctyPoint.x)
      } else if _panDirection == .verticalMoved {
//        垂直移动只要y方向的值
        _verticalMoved(veloctyPoint.y)
      }
    case .ended:
//      移动结束也需要判断垂直或者平移
//      比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
      if _panDirection == .horizontalMoved {
//        开启定时器
        _timer.fireDate = Date()
        let dispatchTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
//          隐藏
          self._speedView.isHidden = true
        }
//        视频跳转
        delegatePlayer?.currentPlaybackTime = _sumTime
//        把sumTime滞空, 不然会越加越多
        _sumTime = 0
      } else if _panDirection == .verticalMoved {
//        垂直移动结束后, 把状态改为不再控制音量
        _isVolume = false
        let dispatchTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
//          隐藏
          self._speedView.isHidden = true
        }
      }
    default:
      break
    }
  }
  
  @objc fileprivate func _playerTimerAction() {
    
    guard let delegatePlayer = delegatePlayer else { return }
    
//    滑杆进度
    slider.value = Float(delegatePlayer.currentPlaybackTime / delegatePlayer.duration)
    progressViewLandscape.progress = Float(delegatePlayer.playableDuration / delegatePlayer.duration)
//    当前时长进度progress
    let progressMin = Int(delegatePlayer.currentPlaybackTime / 60)
    let progressSec = Int(delegatePlayer.currentPlaybackTime) % 60
    
//    总时长
    let durationMin = Int(delegatePlayer.duration / 60)
    let durationSec = Int(delegatePlayer.duration) % 60
    
    currentPlayerTimeLabelLandscape.text = String(format: "%02zd:%02zd", progressMin, progressSec)
    totalPlayerTimeLabelLandscape.text = String(format: "%02zd:%02zd", durationMin, durationSec)
  }
  
}

extension VideoPlayerControlView {
  
  func registerBufferWithNotification(_ notification: Notification) {
    
//    释放资源
    _bufferingTimer.invalidate()
    
    if let object = notification.object {
      let player = object as! IJKFFMoviePlayerController
      if player.loadState == .stalled {
        debugPrint("缓冲开始")
//        开启定时器
        _bufferingTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(_buffering), userInfo: nil, repeats: true)
        RunLoop.main.add(_bufferingTimer, forMode: .commonModes)
      } else if player.loadState == [.playable, .playthroughOK] {
        debugPrint("缓冲结束")
        _bufferingTimer.invalidate()
      }
    }
  }
  
  @objc fileprivate func _buffering() {
    
    debugPrint("当前缓冲进度为: \(delegatePlayer?.bufferingProgress)")
  }
  
}
