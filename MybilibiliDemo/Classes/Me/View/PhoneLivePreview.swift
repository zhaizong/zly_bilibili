//
//  PhoneLivePreview.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/22.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 手机直播preview
// PhoneLiveViewController.swift
// @since 1.1.0
// @author 赵林洋
class PhoneLivePreview: UIView {

  // MARK: - Property
  
  var liveUrl: String? {
    didSet {
      guard let liveUrl = liveUrl, liveUrl != "" else { return }
      _liveUrl = liveUrl
    }
  }
  fileprivate var _liveUrl: String!
  
  fileprivate var _overlayView: UIView
  
  fileprivate var _iconImageView: UIImageView
  
  fileprivate var _titleLabel: UILabel
  
  fileprivate var _liveStatusLabel: UILabel
  
  fileprivate var _cameraButton: UIButton
  
  fileprivate var _beautyButton: UIButton
  
  fileprivate var _startLiveButton: UIButton
  
  fileprivate var _lightButton: UIButton
  
  fileprivate var _mirrorButton: UIButton
  
  fileprivate lazy var _liveSession: LFLiveSession = {
    let lazilyLiveSession = LFLiveSession(audioConfiguration: LFLiveAudioConfiguration.default(), videoConfiguration: LFLiveVideoConfiguration.defaultConfiguration(for: .medium3, outputImageOrientation: .portrait))
    lazilyLiveSession?.delegate = self
    lazilyLiveSession?.showDebugInfo = true
    lazilyLiveSession?.preView = self
    return lazilyLiveSession!
  }()
  
  fileprivate var _captureDevice: AVCaptureDevice!
  
  fileprivate var _torchMode: AVCaptureTorchMode?
  
