//
//  RecordsViewController.swift
//  jokermaker
//
//  Created by Dou, Eddie on 2019/8/10.
//  Copyright © 2019 GuDuTou. All rights reserved.
//

import UIKit

@objc class RecordsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView:UITableView?
    var indexs = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "本地作品集"
        setupHistoryData()
        setupTableView()
    }
    
    func setupHistoryData() {
        let defaults = UserDefaults.standard
        indexs = defaults.object(forKey: kMomentIndex) as? NSArray ?? NSMutableArray()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.register(ProductHistoryCell.self, forCellReuseIdentifier: "ProductHistoryCell")
        view.addSubview(tableView!)
        tableView?.estimatedRowHeight = 44.0
        tableView?.rowHeight = UITableView.automaticDimension
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHistoryCell", for: indexPath) as! ProductHistoryCell
        let key = indexs[indexPath.row] as? String ?? ""
        let defaults = UserDefaults.standard
        let dic = defaults.object(forKey: key) as? NSDictionary ?? NSDictionary()
        cell.titleLab.text = dic["userName"] as? String ?? ""
        cell.despLab.text = dic["content"] as? String ?? ""
        cell.timeLab.text = dic["created_time"] as? String ?? ""
        
        let productPath = dic["product"] as? String ?? ""
        let img = AppUtils.readCachedImage(productPath)
        cell.imgView.image = img
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alertController = UIAlertController(title: "", message: "警告!!! 删除数据将不可恢复!", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: { action in
            self.deleteProduct(index: indexPath.row)
        })
        
        let editAction = UIAlertAction(title: "编辑", style: .default, handler: { action in
            self.editProduct(index: indexPath.row)
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteProduct(index: Int) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: false)
        hud.mode = .indeterminate
        hud.label.text = "删除中..."
        DispatchQueue.global().async {
            let contentKey = self.indexs.object(at: index) as? String ?? ""
            AppUtils.deleteCachedProduct(contentKey)
            self.setupHistoryData()
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.tableView?.reloadData()
                FFToast.show(withTitle: "提示", message: "本地缓存数据已经删除.", iconImage: UIImage.init(named: "fftoast_success_highlight.png"), duration: 2, toastType: .default)
            }
        }
    }
    
    func editProduct(index: Int) {
        //Read cached data as Object Moments
        let defaults = UserDefaults.standard
        let contentKey = indexs.object(at: index) as? String ?? ""
        let dic = defaults.object(forKey: contentKey) as? NSDictionary ?? NSDictionary()
        let moment = Moments.init()
        moment.userName = dic.value(forKey: "userName") as? String ?? ""
        moment.content = dic.value(forKey: "content") as? String ?? ""
        moment.location = dic.value(forKey: "location") as? String ?? ""
        moment.time = dic.value(forKey: "time") as? String ?? ""
        let likes = dic.value(forKey: "likes") as? NSArray ?? NSArray()
        moment.likes = likes.mutableCopy() as? NSMutableArray
        
        let avatarImageName = String.init(format: "%@_avatar.png", contentKey)
        moment.avatar = AppUtils.readCachedImage(avatarImageName)
        
        let keyImages = dic.value(forKey: "arrImage") as? NSArray ?? NSArray()
        let images = NSMutableArray.init()
        for key in keyImages {
            let image = AppUtils.readCachedImage(key as? String)
            images.add(image)
        }
        moment.arrImage = images
        
        let comments = dic.value(forKey: "comments") as? NSArray ?? NSArray()
        let mComents = NSMutableArray.init()
        for comment in comments {
            let commentItem = CommentItem.init()
            let dicComment = comment as! NSDictionary
            commentItem.userNick = dicComment.value(forKey: "userNick") as? String ?? ""
            commentItem.replyUserNick = dicComment.value(forKey: "replyUserNick") as? String ?? ""
            commentItem.comment = dicComment.value(forKey: "comment") as? String ?? ""
            mComents.add(commentItem)
        }
        moment.comments = mComents
        AppUtils.setMoment(moment)
        
        let firstVC = FirstStepViewController.init(nibName: "FirstStepViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(firstVC, animated: true)
    }

}
