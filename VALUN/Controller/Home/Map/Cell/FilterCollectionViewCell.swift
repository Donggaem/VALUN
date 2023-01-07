//
//  FilterCollectionViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/28.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var filterView: UIView!{
        didSet {
            
            filterView.layer.cornerRadius = 14
            
            
        }
    }
    @IBOutlet var filterTitle: UILabel!
    
    var cellBool = false {
        didSet {
            if cellBool == true {
                filterView.backgroundColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
                filterTitle.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }else {
                filterTitle.textColor =  UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                filterView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }
    
//    override var isSelected: Bool {
//            didSet {
//                if isSelected {
//                    if cellBool == false {
//                        
//                        cellBool = true
//                    }else {
//                        
//                        cellBool = false
//
//                    }
//                }
//            }
//        }
}
