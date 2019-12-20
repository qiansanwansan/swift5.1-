//
//  GameView.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/12.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

class GameView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var gameArray:[RoomModel] = [RoomModel]() {
        didSet{
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = []
        
        let layou = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layou.scrollDirection = .horizontal
        collectionView.register(UINib.init(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension GameView {
    class func gameView() -> GameView {
        return Bundle.main.loadNibNamed("GameView", owner: nil, options: nil)?.first as! GameView
    }
}

extension GameView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        let model = self.gameArray[indexPath.item]
        cell.model = model
        return cell
    }
    
}

extension GameView : UICollectionViewDelegate{
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print("这里一定要挂代理，才能响应，但是轮播模块没有挂代理也行，很奇怪"),在xib文件中
    //    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:RoomModel = gameArray[indexPath.row]
        print(model.tag_name!)
    }
}

