//
//  Issue.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/08.
//

import Foundation

struct Issue: Decodable {
    
    var id: Int
    var userId: String
    var status: String // UNSOLVED, PENDING, SOLVED, REPORTED 4종류
    var description: String
    var lat: Double
    var lng: Double
    var createdAt: String
    var category: String
    var imageUrl: String
    var isMine: Bool
}
