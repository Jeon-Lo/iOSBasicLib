//
//  JUAlert.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit

class JUAlertModule : UIView {
}

class JUAlert: BaseAlert<JUAlert> {
  
    @IBOutlet weak var lbAlertTitle: UILabel!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var lbAlertMessage: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var radioGroup = [JSAlertRadioButton]()
    private var sTag : Int? = nil
    
    var confirmActionHandler : (() -> Void)? = nil
    var cancelActionHandler : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib(true)
        
        self.container.layer.cornerRadius = 15
        self.container.clipsToBounds = true
    }
    
    public func show(_ title : String? = nil, _ message : String? = nil) {
        super.show()
        
        lbAlertTitle.isHidden = title == nil
        messageContainer.isHidden = message == nil
        lbAlertMessage.isHidden = message == nil
        
        lbAlertTitle.text = title
        lbAlertMessage.text = message
    }
    
    override func viewWithTag(_ tag: Int) -> UIView? {
        return self.stackView.viewWithTag(tag)
    }
}

extension JUAlert {
    @objc func onRadioButtonTapped(_ gesture : UIGestureRecognizer) {
        guard let tag = gesture.view?.tag else {
            return
        }
        onRadioButtonEvent(tag)
    }
    
    private func onRadioButtonEvent(_ tag : Int) {
        for rb in self.radioGroup {
            rb.checkBox.isOn = rb.tag == tag
        }
    }
    
    public func selectedRadioTag(_ selectedTag : Int? = nil) {
        self.sTag = selectedTag
    }
    
    public func addRadioButton(_ tag : Int, _ message : String) {
        let radioButton = JSAlertRadioButton.instanceFromNib()
        radioButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: self.container.bounds.width).isActive = true
        radioButton.checkBox.normalImage = UIImage(systemName: "circle")
        radioButton.checkBox.checkedImage = UIImage(systemName: "circle.inset.filled")
        radioButton.checkBox.setCheckedChangedHandler { tag, isOn in
            self.onRadioButtonEvent(tag)
        }
        radioButton.lbMessage.text = message
        radioButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRadioButtonTapped(_:))))
        radioButton.tag = tag
        radioButton.checkBox.tag = tag
        if let sTag = self.sTag {
            radioButton.checkBox.isOn = sTag == tag
        }
        else {
            radioButton.checkBox.isOn = radioGroup.isEmpty
        }
        self.stackView.addArrangedSubview(radioButton)
        self.radioGroup.append(radioButton)
    }
    
    public func getCheckRadioTag() -> (String?, Int) {
        for rb in self.radioGroup {
            if rb.checkBox.isOn {
                return (rb.lbMessage.text, rb.tag)
            }
        }
        return (nil, -1)
    }
}

extension JUAlert {
    public func addTextField(_ tag : Int, _ placeHolder : String? = nil, _ text : String? = nil) {
        let textField = JSAlertTextField.instanceFromNib()
        textField.parentView = self
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.widthAnchor.constraint(equalToConstant: self.container.bounds.width).isActive = true
        textField.textField.placeholder = placeHolder
        textField.textField.text = text
        textField.tag = tag
        
        self.stackView.addArrangedSubview(textField)
    }
}

extension JUAlert {
    public func addConfirmCancel(_ cancelAction : @escaping () -> Void, _ confirmAction : @escaping () -> Void) {
        let confirmCancel = JSAlertConfirmCancel.instanceFromNib()
        confirmCancel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        confirmCancel.widthAnchor.constraint(equalToConstant: self.container.bounds.width).isActive = true
        
        self.confirmActionHandler = confirmAction
        self.cancelActionHandler = cancelAction
        
        confirmCancel.btnCancel.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchUpInside)
        confirmCancel.btnConfirm.addTarget(self, action: #selector(confirmEvent(_:)), for: .touchUpInside)
        
        self.stackView.addArrangedSubview(confirmCancel)
    }
    
    @objc func confirmEvent(_ sender : UIButton) {
        self.viewTappedAction()
        
        guard let handler = confirmActionHandler else {
            return
        }
        handler()
    }
    
    @objc func cancelEvent(_ sender : UIButton) {
        self.viewTappedAction()
    }
}

class JSAlertRadioButton : JUAlertModule {
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var lbMessage: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> JSAlertRadioButton {
        return UINib(nibName: "JUAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! JSAlertRadioButton
    }
}

class JSAlertTextField : JUAlertModule, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    var parentView : UIView? = nil
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> JSAlertTextField {
        return UINib(nibName: "JUAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! JSAlertTextField
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //옵션처리 필요 추후...
        self.textField.delegate = self
        self.addDoneToolbar()
    }
    
    var text : String? {
        get {
            return self.textField.text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !["1","2","3","4","5","6","7","8","9","0","-", ""].contains(string) {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(isUp: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(isUp: false)
    }
    
    func animateTextField(isUp : Bool) {
        guard let parentView = self.parentView else {
            return
        }
        let movementDistance = UIViewController.isPad() ? 300 : 100
        let movementDuration : CGFloat = 0.3
        let movement = isUp ? -movementDistance : movementDistance
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        parentView.frame = CGRectOffset(parentView.frame, 0, CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func addDoneToolbar() {
        let toolbar = UIToolbar()
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem.init(title: "닫기", style: .done, target: self, action: #selector(done))
        toolbar.items = [flexible, doneButton]
        toolbar.sizeToFit()
        
        self.textField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}


class JSAlertConfirmCancel : JUAlertModule {
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> JSAlertConfirmCancel {
        return UINib(nibName: "JUAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! JSAlertConfirmCancel
    }
}

