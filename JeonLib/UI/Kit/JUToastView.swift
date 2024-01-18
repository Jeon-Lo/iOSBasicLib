//
//  JUToastView.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//
import UIKit

class JUToastView: UIView {
    @IBOutlet weak var lbMessage: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    @IBOutlet weak var messageContainer: UIView!
    
    class func instanceFromNib() -> JUToastView {
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! JUToastView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageContainer.layer.cornerRadius = self.messageContainer.height / 2
    }
    
    @objc func removeView() {
        self.removeFromSuperview()
    }
    
    private func removeToastView(_ view : UIView) {
        for subView in view.subviews {
            if let toastView = subView as? JUToastView {
                toastView.removeFromSuperview()
            }
        }
    }
    
    public func show(_ message : String, _ _attachView : UIView? = nil) {
        var v : UIView? = nil
        
        if let attachView = _attachView {
            v = attachView
        }
        else if let window = UIWindow.key {
            v = window
        }
        UIWindow.topViewController?.dismissKeyboard()
        guard let view = v else {
            return
        }
        self.removeToastView(view)
        self.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.removeFromSuperview()
        view.addSubview(self)
        
        self.lbMessage.text = message
        self.messageContainer.alpha = 0
        self.lbMessage.alpha = 0
        UIView.animate(withDuration: 1) {
            self.messageContainer.alpha = 1
            self.lbMessage.alpha = 1
        }
    }
    
    public func showAlphaAnim() {
        self.messageContainer.alpha = 0
        self.lbMessage.alpha = 0
        UIView.animate(withDuration: 1) {
            self.messageContainer.alpha = 1
            self.lbMessage.alpha = 1
        }
    }
    
    public func hideAlphaAnim(_ completion : @escaping () -> Void) {
        UIView.animate(withDuration: 1) {
            self.messageContainer.alpha = 0
            self.lbMessage.alpha = 0
        } completion: { result in
            completion()
        }
    }
}
