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
    var titleLab:UILabel?
    var despLab:UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        imgView.image = UIImage.init(named: "Avatar.jpg")
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 1.0
        self.addSubview(imgView)
        
        let label1 = UILabel()
        label1.font = .systemFont(ofSize: 16)
        label1.textColor = .black
        self.addSubview(label1)
        titleLab = label1
        
        let label2 = UILabel()
        label2.font = .systemFont(ofSize: 14)
        label2.textColor = .black
        label2.numberOfLines = 0
        self.addSubview(label2)
        despLab = label2;
        
        imgView.snp.makeConstraints({ (make) in
            make.top.left.equalTo(10)
            make.width.height.equalTo(40)
        })
        
        label1.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(21)
        }
        
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
}
