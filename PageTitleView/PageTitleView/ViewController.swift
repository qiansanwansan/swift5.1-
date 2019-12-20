//
//  ViewController.swift
//  PageTitleView
//
//  Created by macbook on 2019/12/3.
//  Copyright © 2019 常用测试demo. All rights reserved.
//

import UIKit

private let kPageTitleH:CGFloat = 40

class ViewController: UIViewController {

    
    //MARK:-懒加载属性
    private lazy var pageTitleView: PageTitleView = { [weak self] in
        let titles = ["推荐","游戏","娱乐","趣玩","任务"]
        let titleView = PageTitleView.init(frame: CGRect.init(x: 0, y: kNavAndStateH, width: kScreenW, height: kPageTitleH), titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView: PageContentView = { [weak self] in
        let pageFrame : CGRect = CGRect.init(x: 0, y: kNavAndStateH + kPageTitleH, width: view.frame.width, height: kScreenH - kNavAndStateH - KTabBarH - kPageTitleH)
        
        var childVCs = [UIViewController]()
        let recommendVC = RecommendVC()
        childVCs.append(recommendVC)
        for i in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = .white
//            vc.view.backgroundColor = UIColor.init(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)), alpha: 1)
            childVCs.append(vc)
        }
        
        let pageContentView = PageContentView.init(frame: pageFrame, childVC: childVCs, parentVC: self)
        pageContentView.delegate = self
        return pageContentView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = .purple
        view.backgroundColor = .white
        setupUI()
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        navigationController?.pushViewController(SecondeController(), animated: true)
//    }

}

// MARK: -设置导航头部
extension ViewController{
    private func setupUI(){
        // 不要调整ScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        // 设置导航栏
        setupNavigationBar()
    }
    private func setupNavigationBar(){
        // left NavgationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIImageView.init(image: UIImage.init(named: "logo")))
        // right NavigationBar
        let scanItem = UIBarButtonItem.init(image: UIImage.init(named: "Image_scan"), landscapeImagePhone: UIImage.init(named: "Image_scan_click"), style: UIBarButtonItem.Style.done, target: self, action: #selector(scanClick))
        let searchItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(scanClick))

        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "image_my_history"), for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "Image_my_history_click"), for: UIControl.State.highlighted)
        btn.addTarget(self, action: #selector(scanClick), for: UIControl.Event.touchUpInside)
        let historyItem = UIBarButtonItem.init(customView: btn)
//        historyItem.backgroundImage(for: <#T##UIControl.State#>, barMetrics: <#T##UIBarMetrics#>)
        // 多种创建方式
        navigationItem.rightBarButtonItems = [scanItem,searchItem,historyItem]
        
    }
    @objc private func scanClick(){
        print("二维码")
    }
}
// MARK: -PageTitleViewDelegate
extension ViewController : PageTitleViewDelegate{
    func pageTitleView(pageTitleView: PageTitleView, selected index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

extension ViewController : PageContentViewDelegate{
    func pageContentView(source sourceIndex: Int, target targetIndex: Int, process processNum: CGFloat) {
//        print(sourceIndex,processNum)
        pageTitleView.setCurrentIndex(sourceIndex: sourceIndex, targetIndex: targetIndex, process: processNum)
    }
}
