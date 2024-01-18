//
//  Toast.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit

class Toast {
    enum LENGTH {
        case short
        case long
    }
    
    var context : UIView? = nil
    var message : String = ""
    var length : LENGTH = .short
    
    private static let shared = Toast()
    
    static func makeText(_ message : String, _ length : LENGTH) -> Toast {
        shared.message = message
        shared.length = length
        return shared
    }
    
    public func show() {
        let toastView = ToastView.instanceFromNib()
        toastView.show(Toast.shared.message)
        let showLength : DispatchWallTime = self.length == .short ? .now() + 3 : .now() + 5
        
        DispatchQueue.main.asyncAfter(wallDeadline: showLength) {
            toastView.hideAlphaAnim {
                toastView.removeView()
            }
        }
    }
}
