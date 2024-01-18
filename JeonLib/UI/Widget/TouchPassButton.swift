//
//  TouchPassButton.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit


class TouchPassButton : UIButton {
    var linkedView : UIView? = nil
    
    override func awakeFromNib() {
        self.setTitle("", for: .normal)
        self.setTitle("", for: .focused)
        self.setTitle("", for: .highlighted)
        self.setTitle("", for: .reserved)
        self.setTitle("", for: .selected)
        self.setTitle("", for: .application)
        self.setTitle("", for: .disabled)
    }
    
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
