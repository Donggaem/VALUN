//
//  VALUNLog.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/05.
//

import Foundation

final public class VALUNLog {
  
  public class func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    print("💚 [\(getCurrentTime())] VALUN - \(output)", terminator: terminator)
    #else
    print("💚 [\(getCurrentTime())] VALUN - RELEASE MODE")
    #endif
  }
  
  public class func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    print("🚨 [\(getCurrentTime())] VALUN - \(output)", terminator: terminator)
    #else
    print("🚨 [\(getCurrentTime())] VALUN - RELEASE MODE")
    #endif
  }
  
  
  
  
  fileprivate class func getCurrentTime() -> String {
    let now = NSDate()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: now as Date)
  }
}
