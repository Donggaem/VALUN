//
//  myProfileResponse.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/08.
//

import Foundation

struct myProfileResponse: Decodable {
    
    var message: String
    var data: MyProfileData?
    var error: ErrorData?
    
}
struct MyProfileData: Decodable {
    var profile: ProfileData
}

struct ProfileData: Decodable {
    var id: String
    var nick: String
    var broom: Int
    var profileImage: String
}
