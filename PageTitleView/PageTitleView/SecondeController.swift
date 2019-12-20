//
//  SecondeController.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/4.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit
import MJRefresh
class SecondeController: UIViewController {
    var arrCount = 10
    var myPlus = 0
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "消息"
        view.backgroundColor = .red
        
        view.addSubview(tableView)
        tableView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH - )
        
        // 添加上下拉刷新
//        MJRefreshGifHeader
        let header:MJRefreshStateHeader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(headerAction)) //1
        header.lastUpdatedTimeLabel?.isHidden = true
//        header.beginRefreshing()
//        header.setTitle("下拉刷新", for: MJRefreshState.idle)
//        header.setTitle("正在刷新", for: MJRefreshState.refreshing)
//        header.setTitle("刷新完成", for: MJRefreshState.noMoreData)
        tableView.mj_header = header
        let footer:MJRefreshFooter = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(footerAction))
        tableView.mj_footer = footer
        // Do any additional setup after loading the view.
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
        tableView.mj_header?.endRefreshing {
            print("已经停止下拉刷新")
            self.myPlus += 1
            self.tableView.reloadData()
//            self.myPlus = 0
        }
        tableView.mj_footer?.endRefreshing {
            print("已经停止上拉刷新")
            self.arrCount += 5
            self.tableView.reloadData()
        }
    }

    
    
    
    

}

extension SecondeController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "FYCellID"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) ?? nil
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
        }
        
        cell!.textLabel?.text = String(indexPath.row + myPlus)
        return cell!
    }
}
