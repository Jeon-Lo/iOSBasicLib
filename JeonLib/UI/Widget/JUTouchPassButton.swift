//
//  JUTouchPassButton.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import Foundation
import UIKit


class JUTouchPassButton : UIButton {
    var linkedView : UIView? = nil
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if let handler = self.hittedHandler {
                handler()
            }
            return self.linkedView
        }
        return nil
    }
    
    private var hittedHandler : (() -> Void)? = nil
    public func setHittedHandler(_ hittedHandler :  @escaping (() -> Void)) {
        self.hittedHandler = hittedHandler
    }
}
