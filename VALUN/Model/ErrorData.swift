//
//  ErrorData.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/05.
//

import Foundation

struct ErrorData: Decodable {
    
    var code: Int
    var message: String
    var timestamp: Date
}
