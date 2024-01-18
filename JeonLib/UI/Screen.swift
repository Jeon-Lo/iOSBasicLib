//
//  Screen.swift
//  FrontApp
//
//  Created by Gi Soo Hur on 2023/04/23.
//

import Foundation

@objc protocol Screen {
    @objc optional func open(_ params:Dictionary<String, String>?)
    @objc optional func close(_ params:Dictionary<String, String>?)
    @objc optional func progress(_ progress:Int)
    @objc optional func err(_ code:String, _ message:String)
}
 
class CurrentScreen : Screen {
    static weak var shared:Screen?
}
