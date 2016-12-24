//
//  PhoneLiveViewController.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/22.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 手机直播控制器
// @use MeViewController.swift
// @since 1.1.0
// @author 赵林洋
class PhoneLiveViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  fileprivate var _phoneLivePreview: PhoneLivePreview!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    _setupApperance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    tabBarController?.tabBar.isHidden = true
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.meStoryboard().instantiateViewController(withIdentifier: "PhoneLiveViewController")
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

extension PhoneLiveViewController {
  
  fileprivate func _setupApperance() {
    
    _phoneLivePreview = PhoneLivePreview(frame: view.bounds)
//    _phoneLivePreview.liveUrl = "rtmp://1.12.234.24:1935/rtmplive/room"
//    _phoneLivePreview.liveUrl = "rtmp://192.168.3.2:1935/rtmplive/room"
    view.addSubview(_phoneLivePreview)
  }
  
}
