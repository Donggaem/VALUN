//
//  myReportIssue.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/11.
//

import Foundation

struct MyReportIssueResponse: Decodable {
    var message: String
    var data: MyReportIssueData?
    var error: ErrorData?
}

struct MyReportIssueData: Decodable {
    var unsolveds: [Issue]
    var pendings: [WithSolution]
    var solveds: [WithSolution]
}
