//
//  RecentIssueFSPagerViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/09.
//

import Foundation
import FSPagerView

class RecentIssueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var recentIssueImageView: UIImageView!{
        didSet {
            recentIssueImageView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var destanceLabel: UILabel!
    @IBOutlet var issueCategoryLabel: UILabel!
    
    
}