  override init(frame: CGRect) {
    _overlayView = UIView(frame: .zero)
    _iconImageView = UIImageView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _liveStatusLabel = UILabel(frame: .zero)
    _cameraButton = UIButton(type: .custom)
    _beautyButton = UIButton(type: .custom)
    _startLiveButton = UIButton(type: .custom)
    _lightButton = UIButton(type: .custom)
    _mirrorButton = UIButton(type: .custom)
    super.init(frame: frame)
    
    _layoutSubviews()
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension PhoneLivePreview {
  
  fileprivate func _setupApperance() {
    
    _captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    _torchMode = .off
    
    _iconImageView.image = UIImage(named: "myicon")
    _iconImageView.layerCornerRadius = _iconImageView.st_width * 0.5
    
    _titleLabel.text = "xxx的直播间"
    _titleLabel.textColor = UIColor.white
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    
    _liveStatusLabel.text = "未连接"
    _liveStatusLabel.textColor = UIColor.white
    _liveStatusLabel.font = UIFont.systemFont(ofSize: 14)
    
    _cameraButton.setImage(UIImage(named: "live_preview_camera"), for: .normal)
    _cameraButton.isExclusiveTouch = true
    _cameraButton.addTarget(self, action: #selector(_cameraButtonDidClick(_:)), for: .touchUpInside)
    
    _beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: .normal)
    _beautyButton.isExclusiveTouch = true
    _beautyButton.addTarget(self, action: #selector(_beautyButtonDidClick(_:)), for: .touchUpInside)
    
    _lightButton.setImage(UIImage(named: "newbarcode_light_off"), for: .normal)
    _lightButton.isExclusiveTouch = true
    _lightButton.addTarget(self, action: #selector(_lightButtonDidClick(_:)), for: .touchUpInside)
    
    _mirrorButton.setImage(UIImage(named: "mirror"), for: .normal)
    _mirrorButton.setImage(UIImage(named: "mirror"), for: .highlighted)
    _mirrorButton.setImage(UIImage(named: "mirror"), for: .selected)
    _mirrorButton.isExclusiveTouch = true
    _mirrorButton.addTarget(self, action: #selector(_mirrorButtonDidClick(_:)), for: .touchUpInside)
    
    _startLiveButton.setTitle("开始直播", for: .normal)
    _startLiveButton.layerCornerRadius = 24
    _startLiveButton.isExclusiveTouch = true
    _startLiveButton.addTarget(self, action: #selector(_startLiveButtonDidClick(_:)), for: .touchUpInside)
    
    _requestAccessForVideo()
    _requestAccessForAudio()
  }
  
  fileprivate func _layoutSubviews() {
    
    addSubview(_overlayView)
    _overlayView.addSubview(_iconImageView)
    _overlayView.addSubview(_titleLabel)
    _overlayView.addSubview(_liveStatusLabel)
    _overlayView.addSubview(_cameraButton)
    _overlayView.addSubview(_beautyButton)
    _overlayView.addSubview(_startLiveButton)
    _overlayView.addSubview(_lightButton)
    _overlayView.addSubview(_mirrorButton)
    
    _overlayView.snp.makeConstraints { (make) in
      make.top.equalTo(snp.top)
      make.bottom.equalTo(snp.bottom)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
    }
    
    _iconImageView.snp.makeConstraints { (make) in
      make.top.equalTo(24)
      make.leading.equalTo(16)
      make.width.equalTo(64)
      make.height.equalTo(64)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_iconImageView.snp.top)
      make.leading.equalTo(_iconImageView.snp.trailing).offset(4)
    }
    
    _liveStatusLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(_titleLabel.snp.leading)
      make.bottom.equalTo(_iconImageView.snp.bottom)
    }
    
    _cameraButton.snp.makeConstraints { (make) in
      make.top.equalTo(24)
      make.trailing.equalTo(-4)
      make.width.equalTo(44)
      make.height.equalTo(36)
    }
    
    _beautyButton.snp.makeConstraints { (make) in
      make.size.equalTo(44)
      make.trailing.equalTo(_cameraButton.snp.leading).offset(-4)
      make.centerY.equalTo(_cameraButton.snp.centerY)
    }
    
    _lightButton.snp.makeConstraints { (make) in
      make.size.equalTo(44)
      make.top.equalTo(_cameraButton.snp.bottom).offset(4)
      make.centerX.equalTo(_cameraButton.snp.centerX)
    }
    
    _mirrorButton.snp.makeConstraints { (make) in
      make.size.equalTo(44)
      make.centerX.equalTo(_lightButton.snp.centerX)
      make.top.equalTo(_lightButton.snp.bottom).offset(4)
    }
    
    _startLiveButton.snp.makeConstraints { (make) in
      make.leading.equalTo(16)
      make.trailing.equalTo(-16)
      make.bottom.equalTo(-16)
      make.height.equalTo(44)
    }
    
  }
  
  @objc fileprivate func _startLiveButtonDidClick(_ sender: UIButton) {
    
    _startLiveButton.isSelected = !_startLiveButton.isSelected
    if _startLiveButton.isSelected == true {
      _startLiveButton.setTitle("结束直播", for: .normal)
      let stream = LFLiveStreamInfo()
      stream.url = liveUrl
      _liveSession.startLive(stream)
    } else {
      _startLiveButton.setTitle("开始直播", for: .normal)
      _liveSession.stopLive()
    }
  }
  
  @objc fileprivate func _beautyButtonDidClick(_ sender: UIButton) {
    
    _liveSession.beautyFace = !_liveSession.beautyFace
    _beautyButton.isSelected = !_liveSession.beautyFace
  }
  
  @objc fileprivate func _cameraButtonDidClick(_ sender: UIButton) {
    
    let devicePositon = _liveSession.captureDevicePosition
    _liveSession.captureDevicePosition = devicePositon == .back ? .front : .back
  }
  
  @objc fileprivate func _lightButtonDidClick(_ sender: UIButton) {
    
    _liveSession.torch = !_lightButton.isSelected
    _lightButton.isSelected = !_lightButton.isSelected
  }
  
  @objc fileprivate func _mirrorButtonDidClick(_ sender: UIButton) {
    
    _liveSession.mirror = !_mirrorButton.isSelected
    _mirrorButton.isSelected = !_mirrorButton.isSelected
  }
  
//  开启摄像头授权
  fileprivate func _requestAccessForVideo() {
    
    let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    switch status {
    case .notDetermined: // 许可对话没有出现，发起授权许可
      AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) in
        if granted == true {
          DispatchQueue.main.async {
            self._liveSession.running = true
          }
        }
      })
    case .authorized: // 已经开启授权，可继续
      DispatchQueue.main.async {
        self._liveSession.running = true
      }
    case .denied, .restricted:
      debugPrint("用户拒绝授权，或者相机设备无法访问")
    }
  }
  
//  开启麦克风授权
  fileprivate func _requestAccessForAudio() {
    
    let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
    switch status {
    case .notDetermined:
      AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted: Bool) in
        // ignore
      })
    case .authorized:
      // ignore
      break
    case .denied, .restricted:
      // ignore
      break
    }
  }
  
}

extension PhoneLivePreview: LFLiveSessionDelegate {
  
//  live status changed will callback
  func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
   
    switch state {
    case .ready:
      debugPrint("未连接")
      _liveStatusLabel.text = "未连接"
    case .pending:
      debugPrint("连接中")
      _liveStatusLabel.text = "正在连接..."
    case .start:
      debugPrint("连接成功")
      _liveStatusLabel.text = "正在直播"
    case .error:
      debugPrint("连接错误")
      _liveStatusLabel.text = "未连接"
    case .stop:
      debugPrint("未连接")
      _liveStatusLabel.text = "未连接"
    default:
      break
    }
  }
  
//  live debug info callback
  func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
    debugPrint("\n")
    debugPrint("live debug info callback: \(debugInfo?.currentBandwidth)")
    debugPrint("\n")
  }
  
//  callback socket errorcode
  func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
    
    debugPrint("callback socket errorcode: ")
    switch errorCode {
    case .preView:
      debugPrint("预览失败")
    case .getStreamInfo:
      debugPrint("获取流媒体信息失败")
    case .connectSocket:
      debugPrint("连接socket失败")
    case .verification:
      debugPrint("验证服务器失败")
    case .reConnectTimeOut:
      debugPrint("重新连接服务器超时")
    }
  }
  
}
