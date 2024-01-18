//
//  JUToast.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit

class JUToast {
    enum LENGTH {
        case short
        case long
    }
    
    var context : UIView? = nil
    var message : String = ""
    var length : LENGTH = .short
    
    private static let shared = JUToast()
    
    static func makeText(_ message : String, _ length : LENGTH) -> JUToast {
        shared.message = message
        shared.length = length
        return shared
    }
    
    public func show(_ view : UIView? = nil) {
        LogEx.d("JUToast message : \(JUToast.shared.message)")
        let toastView = JUToastView.instanceFromNib()
        toastView.show(JUToast.shared.message, view)
        let showLength : DispatchWallTime = self.length == .short ? .now() + 3 : .now() + 5
        
        DispatchQueue.main.asyncAfter(wallDeadline: showLength) {
            toastView.hideAlphaAnim {
                toastView.removeView()
            }
        }
    }
}
