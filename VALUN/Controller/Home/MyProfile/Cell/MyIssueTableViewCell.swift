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
    
    var status = "" {
        didSet {
            if issueStateLabel.text == "미해결" {
                
                issueStateLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                issueStateView.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
            }else if issueStateLabel.text == "해결중"  {
                
                issueStateLabel.textColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1)
                issueStateView.layer.borderColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1).cgColor
            }else if issueStateLabel.text == "해결완료"  {
                
                issueStateLabel.textColor =  UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
                issueStateView.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor
            }else if issueStateLabel.text == "신고됨"  {
                
                issueStateLabel.textColor =  UIColor(red: 0.486, green: 0.416, blue: 0.769, alpha: 1)
                issueStateView.layer.borderColor = UIColor(red: 0.486, green: 0.416, blue: 0.769, alpha: 1).cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
