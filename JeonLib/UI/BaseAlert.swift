//
//  BaseAlert.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit

class BaseAlert<T> : UIView {
    var shadowView : UIView!
    @IBOutlet weak var container: UIView!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> T {
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
    
    public func show(_ isBackgroundDimmed : Bool = true, _ view : UIView? = nil) {
        guard let window = view ?? UIWindow.key else {
            return
        }
        if isBackgroundDimmed {
//            self.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        self.center = CGPoint(x: window.frame.width / 2, y: window.frame.height / 2)
        self.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height)
        self.removeFromSuperview()
        window.addSubview(self)
    }
    
    public func initView() {
        self.container.layer.masksToBounds = false
        self.container.layer.cornerRadius = 22
        self.container.clipsToBounds = true
        
        shadowView = UIView(frame: CGRect.zero)
        self.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0).isActive = true
        shadowView.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: 0).isActive = true
        shadowView.backgroundColor = UIColor.black
        self.bringSubviewToFront(self.container)
        
        self.shadowView.layer.cornerRadius = self.container.layer.cornerRadius
        self.shadowView.layer.masksToBounds = false
        self.shadowView.clipsToBounds = true
        self.setShadow(self.shadowView, CGSize(width: 3, height: 3), 10, 0.5)
    }
    
    
    public func setShadow(_ view : UIView, _ offset : CGSize, _ radius : CGFloat, _ alpha : CGFloat) {
        // 검정색 사용
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = offset
        // 반경?
        view.layer.shadowRadius = radius
        // alpha값입니다.
        view.layer.shadowOpacity = Float(alpha)
    }
    
    func awakeFromNib(_ isSetInitView : Bool = true) {
        super.awakeFromNib()
        if isSetInitView {
            self.initView()
        }
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
