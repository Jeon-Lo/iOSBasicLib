//
//  SizeChangeSlider.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

@IBDesignable class SizeChangeSlider : UISlider {
    
    private func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func setSliderThumbTintColor() {
        if _thumbSize == nil {
            _thumbSize = CGSize(width: 20, height: 20)
        }
        let circleImage = makeCircleWith(size: self._thumbSize!,
                                         backgroundColor: self.thumbColor ?? UIColor.blue)
        self.setThumbImage(circleImage, for: .normal)
        self.setThumbImage(circleImage, for: .highlighted)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    private var _thumbSize : CGSize? = nil
    
    @IBInspectable var thumbWidth : CGFloat {
        get {
            return _thumbSize?.width ?? 0
        }
        set (value) {
            if _thumbSize == nil {
                _thumbSize = CGSize(width: value, height: 0)
            } else {
                self._thumbSize!.width = value
            }
            self.setSliderThumbTintColor()
        }
    }
    
    @IBInspectable var thumbHeight : CGFloat {
        get {
            return _thumbSize?.height ?? 0
        }
        set (value) {
            if _thumbSize == nil {
                _thumbSize = CGSize(width: 0, height: value)
            } else {
                self._thumbSize!.height = value
            }
            self.setSliderThumbTintColor()
        }
    }
    
    private var _thumbColor : UIColor? = nil
    
    @IBInspectable var thumbColor : UIColor? {
        get {
            return _thumbColor
        }
        set (value) {
            self._thumbColor = value
            self.setSliderThumbTintColor()
        }
    }
}
