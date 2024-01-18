//
//  RadioGroup.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

@IBDesignable class RadioGroup : UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    func xibSetup() {
        self.backgroundColor = UIColor.clear
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        view.clipsToBounds = true
        self.view.backgroundColor = self.backgroundColor
        self.backgroundView.backgroundColor = self.backgroundColor
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        self.view.isUserInteractionEnabled = false
        
        for child in self.subviews {
            if let checkBox = child as? CheckBox {
                checkBox.isRadioMode = true
                checkBox.setCheckedChangedHandler { tag, checked in
                    for child in self.subviews {
                        guard let checkBox = child as? CheckBox else {
                            continue
                        }
                        if checkBox.tag == tag {
                            if checkBox.isSelectable {
                                checkBox.isOn = true
                            }
                            guard let handler = self.checkedChangedHandler else {
                                continue
                            }
                            handler(checkBox.tag, checked)
                        }
                        else {
                            checkBox.isOn = false
                        }
                    }
                }
            }
        }
    }
    
    func clearChecked() {
        for child in self.subviews {
            if let checkBox = child as? CheckBox {
                checkBox.isOn = false
            }
        }
    }
    
    func setChecked( _ checkTag : Int) {
        for child in self.subviews {
            if let checkBox = child as? CheckBox {
                checkBox.isOn = child.tag == checkTag
            }
        }
    }
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String.init(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private var checkedChangedHandler : ((Int, Bool) -> Void)? = nil
    
    public func setCheckedChangedHandler(clickHandler : ((Int, Bool) -> Void)?) {
        self.checkedChangedHandler = clickHandler
    }
    
}
