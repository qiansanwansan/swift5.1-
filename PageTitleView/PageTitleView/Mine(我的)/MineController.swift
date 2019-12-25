//
//  MineController.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/25.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import YPImagePicker

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
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let_ = "FYCellID"
        
//        if indexPath.row == 0{
        let cell:AvatarCell = Bundle.main.loadNibNamed("AvatarCell", owner: self, options: nil)?.last as! AvatarCell
//        }
        cell.textLabel?.text = "头像"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
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
        
    }
    
}

