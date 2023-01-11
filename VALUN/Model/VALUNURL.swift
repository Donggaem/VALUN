//
//  VALUNURL.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/05.
//

import Foundation

struct VALUNURL {
    
    //MARK: - Base
    static let baseAuthURL = "http://valun.kro.kr/auth"
    static let baseUserURL = "http://valun.kro.kr/user"
    
    //MARK: - Login
    static let loginURL = "http://valun.kro.kr/auth/login"
    
    //MARK: - Signup
    static let signupURL = "http://valun.kro.kr/user/signup"
    
    //MARK: - MyProfile
    static let myProfileURL = "http://valun.kro.kr/user/my/profile"
    
    //MARK: - RecentIssue
    static let recentIssueURL = "http://valun.kro.kr/issues/recent"
    
    //MARK: - NearIssue
    static let nearIssueURL = "http://valun.kro.kr/issues/around"
    
    //MARK: - postIssue
    static let reportIssueURL = "http://valun.kro.kr/issues"
}

