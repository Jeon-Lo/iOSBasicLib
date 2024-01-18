//
//  LogEx.swift
//  gsharemall
//
//  Created by JeonLo on 2019/11/12.
//  Copyright © 2019 Gi Soo Hur. All rights reserved.
//

import Foundation


class LogEx {
//    static let DISABLE_TAG = ["responseOutput"]
    static let DISABLE_TAG = [String]()
    static let LOG_TAG = "LogEx_Jeon"
    
    //TODO 릴리즈시 항상 debug가 false로 되어있는지 확인!
    #if DEBUG
    private static var DEBUG = true
    #else
    private static var DEBUG = false
    #endif
    
    
    enum LEVEL : Int {
        case VERVOSE = 10, DEBUG = 20, INFO = 30, WARN = 40, ERROR = 50, ASSET = 60
    }
    
    private static var level : LEVEL = .VERVOSE
    
    public static func setMode(_ debug : Bool, _ level : LEVEL = .VERVOSE) {
        self.DEBUG = debug
        self.level = level
    }
    
    public static func v(_ message : String){
        self.v(LOG_TAG, message)
    }
    
    public static func v(_ tag : String, _ message : String, _ isRequere : Bool = false){
        if DISABLE_TAG.contains(tag) && !isRequere {
            return
        }
        if DEBUG && self.level.rawValue <= LEVEL.VERVOSE.rawValue {
            print("⚪\(Date.getCurrentTime()) V/\(tag): \(message)⚪")
        }
    }
    
    public static func d(_ message : String){
        self.d(LOG_TAG, message)
    }
    
    public static func d(_ tag : String, _ message : String, _ isRequere : Bool = false){
        if DISABLE_TAG.contains(tag) && !isRequere {
            return
        }
        if DEBUG && self.level.rawValue <= LEVEL.DEBUG.rawValue {
            print("🍏\(Date.getCurrentTime()) D/\(tag): \(message)🍏")
        }
    }
    
    public static func i(_ message : String){
        self.i(LOG_TAG, message)
    }
    
    public static func i(_ tag : String, _ message : String, _ isRequere : Bool = false){
        if DISABLE_TAG.contains(tag) && !isRequere {
            return
        }
        if DEBUG && self.level.rawValue <= LEVEL.INFO.rawValue {
            print("🔵\(Date.getCurrentTime()) I/\(tag): \(message)🔵")
        }
    }
    
    public static func w(_ message : String){
        self.w(LOG_TAG, message)
    }
    
    public static func w(_ tag : String, _ message : String, _ isRequere : Bool = false){
        if DISABLE_TAG.contains(tag) && !isRequere {
            return
        }
        if DEBUG && self.level.rawValue <= LEVEL.WARN.rawValue {
            print("🍊\(Date.getCurrentTime()) W/\(tag): \(message)🍊")
        }
    }
    
    public static func e(_ message : String){
        self.e(LOG_TAG, message)
    }
    
    public static func e(_ tag : String, _ message : String, _ isRequere : Bool = false){
        if DISABLE_TAG.contains(tag) && !isRequere {
            return
        }
        if DEBUG && self.level.rawValue <= LEVEL.ERROR.rawValue {
            print("🔴\(Date.getCurrentTime()) E/\(tag): \(message)🔴")
        }
    }
    
    public static func a(_ message : String){
        self.a(LOG_TAG, message)
    }
    
    public static func a(_ tag : String, _ message : String, _ isRequere : Bool = false){
        if DISABLE_TAG.contains(tag) && !isRequere {
            return
        }
        if DEBUG && self.level.rawValue <= LEVEL.ASSET.rawValue {
            print("💗\(Date.getCurrentTime()) A/\(tag): \(message)💗")
        }
    }
}


extension NSObject {
    var className : String {
        get {
            let name = type(of: self).description()
            if name.contains(".") {
                return name.components(separatedBy: ".")[1]
            }
            return name
        }
    }
}
