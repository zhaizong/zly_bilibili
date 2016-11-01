//
//  RecommendViewController.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/25.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController, BiliStoryboardViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  static func instanceFromStoryboard<T>() -> T {
    
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
    return vc as! T
  }

}
