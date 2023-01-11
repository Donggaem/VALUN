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
}

struct myReportIssueData: Decodable {
    var unsolveds: [Issue]
    var pendings: [WithSolution]
    var solveds: [WithSolution]
}

struct WithSolution: Decodable {
    var issue: Issue
    var solution: Solution
}

struct Solution: Decodable {
    var id: Int
    var userId: String
    var lat: Double
    var lng: Double
    var description: String
    var createdAt: String
    var imageUrl: String
    var isMine: Bool
}
