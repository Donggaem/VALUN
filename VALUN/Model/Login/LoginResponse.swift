//
//  LoginResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/05.
//

import Foundation

struct LoginResponse: Decodable {
    
    var message: String
    var data: LoginData?
    var error: ErrorData?
}
struct LoginData: Decodable {
    
    var accessToken: String
}
