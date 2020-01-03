//
//  MineController.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/25.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import YPImagePicker
import Kingfisher

class MineController: UIViewController {
    private lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        view.addSubview(tableView)
        tableView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH - kTabBarH)
        
    }

}
extension MineController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell:AvatarCell = Bundle.main.loadNibNamed("AvatarCell", owner: self, options: nil)?.last as! AvatarCell
            cell.textLabel?.text = "头像"
            return cell
        }
        if indexPath.row == 1{
            let CellID = "FYCellID"
            let cacheCell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellID)
            cacheCell.textLabel?.text = "清理缓存"
            
            let cacheNumLabel = UILabel.init(frame: CGRect.init(x: kScreenW - 80, y: 0, width: 60, height: 60.0))
            cacheCell.contentView.addSubview(cacheNumLabel)
            cacheNumLabel.text = "正在计算大小"
            cacheNumLabel.textAlignment = .right
            ImageCache.default.calculateDiskCacheSize { (usedDiskCacheSize) in
                DispatchQueue.main.async {
                    cacheNumLabel.text = "\(usedDiskCacheSize/(1024*1024))M"
                }
            }
        
            return cacheCell
        }
        
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    //                print(photo.fromCamera) // Image source (camera or library)
                    print(photo.image) // Final image selected by the user
                    //                print(photo.originalImage) // original image selected by the user, unfiltered
                    //                print(photo.modifiedImage) // Transformed image, can be nil
                    //                print(photo.exifMeta) // Print exif meta data of original image.
                    let cell = tableView.cellForRow(at: indexPath) as! AvatarCell
                    DispatchQueue.main.async {
                        cell.avatarView?.image = photo.image.af_imageRoundedIntoCircle()
                    }
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        } else {
            // 提示框
            let alert = UIAlertController(title: "清空缓存", message: "确定要清空缓存吗？", preferredStyle: UIAlertController.Style.alert)
            let alertConfirm = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (alertConfirm) -> Void in
                self.clearCache()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            alert.addAction(alertConfirm)
            let cancle = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (cancle) -> Void in
            }
            alert.addAction(cancle)
            // 提示框弹出
            present(alert, animated: true) {
                
            }
            
        }
        
    }
    // 清理缓存
    func clearCache(){
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
        
    }
    
}

/*
 // 也可以通过以下方式计算缓存大小，但是会将一些我们没有操作权限的文件也计算进去（目前我是这样认为的，可以进行筛选）
 // 取出cache文件夹路径
 let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
 // 打印路径,需要测试的可以往这个路径下放东西
 print(cachePath)
 // 取出文件夹下所有文件数组
 let files = FileManager.default.subpaths(atPath: cachePath!)
 // 用于统计文件夹内所有文件大小
 var big = Int();
 
 
 // 快速枚举取出所有文件名
 for p in files!{
 // 把文件名拼接到路径中
 let path = cachePath!.appendingFormat("/\(p)")
 // 取出文件属性
 let floder = try! FileManager.default.attributesOfItem(atPath: path)
 // 用元组取出文件大小属性
 for (abc,bcd) in floder {
 // 只去出文件大小进行拼接
 if abc == FileAttributeKey.size{
 big += (bcd as AnyObject).integerValue
 }
 }
 }
 let message = "\(big/(1024*1024))M缓存"
 
 // 点击确定时开始删除
 for p in files!{
 // 拼接路径
 let path = cachePath!.appendingFormat("/\(p)")
 // 判断是否可以删除
 if(FileManager.default.fileExists(atPath: path)){
 // 删除
 try! FileManager.default.removeItem(atPath: path)
 }
 }

 */
