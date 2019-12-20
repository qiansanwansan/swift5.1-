//
//  CycleView.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/5.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

class CycleView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var cycleTimer:Timer?
    private var currentIndex:Int?
    var modelArr:[CycleModel] = [CycleModel]() {
        didSet{
            collectionView.reloadData()
            currentIndex = 0
            pageControl.numberOfPages = self.modelArr.count
            pageControl.addTarget(self, action: #selector(pageValueDidChange), for: UIControl.Event.valueChanged)
            pageControl.isUserInteractionEnabled = false
            let indexPath = IndexPath.init(item: self.modelArr.count * 100, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            removeTimer()
            addTimer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = []
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        collectionView.frame = self.bounds
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: frame.width, height: frame.height)
        collectionView.register(UINib.init(nibName: "CycleCell", bundle: nil), forCellWithReuseIdentifier: "CycleCell")
    }
    
    
}

extension CycleView{
    
    class func cycleView() -> CycleView{
        return Bundle.main.loadNibNamed("CycleView", owner: nil, options: nil)?.first as! CycleView
    }
}

extension CycleView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CycleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CycleCell", for: indexPath) as! CycleCell
        let model = modelArr[indexPath.item % modelArr.count]
        cell.model = model
//        print(model.title! as Any)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr.count * 10000
    }
}
extension CycleView:UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width:CGFloat = self.frame.width
        
        let virtualOffsetX = scrollView.contentOffset.x + width * 0.5
        let index:Int = Int(virtualOffsetX/width)
        pageControl.currentPage = index % modelArr.count
        currentIndex = index
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}
extension CycleView{
    @objc func timerOccur(){
        let  currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.frame.width
        collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
    func addTimer(){
        cycleTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerOccur), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
    }
    func removeTimer(){
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
}

extension CycleView{
    @objc func pageValueDidChange(){
//        removeTimer()
        // 对应改变轮播
        
        /*
         思路：
         获取当前显示的index
         直接简单的向右相加或左相加
         */
//        let currentPage = pageControl.currentPage
//        print(currentPage)
//        var frame = collectionView.frame
//        frame.origin.x = CGFloat(currentIndex!)*frame.width * 100
//        frame.origin.y = 0
//        collectionView.scrollRectToVisible(frame, animated: false)
//
//        frame.origin.x = CGFloat(currentIndex!)*frame.width * 100 + CGFloat(currentPage)*frame.width
//        frame.origin.y = 0
//        collectionView.scrollRectToVisible(frame, animated: true)
//
//        let indexPath = IndexPath.init(item: currentPage, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
//        addTimer()
    }
}
