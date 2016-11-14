//
//  DMKViewController.swift
//  DoubanMovie
//
//  Created by 宅总 on 16/7/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

enum TitleColorGradientStyle: UInt {
  case rgb
  case Fill
}

fileprivate struct Commons {
  static let TitleScrollViewHeight: CGFloat = 44 // 标题滚动视图的高度
  static let TitleFont = UIFont.systemFont(ofSize: 15) // 默认标题字体
  static let ScreenWidth = UIScreen.main.bounds.size.width
  static let ScreenHeight = UIScreen.main.bounds.size.height
  static let NavBarHeight: CGFloat = 64 // 导航条高度
  static let ID = "cell"
  static let Margin: CGFloat = 20
  static let TitleTransformScale: CGFloat = 1.3 // 标题缩放比例
  static let UnderLineH: CGFloat = 2 // 下划线默认高度
//  重复点击通知
  static let DisplayViewRepeatClickTitleNote = "displayview_repeatclick_titlenote"
}

// 字体放大效果和角标不能同时使用。
// 网易效果：颜色渐变 + 字体缩放
// 进入头条效果：颜色填充渐变
// 展示tableView的时候，如果有UITabBarController,UINavgationController,需要自己给tableView添加额外滚动区域。
class BiliViewController: UIViewController {

  // MARK: - Property
  
  /**
   如果_isfullScreen = true，这个方法就不好使。
   
   设置整体内容的frame,包含（标题滚动视图和内容滚动视图）
   */
  var setupContentViewFrame: CGRect? {
    didSet {
      guard let setupContentViewFrame = setupContentViewFrame, setupContentViewFrame != .zero else { return }
      _contentView.frame = setupContentViewFrame
    }
  }
  
  // MARK: - 内容
  
  /**
   内容是否需要全屏展示
   true :  全屏：内容占据整个屏幕，会有穿透导航栏效果，需要手动设置tableView额外滚动区域
   false  :  内容从标题下展示
   */
  var isfullScreen: Bool = false {
    didSet {
      _contentView.frame = CGRect(origin: .zero, size: CGSize(width: Commons.ScreenWidth, height: Commons.ScreenHeight))
    }
  }
  /**
   根据角标，选中对应的控制器
   */
  var selectedIndex: Int! {
    didSet {
      guard _titleLabels.isEmpty == false else { return }
      let label = _titleLabels[selectedIndex]
      if let gest = label.gestureRecognizers {
        if let lastObj = gest.last {
          _titleClick(lastObj as! UITapGestureRecognizer)
        }
      }
    }
  }
  
  // MARK: - 标题
  
  /**
   标题滚动视图背景颜色
   */
  var titleScrollViewColor: UIColor? {
    didSet {
      _titleScrollView.backgroundColor = titleScrollViewColor
    }
  }
  /**
   标题高度
   */
  var titleHeight: CGFloat?
  /**
   正常标题颜色
   */
  lazy var normalColor: UIColor = { [weak self] in
    guard let weakSelf = self else { return UIColor.black }
    var lazilyCreatedColor = UIColor.black
    if weakSelf.isShowTitleGradient == true && weakSelf.titleColorGradientStyle == .rgb {
      lazilyCreatedColor = UIColor(red: weakSelf.startR, green: weakSelf.startG, blue: weakSelf.startB, alpha: 1)
    }
    return lazilyCreatedColor
  }()
  /**
   选中标题颜色
   */
  lazy var selectColor: UIColor = { [weak self] in
    guard let weakSelf = self else { return UIColor.red }
    var lazilyCreatedColor = UIColor.red
    if weakSelf.isShowTitleGradient == true && weakSelf.titleColorGradientStyle == .rgb {
      lazilyCreatedColor = UIColor(red: weakSelf.endR, green: weakSelf.endG, blue: weakSelf.endB, alpha: 1)
    }
    return lazilyCreatedColor
  }()
  /**
   标题字体
   */
  lazy var titleFont: UIFont = {
    let lazilyCreatedFont = Commons.TitleFont
    return lazilyCreatedFont
  }()
  
  // MARK: - 下标
  
