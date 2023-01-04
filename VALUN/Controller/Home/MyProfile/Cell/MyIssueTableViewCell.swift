//
//  MyIssueTableViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit

class MyIssueTableViewCell: UITableViewCell {

    @IBOutlet var issueImage: UIImageView!{
        didSet {
            issueImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet var issueStateView: UIView! {
        didSet {
            issueStateView.layer.cornerRadius = 12
            issueStateView.layer.borderWidth = 1
            issueStateView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
            
        }
    }
    @IBOutlet var issueStateLabel: UILabel!
    @IBOutlet var issueCategoryLabel: UILabel!
    @IBOutlet var issueContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
