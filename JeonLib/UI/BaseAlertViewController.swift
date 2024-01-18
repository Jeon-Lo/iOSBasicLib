//
//  BaseAlertViewController.swift
//  editor
//
//  Created by Jeon on 2023/09/27.
//

import UIKit

private var __keyboardSelectObject = 0
public let keyboardSelectObjectNotification = NSNotification.Name(rawValue: "KeyboardSelectObject")

class BaseAlertViewController : UIViewController {
    @IBOutlet weak var popup: UIView!
    var anchorView : UIView? = nil
    var shadowView : UIView!
    
    weak var keyboardSelectObject:UIControl? {
        get {
            return objc_getAssociatedObject(self, &__keyboardSelectObject) as? UIControl
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &__keyboardSelectObject, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
        self.initView()
    }
    
    public func initView() {
        self.popup.layer.masksToBounds = false
        self.popup.layer.cornerRadius = 22
        self.popup.clipsToBounds = true
        
        shadowView = UIView(frame: CGRect.zero)
        self.view.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leadingAnchor.constraint(equalTo: self.popup.leadingAnchor, constant: 0).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: self.popup.trailingAnchor, constant: 0).isActive = true
        shadowView.topAnchor.constraint(equalTo: self.popup.topAnchor, constant: 0).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.popup.bottomAnchor, constant: 0).isActive = true
        shadowView.backgroundColor = UIColor.black
        self.view.bringSubviewToFront(self.popup)
        
        self.shadowView.layer.cornerRadius = self.popup.layer.cornerRadius
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
    
    public func clearShadow(_ view : UIView) {
        // 검정색 사용
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize.zero
        // 반경?
        view.layer.shadowRadius = 0
        // alpha값입니다.
        view.layer.shadowOpacity = 0
    }
    
    public func setTextFieldViewSetting(_ textField : UITextField, _ delegate : UITextFieldDelegate, _ layerSetting : Bool = true) {
        if layerSetting {
            textField.layer.borderColor = UIColor(hexString: "464748").cgColor
            textField.layer.borderWidth = 1.5
            textField.layer.cornerRadius = 5
        }

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.delegate = delegate
        textField.leftViewMode = .always
    }
    
    @objc func viewTapped(_ gesture : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObserverKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserverKeyboard()
    }
    
    open func addObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardSelectObject(_:)), name: keyboardSelectObjectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIControl.keyboardWillHideNotification, object: nil)
    }
    
    open func removeObserverKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardSelectObject(_ notification: Notification) {
        keyboardSelectObject = notification.object as? UIControl
    }
    
    var isKeyboardShown = false
    var isKeyboardResizeReq = false
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let anchorView = self.anchorView, !isKeyboardShown else {
            return
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
//            LogEx.e("keyboardWillShow keyboardRectangle : \(keyboardRectangle)")
//            let keyboardHeight = keyboardRectangle.height
//            let f = anchorView.convert(self.view.frame, to: nil)
//            LogEx.e("keyboardWillShow f : \(f)")
//            let gFrame = self.view.convert(anchorView.frame.origin, to: nil)
            let gFrame = anchorView.convert(UIWindow.key?.frame ?? .zero, to: nil)
            let anchorGlobalFrame = CGRect(origin: gFrame.origin, size: anchorView.size)
            
            LogEx.d("global   frame : \(UIWindow.key?.frame ?? .zero)")
            LogEx.d("keyboard frame : \(keyboardRectangle)")
            LogEx.d("anchorvi frame : \(anchorGlobalFrame)")
//            LogEx.e("keyboardWillShow gFrame : \(gFrame)")
            let distance = anchorGlobalFrame.maxY - keyboardRectangle.minY
            if distance > 0 {
                self.view.frame.origin.y -= (distance)
            }
            self.isKeyboardShown = true
            /*
            if keyboardRectangle.contains(anchorGlobalFrame) || self.isKeyboardResizeReq {
                let viewHeight = self.view.height
                let target = gFrame.minY + anchorView.frame.height
                
                let bottomMargin = viewHeight - target
                let distance = keyboardHeight - bottomMargin
                self.view.frame.origin.y -= (distance)
                self.isKeyboardShown = true
            }*/
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.perform(#selector(restoreView), with: nil, afterDelay: 0.1)
    }
    
    @objc func restoreView() {
        self.view.frame.origin.y = 0
        self.isKeyboardShown = false
    }
    
}


extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
