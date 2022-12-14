//
//  VALUNLog.swift
//  VALUN
//
//  Created by κΉλκ²Έ on 2023/01/05.
//

import Foundation

final public class VALUNLog {
  
  public class func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    print("π [\(getCurrentTime())] VALUN - \(output)", terminator: terminator)
    #else
    print("π [\(getCurrentTime())] VALUN - RELEASE MODE")
    #endif
  }
  
  public class func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    print("π¨ [\(getCurrentTime())] VALUN - \(output)", terminator: terminator)
    #else
    print("π¨ [\(getCurrentTime())] VALUN - RELEASE MODE")
    #endif
  }
  
  
  
  
  fileprivate class func getCurrentTime() -> String {
    let now = NSDate()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: now as Date)
  }
}
