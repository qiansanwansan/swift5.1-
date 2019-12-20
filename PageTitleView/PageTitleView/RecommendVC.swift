
//
//  RecommondVC.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/6.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import MJRefresh

private let kItemMargin: CGFloat = 10.0
private let kNormalItemW = (kScreenW - kItemMargin * 3)/2
private let kNormalItemH = kNormalItemW * 3 / 4
private let kPrettyItemH = kNormalItemW * 4 / 3
private let kCycleH:CGFloat = 3/8 * kScreenW

class RecommendVC: UIViewController {
    let viewModel = ViewModel()

    private lazy var collectionView:UICollectionView = {[unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        layout.headerReferenceSize = CGSize.init(width: kScreenW, height: 50)
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        collectionView.register(UINib.init(nibName: "NormalViewCell", bundle: nil
        ), forCellWithReuseIdentifier: "NormalViewCell")
        collectionView.register(UINib.init(nibName: "PrettyCell", bundle: nil), forCellWithReuseIdentifier: "PrettyCell")
        collectionView.register(UINib.init(nibName: "SectionHeader", bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        return collectionView
    }()
    
    private lazy var cycleView:CycleView = {
        let cycleView = CycleView.cycleView()
        cycleView.backgroundColor = .red
        cycleView.frame = CGRect.init(x: 0, y: -kCycleH-90, width: kScreenW, height: kCycleH)
        return cycleView
    }()
    private lazy var gameView:GameView = {
        let gameView = GameView.gameView()
        gameView.frame = CGRect.init(x: 0, y: -90, width: kScreenW, height: 90)
        
        return gameView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        viewModel.requestData {
            self.collectionView.reloadData()
        }
        viewModel.requestCycleData {
            self.cycleView.modelArr = self.viewModel.cycleArray
        }
        viewModel.requestGameData {
            self.gameView.gameArray = self.viewModel.gameArray
        }
        
        // 添加上下拉刷新
//        let header:MJRefreshHeader = MJRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(headerAction))
//        collectionView.mj_header = header
//        let footer:MJRefreshFooter = MJRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerAction))
//        collectionView.mj_footer = footer
        let header:MJRefreshHeader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(headerAction))
        collectionView.mj_header = header
        header.ignoredScrollViewContentInsetTop = kCycleH+90
        //        let footer:MJRefreshFooter = MJRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerAction))
        //        tableView.mj_footer = footer
        let footer:MJRefreshFooter = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(footerAction))
        collectionView.mj_footer = footer
    }

    @objc func headerAction(){
        print("下拉刷新")
        perform(#selector(stopRefresh), with: self, afterDelay: 3)
    }
    @objc func footerAction(){
        print("上拉刷新")
        perform(#selector(stopRefresh), with: self, afterDelay: 3)
    }
    @objc func stopRefresh(){
        collectionView.mj_header?.endRefreshing {
            print("已经停止下拉刷新")
        }
        collectionView.mj_footer?.endRefreshing {
            print("已经停止上拉刷新")
        }
    }

}
extension RecommendVC{
    func setupUI(){
        self.view.backgroundColor = .red
        collectionView.addSubview(cycleView)
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets.init(top: kCycleH+90, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(gameView)
    
    }
}

extension RecommendVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("总个数为：\(self.viewModel.recommondArray.count)")
        return self.viewModel.recommondArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let recommendModel = self.viewModel.recommondArray[section]
        return recommendModel.room_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recommendModel = self.viewModel.recommondArray[indexPath.section]
        if indexPath.section == 1 {
            let cell:PrettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrettyCell", for: indexPath) as! PrettyCell
            cell.roomModel = recommendModel.room_list[indexPath.row]
            return cell
        }
        let cell:NormalViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalViewCell", for: indexPath) as! NormalViewCell
        cell.roomModel = recommendModel.room_list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header:SectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        let recommendModel:RecommendModel = self.viewModel.recommondArray[indexPath.section]
        header.recommdendModel = recommendModel
        print(recommendModel.icon_name)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize.init(width: kNormalItemW, height: kPrettyItemH)
        }
        return CGSize.init(width: kNormalItemW, height: kNormalItemH)
    }
    
}
/*
 let imageView1:UIImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 111, width: 200, height: 200))
 imageView1.kf.setImage(with: URL.init(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575955063206&di=2b45d0c008cfa4d6032b461e872fa181&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201111%2F12%2F20111112151919_Whjz4.gif"))
 view.addSubview(imageView1)
 
 let imageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 320, width: 100, height: 100))
 //        imageView1.animationImages =
 //        imageView1.image = UIImage.init(named: "gifx")
 //        view.addSubview(imageView)
 // 1.获取图片路径。
 guard let filePath = Bundle.main.path(forResource: "timg.gif", ofType: nil) else { return }
 //根据路径转为data
 guard let fileData = NSData(contentsOfFile: filePath) else { return }
 // 2.根据Data获取CGImageSource对象
 guard let imageSource = CGImageSourceCreateWithData(fileData, nil) else { return }
 // 3.获取gif图片中图片的个数
 let frameCount = CGImageSourceGetCount(imageSource)
 //获取每一帧图片的时间。
 var duration : TimeInterval = 0
 //图片数组
 var images = [UIImage]()
 for i in 0..<frameCount {
 // 3.1.获取图片
 guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
 // 3.2.获取时长 每一帧的时间。
 guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else {continue}
 guard let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary else {continue}
 guard let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
 duration += frameDuration.doubleValue
 let image = UIImage(cgImage: cgImage)
 images.append(image)
 }
 // 4.播放图片
 imageView.animationImages = images
 imageView.animationDuration = duration
 //0无限播放。
 imageView.animationRepeatCount = 0
 imageView.startAnimating()
 view.addSubview(imageView)
 
 */
