//
//  FilterCollectionViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/28.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var filterView: UIView! {
        didSet {
            filterView.layer.cornerRadius = 14
            filterView.layer.borderWidth = 1
            filterView.layer.borderColor = UIColor(red: 0.587, green: 0.587, blue: 0.587, alpha: 1).cgColor
        }
    }
    @IBOutlet var filterTitle: UILabel!
    
    @IBOutlet var filterBtn: UIButton! {
        didSet {
            
            filterBtn.layer.cornerRadius = 14
            filterBtn.layer.borderWidth = 1
            filterBtn.layer.borderColor = UIColor(red: 0.587, green: 0.587, blue: 0.587, alpha: 1).cgColor
        }
    }
}