  /**
   是否需要下标
   */
  var isShowUnderLine: Bool? {
    willSet {
      guard let isShowTitleScale = isShowTitleScale else { return }
      if isShowTitleScale == true {
//        抛异常
        let excp = NSException(name: NSExceptionName(rawValue: "bili_vc_exception"), reason: "字体放大效果和角标不能同时使用.", userInfo: nil)
        excp.raise()
      }
    }
  }
  /**
   是否延迟滚动下标
   */
  var isDelayScroll: Bool!
  /**
   下标颜色
   */
  var underLineColor: UIColor!
  /**
   下标高度
   */
  var underLineH: CGFloat!
  
  // MARK: - 字体缩放
  
  /**
   字体放大
   */
  var isShowTitleScale: Bool? {
    willSet {
      guard let isShowUnderLine = isShowUnderLine else { return }
      if isShowUnderLine == true {
//        抛异常
        let excp = NSException(name: NSExceptionName(rawValue: "bili_vc_exception"), reason: "字体放大效果和角标不能同时使用.", userInfo: nil)
        excp.raise()
      }
    }
  }
  /**
   字体缩放比例
   */
  var titleScale: CGFloat!
  
  // MARK: - 颜色渐变
  
  /**
   字体是否渐变
   */
  var isShowTitleGradient: Bool!
  /**
   颜色渐变样式
   */
  var titleColorGradientStyle: TitleColorGradientStyle!
  /**
   开始颜色,取值范围0~1
   */
  var startR: CGFloat!
  var startG: CGFloat!
  var startB: CGFloat!
  /**
   完成颜色,取值范围0~1
   */
  var endR: CGFloat!
  var endG: CGFloat!
  var endB: CGFloat!
  
  // MARK: - 遮盖
  
  /**
   是否显示遮盖
   */
  var isShowTitleCover: Bool!
  /**
   遮盖颜色
   */
  var coverColor: UIColor!
  /**
   遮盖圆角半径
   */
  var coverCornerRadius: CGFloat!
  
  // MARK: - 修改框架功能部分
  
