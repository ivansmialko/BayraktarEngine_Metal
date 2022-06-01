//
//  Logger.swift
//  BayraktarEngine
//
//  Created by Alexei Liaskoskyi on 01.06.2022.
//

import Foundation

enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

func print(_ object: Any) {
  #if DEBUG
      Swift.print(object)
  #endif
}

class Logger
{
    static var dateFormat = "yyyy-MM-dd hh:mm::ssSSS"
    static var dateFormatter : DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String
    {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func logError(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function)
    {
        print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcname) -> \(object)")
    }
    
    class func logInfo(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function)
    {
        print("\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcname) -> \(object)")
    }
    
    class func logDebug(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function)
    {
        print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcname) -> \(object)")
    }
    
    class func logVerbose(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function)
    {
        print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcname) -> \(object)")
    }
    
    class func logWarning(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function)
    {
        print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcname) -> \(object)")
    }
    
    class func logSevere(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function)
    {
        print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcname) -> \(object)")
    }
}

extension Date
{
    func toString() -> String
    {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
