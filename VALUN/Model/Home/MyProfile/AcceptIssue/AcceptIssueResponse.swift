//
//  AcceptIssueResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/17.
//

import Foundation

struct AcceptIssueResponse: Decodable {
    var message: String
    var data: String?
    var error: ErrorData?
}
