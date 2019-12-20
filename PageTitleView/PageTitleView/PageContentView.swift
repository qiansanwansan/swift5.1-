//
//  PageContentView.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/5.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate:class {
    func pageContentView(source sourceIndex:Int,target targetIndex:Int,process processNum:CGFloat)
}

private let ContentCellID = "contentCellID"
class PageContentView: UIView {
    
    // 添加属性
    private var childVCs : [UIViewController]
    private weak var parentVC : UIViewController?
    private var beganOffsetX:CGFloat = 0
    weak var delegate:PageContentViewDelegate?
    private var isForbidenScrollDelegate = false
    
    
    init(frame: CGRect,childVC:[UIViewController],parentVC:UIViewController?) {
        self.childVCs = childVC
        self.parentVC = parentVC
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView : UICollectionView = { [weak self] in
        // 创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        // 创建UICollectionView
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    

}

extension PageContentView{
    private func setupUI(){
        for child in childVCs {
            parentVC?.addChild(child)
        }
        addSubview(collectionView)
        collectionView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}

extension PageContentView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        // 偷梁换柱
        let view = childVCs[indexPath.item].view!
        view.frame = cell.bounds // 这个千万不能忘记
//        view.backgroundColor = UIColor.randomColor()
        cell.contentView.addSubview(view)

//        let label = UILabel.init(frame: CGRect.init(x: 55, y: 55, width: 199, height: 44))
//        label.text = "sfasdfasdf"
//        view.addSubview(label)
        return cell
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beganOffsetX = scrollView.contentOffset.x
        isForbidenScrollDelegate = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidenScrollDelegate {
            return
        }
        print(scrollView.contentOffset.x)
        
        let nowOffsetX:CGFloat = scrollView.contentOffset.x
        
        var sourceIndex:Int
        var targetIndex:Int
        var process:CGFloat
        let index:CGFloat = nowOffsetX/scrollView.frame.width
        // 左滑
        if nowOffsetX > beganOffsetX {
            // 确定process
            process = index - CGFloat(floor(index))
            // 计算sourceIndex
            sourceIndex = Int(index)
            // 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = sourceIndex // childVCs.count - 1
//                targetIndex = childVCs.count - 1
            }
            // 完全滑过去
            if nowOffsetX - beganOffsetX == scrollView.frame.width{
                process = 1
                targetIndex = sourceIndex
            }
            
        } else {
            // 右滑
            // 确定process
            process = 1 - (index - CGFloat(floor(index)))
            // 计算sourceIndex
            targetIndex = Int(index)
            // 计算targetIndex
            sourceIndex = targetIndex + 1
            // 完全滑过去
            if sourceIndex >= childVCs.count {
                process = 1
                sourceIndex = targetIndex
            }
        }
        
        delegate?.pageContentView(source: sourceIndex, target: targetIndex, process: process)
    }
    
    
}

extension PageContentView{
    func setCurrentIndex(currentIndex:Int) {
        isForbidenScrollDelegate = true
        
        let offsetX:CGFloat = CGFloat(currentIndex) * self.frame.width
        collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
}
