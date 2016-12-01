//
//  ContributeVideoDetailViewController.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/11/28.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通投稿视频详情页
// @use
// @since 1.0.5
// @author 赵林洋
/* @note swift3.0的变化
       在Swift3.0 之前，所有方法默认情况下有一个“可废弃的结果”。当你没有捕获方法返回的时候没有警告会出现。
       为了告诉编译器应该捕获结果,您必须在方法声明之前添加@warn_unused_result。它将被用于方法有一个可变的形式(例如、sort和sortInPlace)。可以添加@warn_unused_result(mutable_variant =“mutableMethodHere”)来告诉编译器。
       然而,随着Swift 3.0 的飞速发展，现在所有方法返回值没有捕获到结果，都会出现警告说。
       如果你想告诉编译器这里的警告是没有必要的,你可以在相对应的函数之前添加@discardableResult方法声明。如果你不想使用返回值,您必须显式地告诉编译器通过分配到下划线(或者是强调):
       
       _ = someMethodThatReturnsSomething()
       为什么需要这样添加到Swift3.0中呢，
       
       预防可能的错误(例如 使用排序的方式思考修改集合体)
       明确的意图不捕获相应的结果 或 需要捕获结果为其他类型的数据
       所以在UIKit API里面, 在使用popViewController(animated:) 的时候没有返回值不添加@discardableResult完全正常(这并不是普遍的现象)
 */
class ContributeVideoDetailViewController: UIViewController, BiliStoryboardViewController {

  // MARK: - Property
  
  @IBOutlet weak var videoPlayerControlView: VideoPlayerControlView!
  
  fileprivate lazy var _videoDict: [String: Any] = {
    let lazilyCreatedVideoDict = [String: Any]()
    return lazilyCreatedVideoDict
  }()
  
  fileprivate var _urlString: String?
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get {
      return .allButUpsideDown
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    _setupApperance()
    _setupDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
//    videoPlayerControlView.prepareToPlay()
    
    UIApplication.shared.isStatusBarHidden = false
    UIApplication.shared.statusBarStyle = .lightContent
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    videoPlayerControlView.shutdown()
    
    tabBarController?.tabBar.isHidden = false
  }
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.videoStoryboard().instantiateViewController(withIdentifier: "ContributeVideoDetailViewController")
    return vc as! T
  }
  

}

extension ContributeVideoDetailViewController {
  
  fileprivate func _setupApperance() {
    
    view.backgroundColor = BBK_Main_Background_Color
    
    UIApplication.shared.isStatusBarHidden = true
    
//    videoPlayerControlView.urlString = "https://www.bilibili.com/m/html5?aid=5106865&page=1"
//    view.addSubview(_videoPlayerControlView)
//    videoPlayerControlView.snp.makeConstraints { (make) in
//      make.top.equalTo(view.snp.top)
//      make.leading.equalTo(view.snp.leading)
//      make.trailing.equalTo(view.snp.trailing)
//      make.height.equalTo(videoPlayerControlView.snp.width).multipliedBy(9.0 / 16.0).priority(750)
//    }
    videoPlayerControlView.backButtonTouchUpInsideClosure = { [weak self] in
      guard let weakSelf = self else { return }
      /*
       swift3.0的变化
       */
      _ = weakSelf.navigationController?.popViewController(animated: true)
    }
  }
  
  fileprivate func _setupDataSource() {
    
    let setupVideoUrl: () -> Void = {
      if self._videoDict.count != 0 && self._urlString != nil {
        self.videoPlayerControlView.urlString = self._urlString
      }
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    因为加密所以都用本地json
//    加载番剧详情数据(暂时用来代替普通视频)
    if let data = _dataNamed("bangumi_detail_season.json") {
      do {
        let dict = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as! [String: Any]
        _videoDict = dict["result"] as! [String : Any]
      } catch let error {
        debugPrint(error)
      }
    }
//    加载剧集
    if let data = _dataNamed("bangumi_detail_getcidsource.json") {
      do {
        let dict = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as! [String: Any]
        let results = dict["result"] as! [[String: String]]
//        拿到cid
        let cid: String = results[0]["cid"]!
        let manager = BBKHTTPSessionManager.sharedManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        let urlString = "https://interface.bilibili.com/playurl"
        let params = ["appkey": "f3bb208b3d081dc8", "cid": cid, "sign": "3aa2879fb591b4e297ed3e69156c821e"]
        manager.get(urlString, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
          
//          加载整个文档
          do {
            if let responseObject = responseObject {
              let document = try DDXMLDocument(data: responseObject as! Data, options: 0)
              if let element = document.rootElement() {
                let durlElement = element.elements(forName: "durl")
                if let durlFirst = durlElement.first {
                  let urlElement = durlFirst.elements(forName: "url")
                  if let urlFirst = urlElement.first {
                    if let stringValue = urlFirst.stringValue {
                      if let url = URL(string: stringValue) {
                        if let scheme = url.scheme {
                          if scheme.lowercased() == "http" || scheme.lowercased() == "https" {
                            self._urlString = stringValue
                            setupVideoUrl()
                          }
                        }
                      }
                    }
                  } else {
                    debugPrint("urlElement.first.count: \(urlElement.count)")
                  }
                } else {
                  debugPrint("durlElement.first.count: \(durlElement.count)")
                }
              }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          } catch let error {
            debugPrint(error)
          }
//          加载整个文档
          
        }, failure: { (task: URLSessionDataTask?, error: Error) in
          debugPrint("加载剧集error: \(error)")
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
      } catch let error {
        debugPrint(error)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
  
  fileprivate func _dataNamed(_ name: String) -> Data? {
    
    if let path = Bundle.main.path(forResource: name, ofType: "") {
      return Data(referencing: NSData(contentsOfFile: path)!)
    } else {
      return nil
    }
  }
  
}