  /**
   *  是否平分宽度
   */
  var isBisectedWidthUnderLineAndTitle: Bool!
  /**
   *  是否禁止内容视图的滑动效果
   */
  var isBanContentViewScroll: Bool! {
    didSet {
      _contentScrollView.isScrollEnabled = !isBanContentViewScroll
    }
  }
  
//  懒加载整个内容view, 整体内容View 包含标题和内容滚动视图.
  fileprivate lazy var _contentView: UIView = { [weak self] in
    guard let weakSelf = self else { return UIView() }
    let lazilyCreatedContentView = UIView()
    weakSelf.view.addSubview(lazilyCreatedContentView)
    return lazilyCreatedContentView
  }()
//  懒加载标题滚动视图
  fileprivate lazy var _titleScrollView: UIScrollView = { [weak self] in
    guard let weakSelf = self else { return UIScrollView() }
    let lazilyCreatedScrollView = UIScrollView()
    lazilyCreatedScrollView.scrollsToTop = false
    if let titleScrollViewColor = weakSelf.titleScrollViewColor {
      lazilyCreatedScrollView.backgroundColor = titleScrollViewColor
    } else {
      lazilyCreatedScrollView.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
    if weakSelf.isBisectedWidthUnderLineAndTitle == true {
      lazilyCreatedScrollView.bounces = false
    }
    weakSelf._contentView.addSubview(lazilyCreatedScrollView)
    return lazilyCreatedScrollView
  }()
//  内容滚动视图
  fileprivate lazy var _contentScrollView: UICollectionView = { [weak self] in
    guard let weakSelf = self else { return UICollectionView() }
//    创建布局
    let layout = BiliFlowLayout()
    let lazilyCreatedContentScrollView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    lazilyCreatedContentScrollView.isPagingEnabled = true
    lazilyCreatedContentScrollView.showsHorizontalScrollIndicator = false
    lazilyCreatedContentScrollView.bounces = false
    lazilyCreatedContentScrollView.scrollsToTop = false
    lazilyCreatedContentScrollView.dataSource = self
    lazilyCreatedContentScrollView.delegate = self
    weakSelf._contentView.insertSubview(lazilyCreatedContentScrollView, belowSubview: weakSelf._titleScrollView)
    return lazilyCreatedContentScrollView
  }()
//  所有标题数组
  fileprivate lazy var _titleLabels: [UILabel] = {
    let lazilyCreatedTitleLabels = [UILabel]()
    return lazilyCreatedTitleLabels
  }()
//  所有标题宽度数组
  fileprivate lazy var _titleWidths: [CGFloat] = {
    let lazilyCreatedTitleWidths = [CGFloat]()
    return lazilyCreatedTitleWidths
  }()
//  下标视图
  fileprivate lazy var _underLine: UIView? = { [weak self] in
    guard let weakSelf = self else { return nil }
    let lazilyCreatedUnderLine = UIView(frame: .zero)
    if let underLineColor = weakSelf.underLineColor {
      lazilyCreatedUnderLine.backgroundColor = weakSelf.underLineColor
    } else {
      lazilyCreatedUnderLine.backgroundColor = UIColor.red
    }
    weakSelf._titleScrollView.addSubview(lazilyCreatedUnderLine)
    if weakSelf.isShowUnderLine == true {
      return lazilyCreatedUnderLine
    } else {
      return nil
    }
  }()
  
//  标题遮盖视图
  fileprivate lazy var _coverView: UIView? = { [weak self] in
    guard let weakSelf = self else { return nil }
    let lazilyCreatedCoverView = UIView(frame: .zero)
    if let coverColor = weakSelf.coverColor {
      lazilyCreatedCoverView.backgroundColor = coverColor
    } else {
      lazilyCreatedCoverView.backgroundColor = UIColor.lightGray
    }
//    lazilyCreatedCoverView.layer.cornerRadius = weakSelf.coverCornerRadius
    lazilyCreatedCoverView.layer.cornerRadius = 5
    weakSelf._titleScrollView.insertSubview(lazilyCreatedCoverView, at: 0)
    guard let _ = weakSelf.isShowTitleCover, weakSelf.isShowTitleCover == true else { return nil }
    return lazilyCreatedCoverView
  }()
//  记录上一次内容滚动视图偏移量
  fileprivate var _lastOffsetX: CGFloat!
//  记录是否点击
  fileprivate var _isClickTitle: Bool!
//  记录是否在动画
  fileprivate var _isAniming: Bool!
//  是否初始化
  fileprivate var _isInitial: Bool = false
//  标题间距
  fileprivate var _titleMargin: CGFloat!
//  计算上一次选中角标
  fileprivate var _selIndex: Int!
//  底部的线
  fileprivate lazy var _bottomLine: UIView = { [weak self] in
    guard let weakSelf = self else { return UIView() }
    let lazilyCreatedBottomLine = UIView(frame: .zero)
    lazilyCreatedBottomLine.backgroundColor = BBK_Main_Line_Color
    weakSelf._titleScrollView.addSubview(lazilyCreatedBottomLine)
    return lazilyCreatedBottomLine
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    /*setNeedsStatusBarAppearanceUpdate()
    if let navigationController = navigationController {
      navigationController.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
      navigationController.navigationBar.shadowImage = UIImage()
      let backButtonImage = UIImage(named: "app_nav_back")
      navigationController.navigationBar.backIndicatorImage = backButtonImage
      navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }*/
    
//    初始化标题高度
    titleHeight = Commons.TitleScrollViewHeight
//    初始化是否平分宽度的属性(标题平分+下划线平分)
    isBisectedWidthUnderLineAndTitle = false
//    是否禁止contentView的滚动效果
    isBanContentViewScroll = false
    
    automaticallyAdjustsScrollViewInsets = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    becomeFirstResponder()
    if _isInitial == false {
      _isInitial = true
//      注册cell
      _contentScrollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Commons.ID)
      _contentScrollView.backgroundColor = view.backgroundColor
//      初始化
      _setUp()
//      没有子控制器，不需要设置标题
      guard childViewControllers.count != 0 else { return }
//      计算所有标题宽度
      _setupTitleWidth()
      _setupAllTitle()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let contentY: CGFloat = (navigationController != nil) ? Commons.NavBarHeight : UIApplication.shared.statusBarFrame.size.height
    let contentW = Commons.ScreenWidth
    let contentH = Commons.ScreenHeight - contentY
//    设置整个内容的尺寸
    if _contentView.frame.size.height == 0 {
//      没有设置内容尺寸，才需要设置内容尺寸
      _contentView.frame = CGRect(origin: CGPoint(x: 0, y: contentY), size: CGSize(width: contentW, height: contentH))
    }
//    设置标题滚动视图frame
//    计算尺寸
    let titleH = titleHeight != nil ? titleHeight! : Commons.TitleScrollViewHeight
    let titleY = isfullScreen == true ? contentY : 0
    _titleScrollView.frame = CGRect(origin: CGPoint(x: 0, y: titleY), size: CGSize(width: contentW, height: titleH))
//    设置内容滚动视图frame
    let contentScrollY = _titleScrollView.frame.maxY
    if isfullScreen == true {
      _contentScrollView.frame = CGRect(origin: .zero, size: CGSize(width: contentW, height: Commons.ScreenHeight))
    } else {
      _contentScrollView.frame = CGRect(origin: CGPoint(x: 0, y: contentScrollY), size: CGSize(width: contentW, height: _contentView.st_height - contentScrollY))
    }
//    设置底部的线
    if let _underLine = _underLine {
      _bottomLine.frame = CGRect(origin: CGPoint(x: 0, y: _underLine.st_bottom - 0.5), size: CGSize(width: _titleScrollView.st_width, height: 0.5))
    }
    
  }
  
  /*override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    resignFirstResponder()
  }*/
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension BiliViewController {
  
  // MARK: - Fileprivate Method
  
  fileprivate func _setUp() {
    
    if isShowTitleGradient && titleColorGradientStyle == .rgb {
//      初始化颜色渐变
      if endR == 0 && endG == 0 && endB == 0 {
        endR = 1
      }
    }
  }
  
  fileprivate func _setupTitleWidth() {
    
//    判断是否能占据整个屏幕
    let count = childViewControllers.count
    let titleVCs = childViewControllers
    var totalWidth: CGFloat = 0
//    计算所有标题的宽度
    for titleVC in titleVCs {
      let title = titleVC.value(forKeyPath: "title") as? String
      if let title = title {
        let titleBounds = title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
        let width = titleBounds.size.width
        _titleWidths.append(width)
        totalWidth += width
      } else {
        let excp = NSException(name: NSExceptionName(rawValue: "bili_vc_exception"), reason: "没有设置Controller.title属性，应该把子标题保存到对应子控制器中.", userInfo: nil)
        excp.raise()
      }
      if totalWidth > Commons.ScreenWidth {
        _titleMargin = Commons.Margin
        if isBisectedWidthUnderLineAndTitle == true {
          _titleScrollView.contentInset = UIEdgeInsets.zero
        } else {
          _titleScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: _titleMargin)
        }
        return
      }
      let titleMargin = (Commons.ScreenWidth - totalWidth) / (CGFloat(count) + 1.0)
      _titleMargin = titleMargin < Commons.Margin ? Commons.Margin : titleMargin
      if isBisectedWidthUnderLineAndTitle == false {
        _titleScrollView.contentInset = UIEdgeInsets.zero
      } else {
        _titleScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: _titleMargin)
      }
    }
  }
  
//  设置所有标题 _setupAllTitle()
  fileprivate func _setupAllTitle() {
    
//    遍历所有的子控制器
    let count = childViewControllers.count
//    添加所有的标题
    var labelW: CGFloat = 0
    let labelH: CGFloat = titleHeight!
    var labelX: CGFloat = 0
    let labelY: CGFloat = 0
    for i in 0..<count {
      let vc = childViewControllers[i]
      let displayTitleLabel = BBKDisplayTitleLabel()
      displayTitleLabel.tag = i
//      设置按钮的文字颜色
      displayTitleLabel.textColor = normalColor
      displayTitleLabel.font = titleFont
//      设置按钮标题
      displayTitleLabel.text = vc.title
      if isBisectedWidthUnderLineAndTitle == true {
        labelW = Commons.ScreenWidth / CGFloat(count)
      } else {
        labelW = _titleWidths[i]
      }
//      设置按钮位置
      if let lastLabel = _titleLabels.last {
        if isBisectedWidthUnderLineAndTitle == true {
          labelX = lastLabel.frame.maxX
        } else {
          labelX = _titleMargin + lastLabel.frame.maxX
        }
      }
      displayTitleLabel.frame = CGRect(origin: CGPoint(x: labelX, y: labelY), size: CGSize(width: labelW, height: labelH))
//      监听标题的点击
      let tap = UITapGestureRecognizer(target: self, action: #selector(BiliViewController._titleClick(_:)))
      displayTitleLabel.addGestureRecognizer(tap)
//      保存到数组
      _titleLabels.append(displayTitleLabel)
      _titleScrollView.addSubview(displayTitleLabel)
      if i == selectedIndex {
        _titleClick(tap)
      }
    }
//    设置标题滚动视图的内容范围
    if let lastLabel = _titleLabels.last {
      if isBisectedWidthUnderLineAndTitle == true {
        _titleScrollView.contentSize = CGSize(width: Commons.ScreenWidth, height: 0)
      } else {
        _titleScrollView.contentSize = CGSize(width: lastLabel.frame.maxX, height: 0)
      }
    }
    _titleScrollView.showsHorizontalScrollIndicator = false
    _contentScrollView.contentSize = CGSize(width: CGFloat(count) * Commons.ScreenWidth, height: 0)
  }
//  标题按钮点击
  @objc fileprivate func _titleClick(_ tap: UITapGestureRecognizer) {
    
//    记录是否点击标题
    _isClickTitle = true
//    获取对应标题label
    if let label = tap.view {
//      获取当前角标
      let i = label.tag
//      选中label
      _selectLabel(label as! UILabel)
//      内容滚动视图滚动到对应位置
      let offsetX = CGFloat(i) * Commons.ScreenWidth
      _contentScrollView.contentOffset = CGPoint(x: offsetX, y: 0)
//      记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
      _lastOffsetX = offsetX
//      添加控制器
      let vc = childViewControllers[i]
//      判断控制器的view有没有加载，没有就加载，加载完在发送通知
      if let _ = vc.view {
//        发出通知点击标题通知
        NotificationCenter.default.post(name: .init(BBK_DisplayView_ClickOrScrollDidFinshNote), object: vc)
//        发出重复点击标题通知
        if selectedIndex == i {
          NotificationCenter.default.post(name: .init(rawValue: Commons.DisplayViewRepeatClickTitleNote), object: vc)
        }
      }
      _selIndex = i
//      点击事件处理完成
      _isClickTitle = false
    }
  }
  
  fileprivate func _selectLabel(_ label: UILabel) {
    
    for labelView in _titleLabels as! [BBKDisplayTitleLabel] {
      if label == labelView {
        continue
      }
      if isShowTitleGradient && titleColorGradientStyle == .rgb {
        labelView.transform = CGAffineTransform.identity
      }
      labelView.textColor = normalColor
      if isShowTitleGradient && titleColorGradientStyle == .Fill {
        labelView.fillColor = normalColor
        labelView.progress = 1
      }
    }
//    标题缩放
    if let isShowTitleScale = isShowTitleScale {
      if isShowTitleScale && titleColorGradientStyle == .rgb {
        let scaleTransform = titleScale != nil ? titleScale : Commons.TitleTransformScale
        label.transform = CGAffineTransform(scaleX: scaleTransform!, y: scaleTransform!)
      }
    }
//    修改标题选中颜色
    label.textColor = selectColor
//    设置标题居中
    _setLabelTitleCenter(label)
//    设置下标的位置
    _setupUnderLine(label)
//    设置cover
    _setupCoverView(label)
  }
//  让选中的按钮居中显示
  fileprivate func _setLabelTitleCenter(_ label: UILabel) {
    
//    设置标题滚动区域的偏移量
    var offsetX = label.center.x - Commons.ScreenWidth * 0.5
    if offsetX < 0 {
      offsetX = 0
    }
//    计算下最大的标题视图滚动区域
    var maxOffsetX = _titleScrollView.contentSize.width - Commons.ScreenWidth + _titleMargin
    if maxOffsetX < 0 {
      maxOffsetX = 0
    }
    if offsetX > maxOffsetX {
      maxOffsetX = offsetX
    }
//    滚动区域
    if isBisectedWidthUnderLineAndTitle == true {
      _titleScrollView.setContentOffset(.zero, animated: true)
    } else {
      _titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
  }
//  设置下标的位置
  fileprivate func _setupUnderLine(_ label: UILabel) {
    
    guard let text = label.text else { return }
//    获取文字尺寸
    let titleBounds = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
    var underLineH: CGFloat = 0
    if let _underLineH = self.underLineH {
      underLineH = _underLineH
    } else {
      underLineH = Commons.UnderLineH
    }
    _underLine?.st_top = label.st_height - underLineH
    _underLine?.st_height = underLineH
//    点击时候需要动画
    if let _ = _underLine {
      UIView.animate(withDuration: 0.25) {
        if self.isBisectedWidthUnderLineAndTitle == true {
          let count = self.childViewControllers.count
          self._underLine?.st_width = Commons.ScreenWidth / CGFloat(count) - Commons.Margin
//          self._underLine?.st_left = label.st_left + Commons.Margin
          self._underLine?.st_centerX = label.st_centerX
        } else {
          self._underLine?.st_width = titleBounds.size.width - Commons.Margin
          self._underLine?.st_centerX = label.st_centerX
        }
      }
    }
  }
//  设置蒙版
  fileprivate func _setupCoverView(_ label: UILabel) {
    
//    获取文字尺寸
    let titleBounds = label.text!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
    let border: CGFloat = 5
    let coverH = titleBounds.size.height + 2 * border
    let coverW = titleBounds.size.width + 2 * border
    
    if let _ = _coverView {
      self._coverView?.st_top = (label.st_height - coverH) * 5
      self._coverView?.st_height = coverH
//      最开始不需要动画
      if self._coverView?.st_left == 0 {
        self._coverView?.st_width = coverW
        self._coverView?.st_left = label.st_left - border
        return
      }
//      点击时候需要动画
      UIView.animate(withDuration: 0.25, animations: {
        self._coverView?.st_width = coverW
        self._coverView?.st_left = label.st_left - border
      })
    }
  }
//  设置所有标题 _setupAllTitle()
  
//  设置标题颜色渐变
  fileprivate func _setupTitleColorGradientWithOffset(_ offsetX: CGFloat, rightLabel: BBKDisplayTitleLabel, leftLabel: BBKDisplayTitleLabel) {
    
    guard isShowTitleGradient == true else { return }
//    获取右边缩放
    let rightSacle = offsetX / Commons.ScreenWidth - CGFloat(leftLabel.tag)
//    获取左边缩放比例
    let leftSacle = 1 - rightSacle
//    rgb渐变
    if titleColorGradientStyle == .rgb {
      let r = endR - startR
      let g = endG - startG
      let b = endB - startB
//      rightColor 1 0 0
      let rightColor = UIColor(red: startR + r * rightSacle,
                               green: startG + g * rightSacle,
                               blue: startB + b * rightSacle,
                               alpha: 1)
//      leftColor 0.3 0 0, 1 -> 0.3
      let leftColor = UIColor(red: startR + r * leftSacle,
                              green: startG + g * leftSacle,
                              blue: startB + b * leftSacle,
                              alpha: 1)
//      右边颜色
      rightLabel.textColor = rightColor
//      左边颜色
      leftLabel.textColor = leftColor
      return
    }
//    填充渐变
    if titleColorGradientStyle == .Fill {
//      获取移动距离
      let offsetDelta = offsetX - _lastOffsetX
//      往右边
      if offsetDelta > 0 {
        rightLabel.fillColor = selectColor
        rightLabel.progress = rightSacle
        leftLabel.fillColor = normalColor
        leftLabel.progress = rightSacle
      } else if offsetDelta < 0 { // 往左边
        rightLabel.textColor = normalColor
        rightLabel.fillColor = selectColor
        rightLabel.progress = rightSacle
        leftLabel.textColor = selectColor
        leftLabel.fillColor = normalColor
        leftLabel.progress = rightSacle
      }
    }
  }
  
//  标题缩放
  fileprivate func _setupTitleScaleWithOffset(_ offsetX: CGFloat, rightLabel: UILabel, leftLabel: UILabel) {
    
    guard isShowTitleScale == true else {
      return
    }
//    获取右边缩放
    let rightScale = offsetX / Commons.ScreenWidth - CGFloat(leftLabel.tag)
//    获取左边缩放比例
    let leftScale = 1 - rightScale
    var scaleTransform: CGFloat
    if let _ = titleScale {
      scaleTransform = titleScale
    } else {
      scaleTransform = Commons.TitleTransformScale
    }
    scaleTransform -= 1
//    缩放按钮
    leftLabel.transform = CGAffineTransform(scaleX: leftScale * scaleTransform + 1, y: leftScale * scaleTransform + 1)
//    1 ~ 1.3
    rightLabel.transform = CGAffineTransform(scaleX: rightScale * scaleTransform + 1, y: rightScale * scaleTransform + 1)
  }
  
//  获取两个标题按钮宽度差值
  fileprivate func _widthDeltaWithRightLabel(_ rightLabel: UILabel, leftLabel: UILabel) -> CGFloat {
    
    guard let rightLabelText = rightLabel.text else { return 0 }
    guard let leftLabelText = leftLabel.text else { return 0 }
    let titleBoundsR = rightLabelText.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
    let titleBoundsL = leftLabelText.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
    return titleBoundsR.size.width - titleBoundsL.size.width
  }
  
//  设置下标偏移
  fileprivate func _setupUnderLineOffset(_ offsetX: CGFloat, rightLabel: UILabel, leftLabel: UILabel) {
    
    guard _isClickTitle == false else { return }
//    获取两个标题中心点距离
    let centerDelta = rightLabel.st_left - leftLabel.st_left
//    标题宽度差值
    let widthDelta = _widthDeltaWithRightLabel(rightLabel, leftLabel: leftLabel)
//    获取移动距离
    let offsetDelta = offsetX - _lastOffsetX
//    计算当前下划线偏移量
    let underLineTransformX = offsetDelta * centerDelta / Commons.ScreenWidth
//    宽度递增偏移量
    let underLineWidth = offsetDelta * widthDelta / Commons.ScreenWidth
    if let _ = _underLine {
      if isBisectedWidthUnderLineAndTitle == true {
        let count = childViewControllers.count
        _underLine?.st_width = Commons.ScreenWidth / CGFloat(count)
        _underLine?.st_left = _underLine!.st_left + underLineTransformX
      } else {
        _underLine?.st_width = _underLine!.st_width / underLineWidth
        _underLine?.st_left = _underLine!.st_left + underLineTransformX
      }
    }
  }
  
//  设置遮盖偏移
  fileprivate func _setupCoverOffset(_ offsetX: CGFloat, rightLabel: UILabel, leftLabel: UILabel) {
    
    guard _isClickTitle == false else { return }
//    获取两个标题中心点距离
    let centerDelta = rightLabel.st_left - leftLabel.st_left
//    标题宽度差值
    let widthDelta = _widthDeltaWithRightLabel(rightLabel, leftLabel: leftLabel)
//    获取移动距离
    let offsetDelta = offsetX - _lastOffsetX
//    计算当前下划线偏移量
    let coverTransformX = offsetDelta * centerDelta / Commons.ScreenWidth
//    宽度递增偏移量
    let coverWidth = offsetDelta * widthDelta / Commons.ScreenWidth
    if let _ = _coverView {
      _coverView?.st_width += coverWidth
      _coverView?.st_left += coverTransformX
      /*_coverView!.snp.remakeConstraints({ (make) in
        make.width.equalTo(_coverView!.st_width + coverWidth)
        make.left.equalTo(_coverView!.st_left + coverTransformX)
      })*/
    }
  }
  
}

extension BiliViewController {
  
  // MARK: - Public Method
  
//  一次性设置所有标题属性
  func setupTitleEffect(_ titleScrollViewColor: UIColor, _ normalColor: UIColor, _ selectedColor: UIColor, _ titleFont: UIFont, _ titleHeight: CGFloat) {
    
  }
  
//  一次性设置所有下标属性
  func setupUnderLineEffect(_ _isShowUnderLine: Bool, _ _isDelayScroll: Bool?, _ _underLineH: CGFloat, _ _underLineColor: UIColor) {
//    是否显示标签
    isShowUnderLine = _isShowUnderLine
    isDelayScroll = _isDelayScroll
    underLineH = _underLineH
//    标题填充模式
    underLineColor = _underLineColor
  }
  
//  一次性设置所有字体缩放属性
  func setupTitleScale(_ _isShowTitleScale: Bool, _ _titleScale: CGFloat) {
    
    isShowTitleScale = _isShowTitleScale
    titleScale = _titleScale
  }
  
//  一次性设置所有颜色渐变属性
  func setupTitleGradient(_ _isShowTitleGradient: Bool, _ _titleColorGradientStyle: TitleColorGradientStyle, _ _startR: CGFloat, _ _startG: CGFloat, _ _startB: CGFloat, _ _endR: CGFloat, _ _endG: CGFloat, _ _endB: CGFloat) {
    
    isShowTitleGradient = _isShowTitleGradient
    titleColorGradientStyle = _titleColorGradientStyle
    startR = _startR
    startG = _startG
    startB = _startB
    endR = _endR
    endG = _endG
    endB = _endB
  }
  
//  一次性设置所有遮盖属性
  func setupCoverEffect(_ _isShowTitleCover: Bool, _ _coverColor: UIColor, _ _coverCornerRadius: CGFloat) {
    
    // ignore
  }
  
//  刷新标题和整个界面，在调用之前，必须先确定所有的子控制器。
  func refreshDisplay() {
    
//    清空之前所有标题
    _titleLabels.forEach {
      $0.removeFromSuperview()
    }
    _titleLabels.removeAll(keepingCapacity: false)
//    刷新表格
    _contentScrollView.reloadData()
//    重新设置标题
    _setupTitleWidth()
    _setupAllTitle()
  }
  
  // MARK: - NavigationBar Apperance
  
  /*func setWhiteTitleForNavigationBar(title: String) {
    let titleLabel = UILabel(frame: .zero)
    titleLabel.backgroundColor = UIColor.clear
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.textAlignment = .center
    titleLabel.textColor = UIColor.white
    titleLabel.text = title
    titleLabel.sizeToFit()
    
    navigationItem.titleView = titleLabel
  }*/
}

extension BiliViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
//  UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return childViewControllers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.ID, for: indexPath)
//    移除之前的子控件
    cell.contentView.subviews.forEach {
      $0.removeFromSuperview()
    }
//    添加控制器
    let vc = childViewControllers[indexPath.row]
    vc.view.frame = CGRect(origin: .zero, size: CGSize(width: _contentScrollView.st_width, height: _contentScrollView.st_height))
    cell.contentView.addSubview(vc.view)
    return cell
  }
  
//  UIScrollViewDelegate
  
//  减速完成
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    var offsetX = scrollView.contentOffset.x
    let offsetXInt = Int(offsetX)
    let screenWInt = Int(Commons.ScreenWidth)
    let extre = offsetXInt % screenWInt
    if CGFloat(extre) > Commons.ScreenWidth * 0.5 {
//      往右边移动
      offsetX = offsetX + (Commons.ScreenWidth - CGFloat(extre))
      _isAniming = true
      _contentScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    } else if CGFloat(extre) > Commons.ScreenWidth * 0.5 && extre > 0 {
      _isAniming = true
//      往左边移动
      offsetX = offsetX - CGFloat(extre)
      _contentScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
//    获取角标
    let i = Int(offsetX / Commons.ScreenWidth)
//    选中标题
    _selectLabel(_titleLabels[i])
//    取出对应控制器发出通知
    let vc = childViewControllers[i]
//    发出通知
    NotificationCenter.default.post(name: .init(BBK_DisplayView_ClickOrScrollDidFinshNote), object: vc)
  }
  
//  监听滚动动画是否完成
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
    _isAniming = false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
//    点击和动画的时候不需要设置
    guard let _ = _isAniming, _isAniming == false || _titleLabels.count != 0 else {
      return
    }
//    获取偏移量
    let offsetX = scrollView.contentOffset.x
//    获取左边角标
    let leftIndex = Int(offsetX / Commons.ScreenWidth)
//    左边按钮
    let leftLabel = _titleLabels[leftIndex]
//    右边角标
    let rightIndex = leftIndex + 1
//    右边按钮
    let rightLabel: BBKDisplayTitleLabel
    if rightIndex < _titleLabels.count {
      rightLabel = _titleLabels[rightIndex] as! BBKDisplayTitleLabel
    } else {
      rightLabel = BBKDisplayTitleLabel()
    }
//    字体放大
    _setupTitleScaleWithOffset(offsetX, rightLabel: rightLabel, leftLabel: leftLabel)
//    设置下标偏移
    if isDelayScroll == false { // 延迟滚动，不需要移动下标
      _setupUnderLineOffset(offsetX, rightLabel: rightLabel, leftLabel: leftLabel)
    }
//    设置遮盖偏移
    _setupCoverOffset(offsetX, rightLabel: rightLabel, leftLabel: leftLabel)
//    设置标题渐变
    _setupTitleColorGradientWithOffset(offsetX, rightLabel: rightLabel, leftLabel: leftLabel as! BBKDisplayTitleLabel)
//    记录上一次的偏移量
    _lastOffsetX = offsetX
  }
  
}

