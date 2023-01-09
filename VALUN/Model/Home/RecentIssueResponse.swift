//
//  RecentIssueResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/08.
//

import Foundation

struct RecentIssueResponse: Decodable {
    
    var message: String
    var data: RecentIssueData?
    var error: ErrorData?
}

struct RecentIssueData: Decodable {
    var issues: [Issue]
}
