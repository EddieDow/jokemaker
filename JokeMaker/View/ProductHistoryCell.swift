//
//  ProductHistoryCell.swift
//  jokermaker
//
//  Created by Dou, Eddie on 2019/8/10.
//  Copyright © 2019 GuDuTou. All rights reserved.
//

import UIKit

class ProductHistoryCell: UITableViewCell {
    var imgView: UIImageView = UIImageView()
    var titleLab:UILabel = UILabel()
    var timeLab:UILabel = UILabel()
    var despLab:UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        imgView.image = UIImage.init(named: "Avatar.png")
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = UIColor.white
        self.addSubview(imgView)
        
        titleLab.font = .boldSystemFont(ofSize: 16)
        titleLab.textColor = .black
        self.addSubview(titleLab)
        
        timeLab.font = .systemFont(ofSize: 14)
        timeLab.textColor = .black
        self.addSubview(timeLab)
        
        despLab.font = .systemFont(ofSize: 14)
        despLab.textColor = .black
        despLab.numberOfLines = 0
        self.addSubview(despLab)
        
        titleLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.width.equalTo(100)
        }
        
        timeLab.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(21)
        }
        
        despLab.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(despLab.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-10)
            make.height.equalTo(300)
        })
    }
}
