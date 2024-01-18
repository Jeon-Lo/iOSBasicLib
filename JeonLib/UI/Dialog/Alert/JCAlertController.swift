//
//  JCAlertController.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/15.
//

import UIKit

class JCAlertController: BaseCustomDialog<JCAlertController> {
  
    @IBOutlet weak var lbAlertTitle: UILabel!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var lbAlertMessage: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var radioGroup = [JSAlertRadioButton]()
    private var sTag : Int? = nil
    
    var confirmActionHandler : (() -> Void)? = nil
    var cancelActionHandler : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

extension JCAlertController {
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

extension JCAlertController {
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

extension JCAlertController {
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
