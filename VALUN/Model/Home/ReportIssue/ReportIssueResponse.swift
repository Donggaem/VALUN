//
//  ReportIssueResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/08.
//

import Foundation

struct ReportIssueResponse: Decodable {
    
    var message: String
    var data: ReportIssueData?
    var error: ErrorData?
}

struct ReportIssueData: Decodable {
    var id: Int
    var createdAt: String
}
