//
//  SignupResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/05.
//

import Foundation

struct SignupResponse: Decodable {
    
    var message: String
    var data: SignupData?
    var error: ErrorData?
}
struct SignupData: Decodable {
    
    var id: String
    var nick: String
}
