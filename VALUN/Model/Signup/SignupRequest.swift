//
//  SignupRequest.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/05.
//

import Foundation

struct SignupRequest: Encodable {
    
    var id: String
    var pw: String
    var nick: String
}
