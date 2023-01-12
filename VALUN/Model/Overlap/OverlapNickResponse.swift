//
//  OverlapNickResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/12.
//

import Foundation

struct OverlapNickResponse: Decodable {
    var message: String
    var data: OverlapNickData?
    var error: ErrorData?
}

struct OverlapNickData: Decodable {
    var available: Bool
}
