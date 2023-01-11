//
//  ResolutionIssueRequest.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/11.
//

import Foundation

struct ResolutionIssueRequest: Encodable {
    
    var issueId: Int
    var description: String
    var lat: Double
    var lng: Double
    var image: Data
}
