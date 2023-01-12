//
//  myReportIssue.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/11.
//

import Foundation

struct myReportIssueResponse: Decodable {
    var message: String
    var data: myReportIssueData?
    var error: ErrorData?
}

struct myReportIssueData: Decodable {
    var unsolveds: [Issue]
    var pendings: [WithSolution]
    var solveds: [WithSolution]
}
