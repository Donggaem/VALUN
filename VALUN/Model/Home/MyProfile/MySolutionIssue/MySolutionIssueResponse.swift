//
//  MySolutionIssueResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/12.
//

import Foundation

struct MySolutionIssueResponse: Decodable {
    
    var message: String
    var data: MySolutionIssueData?
    var error: ErrorData?
}

struct MySolutionIssueData: Decodable {
    var pendings: [WithSolution]
    var solveds: [WithSolution]
}
