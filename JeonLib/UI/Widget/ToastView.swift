//
//  ToastView.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//
import UIKit

class ToastView: UIView {
    @IBOutlet weak var lbMessage: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    @IBOutlet weak var messageContainer: UIView!
    
    class func instanceFromNib() -> ToastView {
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToastView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageContainer.layer.cornerRadius = self.messageContainer.height / 2
    }
    
    @objc func removeView() {
        self.removeFromSuperview()
    }
    
    public func show(_ message : String) {
        guard let window = UIWindow.key else {
            return
        }
        self.center = CGPoint(x: window.frame.width / 2, y: window.frame.height / 2)
        self.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height)
        self.removeFromSuperview()
        window.addSubview(self)
        
        
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
