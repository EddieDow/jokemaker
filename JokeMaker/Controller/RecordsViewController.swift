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
        let dic = defaults.object(forKey: key) as! NSDictionary
        cell.titleLab?.text = dic["userName"] as? String ?? ""
        cell.despLab?.text = dic["content"] as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("第\(indexPath.row)行被点击了")
    }

}
