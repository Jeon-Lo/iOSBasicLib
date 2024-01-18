//
//  BaseCustomDialog.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit

class BaseCustomDialog<T> : UIView {
    @IBOutlet weak var container: UIView!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> T {
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
    
    public func show(_ isBackgroundDimmed : Bool = true) {
        guard let window = UIWindow.key else {
            return
        }
        if isBackgroundDimmed {
            self.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        }
        self.center = CGPoint(x: window.frame.width / 2, y: window.frame.height / 2)
        self.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height)
        self.removeFromSuperview()
        window.addSubview(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTappedAction)))
        self.container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerTapped)))
    }
    
    public var dismissHandler : (() -> Void)? = nil
    public func setDismissHandler(_ dismissHandler :  @escaping (() -> Void)) {
        self.dismissHandler = dismissHandler
    }
    
    var isViewTapClose = true
    
    @objc func viewTappedAction() {
        if isViewTapClose {
            self.removeFromSuperview()
            guard let handler = self.dismissHandler else {
                return
            }
            handler()
        }
    }
    
    @objc private func containerTapped() {
        
    }
    
    
    
}
