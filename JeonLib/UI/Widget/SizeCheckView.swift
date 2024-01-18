//
//  SizeCheckView.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

@IBDesignable class SizeCheckView : UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleDiameterWidth: NSLayoutConstraint!
    @IBOutlet weak var circleDiameterHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    private func setCircleRadius(_ radius : CGFloat) {
        circleDiameterWidth.constant = radius
        circleDiameterHeight.constant = radius
        
        self.circleView.layer.cornerRadius = radius / 2
    }
    
    private var _radius : CGFloat = 1
    
    @IBInspectable var radius : CGFloat {
        get {
            return _radius
        }
        set(value) {
            self._radius = value
            setCircleRadius(self._radius)
        }
    }
    
    private var _color : UIColor = UIColor.blue
    
    @IBInspectable var color : UIColor {
        get {
            return _color
        }
        set(value) {
            self._color = value
            self.circleView.backgroundColor = self._color
        }
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
        
        self.circleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.circleView.layer.cornerRadius = circleDiameterHeight.constant / 2
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String.init(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
