//
//  ReportIssueRequest.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/08.
//

import Foundation

struct ReportIssueRequest: Encodable {
    
    var description: String
    var category: String
    var lat: Double
    var lng: Double
    var image: Data

}

