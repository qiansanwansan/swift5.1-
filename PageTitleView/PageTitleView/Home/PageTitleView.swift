//
//  PageTitleView.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/3.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {
    func pageTitleView(pageTitleView:PageTitleView,selected index : Int)
}

private let kNormalTitleColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedTitleColor : (CGFloat,CGFloat,CGFloat) = (255,120,0)

class PageTitleView: UIView {

    private var titles:[String]
    private var currentIndex:Int = 0
    weak var delegate:PageTitleViewDelegate?
    
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    private lazy var scrollLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: kSelectedTitleColor.0, g: kSelectedTitleColor.1, b: kSelectedTitleColor.2, a: 1)
        return view
    }()

    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:-设置UI界面
extension PageTitleView {
    private func setUpUI(){
        // 添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        // 添加对应lable
        setUpTitleLables()
        // 设置滑块
        setupScrollLine()
    }
    private func setUpTitleLables(){
        // 设置基础数据
        let labelW : CGFloat = kScreenW / CGFloat(titles.count)
        let labelH : CGFloat = 40.0
        let labelY: CGFloat =  0
        
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            
            label.text = title
            label.textAlignment = .center
            label.textColor = UIColor.init(r: kNormalTitleColor.0, g: kNormalTitleColor.1, b: kNormalTitleColor.2, a: 1)
            label.font = UIFont.systemFont(ofSize: 16)
            
            label.tag = index
            
            let labelX:CGFloat = labelW * CGFloat(index)
            
            label.frame = CGRect.init(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.titleClick(tap:)))
            label.addGestureRecognizer(tap)
            
        }
    }
    private func setupScrollLine() {
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.3
        bottomLine.frame = CGRect.init(x: 0, y: frame.height-lineH, width: frame.size.width, height: lineH)
        addSubview(bottomLine)
        
        scrollView .addSubview(scrollLine)
        guard let firstLabel = titleLabels.first else { return }
        
        firstLabel.textColor = UIColor.init(r: kSelectedTitleColor.0, g: kSelectedTitleColor.1, b: kSelectedTitleColor.2, a: 1)
        scrollLine.frame = CGRect.init(x: firstLabel.frame.origin.x, y: firstLabel.frame.size.height - 1, width: firstLabel.frame.size.width, height: 1)
    }
}
// MARK:- 监听事件
extension PageTitleView{
    /**
     @objc：
     自动清除冗余代码减小包大小
     得益于 Swift 的静态语言特性，每个函数的调用在编译期间就可以确定。因此在编译完成后可以检测出没有被调用到的 swift 函数，优化删除后可以减小最后二进制文件的大小。这个功能在 XCode 9 和 Swift 4 中终于被引进。相较于 OC 又多了一个杀手级特性。
     
     那么为什么 OC 做不到这点呢？因为在 OC 中调用函数是在运行时通过发送消息调用的。所以在编译期并不确定这个函数是否被调用到。因为这点在混合项目中引发了另外一个问题：swift 函数怎么知道是否被 OC 调用了呢？出于安全起见，只能保留所有可能会被 OC 调用的 swift 函数（标记为 @objc 的）。
     */
    @objc func titleClick(tap:UITapGestureRecognizer){
        guard let newLabel = tap.view as? UILabel else { return }
        let oldLabel = titleLabels[currentIndex]
        
        oldLabel.textColor = UIColor.init(r: kNormalTitleColor.0, g: kNormalTitleColor.1, b: kNormalTitleColor.2, a: 1)
        newLabel.textColor = UIColor.init(r: kSelectedTitleColor.0, g: kSelectedTitleColor.1, b: kSelectedTitleColor.2, a: 1)
        // 如果两次点选了同一个，直接return掉，这个看需求，有些是刷新
        if oldLabel == newLabel {
            return
        }
        currentIndex = newLabel.tag
        
        // 滚动条改变位置
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        delegate?.pageTitleView(pageTitleView: self, selected: currentIndex)
    }
}

extension PageTitleView{
    func setCurrentIndex(sourceIndex:Int,targetIndex:Int,process:CGFloat){
        let sourceLabel:UILabel = titleLabels[sourceIndex]
        let targetLabel:UILabel = titleLabels[targetIndex]
        
        currentIndex = targetIndex
        
        let moveTotalX = targetLabel.frame.minX - sourceLabel.frame.minX
        let moveX = moveTotalX * process
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 颜色渐变范围
        let colorDelta:(CGFloat,CGFloat,CGFloat) = (kSelectedTitleColor.0 - kNormalTitleColor.0,kSelectedTitleColor.1 - kNormalTitleColor.1,kSelectedTitleColor.2 - kNormalTitleColor.2)
        sourceLabel.textColor = UIColor.init(r: kSelectedTitleColor.0 - colorDelta.0*process, g: kSelectedTitleColor.1 - colorDelta.1*process, b: kSelectedTitleColor.2 - colorDelta.2 * process, a: 1)
        targetLabel.textColor = UIColor.init(r: kNormalTitleColor.0 + colorDelta.0*process, g:kNormalTitleColor.1 + colorDelta.1*process , b: kNormalTitleColor.2 + colorDelta.2*process, a: 1)
        
    }
}
