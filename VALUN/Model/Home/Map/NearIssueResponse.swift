//
//  NearIssueResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/10.
//

import Foundation

struct NearIssueResponse: Decodable {
    var message: String
    var data: NearIssueData?
    var error: ErrorData?
}

struct NearIssueData: Decodable {
    var issues: [Issue]
}
