//
//  OverlapIdResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/12.
//

import Foundation

struct OverlapIdResponse: Decodable {
    var message: String
    var data: OverlapIdData?
    var error: ErrorData?
}

struct OverlapIdData: Decodable {
    var available: Bool
}
