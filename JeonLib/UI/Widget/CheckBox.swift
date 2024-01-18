//
//  CheckBox.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

@IBDesignable class CheckBox : UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var backgroundView: UIView!
    var checkBox : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        view.clipsToBounds = true
        self.view.backgroundColor = self.backgroundColor
        self.backgroundView.backgroundColor = self.backgroundColor
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        
        if self._size == nil {
            self._size = CGSize(width: 30, height: 30)
        }
        
        self.checkBox = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self._size!))
        self.checkBox.backgroundColor = UIColor.clear
        self.backgroundView.addSubview(self.checkBox)
        
        self.setAutoLayoutCheckBox()
        
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onTapped)))
    }
    
    func setAutoLayoutCheckBox() {
        self.checkBox.translatesAutoresizingMaskIntoConstraints = false
        self.checkBox.widthAnchor.constraint(equalToConstant: self._size!.width).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: self._size!.height).isActive = true
        
        self.checkBox.centerXAnchor.constraint(equalTo: self.backgroundView.centerXAnchor).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor).isActive = true
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
    
    @objc func onTapped() {
        if !self._isRadioMode {
            self.isOn = !self.isOn
        }
        guard let handler = checkedChangedHandler else {
            return
        }
        handler(self.tag, self.isOn)
    }
    
    
    private var _on : Bool = false
    @IBInspectable var isOn : Bool {
        get {
            return _on
        }
        set(value) {
            self._on = _isSelectable ? value : false
            self.checkBox.image = self._on ? self.checkedImage : self._normalImage
        }
    }
    
    private var _isSelectable : Bool = true
    @IBInspectable var isSelectable : Bool {
        get {
            return _isSelectable
        }
        set(value) {
            self._isSelectable = value
        }
    }
    
    private var _isRadioMode = false
    @IBInspectable var isRadioMode : Bool {
        get {
            return _isRadioMode
        }
        set(value) {
            self._isRadioMode = value
        }
    }
    
    private var _checkedImage : UIImage? = nil
    private var _normalImage : UIImage? = nil
    
    @IBInspectable var checkedImage : UIImage? {
        get {
            return self._checkedImage
        }
        set(value) {
            self._checkedImage = value
            if self.isSelectable {
                if self._on {
                    self.checkBox.image = self._checkedImage
                }
            }
        }
    }
    
    @IBInspectable var normalImage : UIImage? {
        get {
            return self._normalImage
        }
        set(value) {
            self._normalImage = value
            if !self._on {
                self.checkBox.image = self._normalImage
            }
        }
    }
    
    
    private var _size : CGSize? = nil
    
    @IBInspectable var sizeWidth : CGFloat {
        get {
            return _size?.width ?? 0
        }
        set (value) {
            if _size == nil {
                _size = CGSize(width: value, height: 0)
            } else {
                self._size!.width = value
            }
            self.setAutoLayoutCheckBox()
        }
    }
    
    @IBInspectable var sizeHeight : CGFloat {
        get {
            return _size?.height ?? 0
        }
        set (value) {
            if _size == nil {
                _size = CGSize(width: 0, height: value)
            } else {
                self._size!.height = value
            }
            self.setAutoLayoutCheckBox()
        }
    }
    
}
