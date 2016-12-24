//
//  MeViewController.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/20.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 个人中心页面

// @since 1.1.0
// @author 赵林洋
class MeViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - IBOutlet
  
  @IBOutlet weak var meTopView: UIView!
  
  // 头像按钮
  @IBOutlet weak var avatarButton: UIButton!
  
  // 设置按钮
  @IBOutlet weak var settingButton: UIButton!
  
  // 右箭头
  @IBOutlet weak var rightArrowImageView: UIImageView!
  
  @IBOutlet weak var meScrollView: UIScrollView!
  
  // 容器视图
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var meTopViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var phoneLiveButton: BBKProfileButton!
  
  // IBAction
  
  @IBAction func phoneLiveButtonDidClick(_ sender: BBKProfileButton) {
    
    performSegue(withIdentifier: "phonelive_segue", sender: nil)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    _setupApperance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.meStoryboard().instantiateViewController(withIdentifier: "MeViewController")
    return vc as! T
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    guard let keyPath = keyPath else { return }
    
    if keyPath == "contentOffset" {
      let point = meScrollView.contentOffset
      if point.y > 1 {
        meScrollView.backgroundColor = BBK_Light_Line_Color
      } else {
        meScrollView.backgroundColor = UIColor(hexString: "#E75686")
      }
    }
  }
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    guard let identifier = segue.identifier else { return }
    
    if identifier == "phonelive_segue" {
      
    }
  }
  */
}

extension MeViewController {
  
  fileprivate func _setupApperance() {
    
    automaticallyAdjustsScrollViewInsets = false
    
    rightArrowImageView.image = UIImage(named: "common_rightArrow")?.yy_image(byTintColor: UIColor.white)
    
    meScrollView.layer.cornerRadius = 8
    meScrollView.layer.masksToBounds = true
    
    // containerView
    let maskPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: BBK_Screen_Width, height: containerView.st_height)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = CGRect(origin: .zero, size: CGSize(width: BBK_Screen_Width, height: containerView.st_height))
    maskLayer.path = maskPath.cgPath
    containerView.layer.mask = maskLayer
    
    avatarButton.setImage(UIImage(named: "myicon")?.yy_imageByResize(to: CGSize(width: 58, height: 58), contentMode: .scaleToFill).yy_image(byRoundCornerRadius: 29), for: .normal)
    
    NotificationCenter.default.addObserver(meScrollView, forKeyPath: "contentOffset", options: .new, context: nil)
  }
  
}
