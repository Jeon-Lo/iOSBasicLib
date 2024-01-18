//
//  AnnotationParams.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/08.
//

import UIKit

@objc class AnnotationParams:NSObject {
    var name : String? = nil
    
    var _color : UIColor = .black
    var color : UIColor {
        get {
            return _color
        }
        set (value) {
            self._color = value
            self.saveAnnotationConfig()
        }
    }
    var _alpha : CGFloat = 1
    var alpha : CGFloat {
        get {
            return _alpha
        }
        set (value) {
            self._alpha = value
            self.saveAnnotationConfig()
        }
    }
    
    var _width : CGFloat = 3
    var width : CGFloat {
        get {
            return _width
        }
        set (value) {
            self._width = value
            self.saveAnnotationConfig()
        }
    }
    var selector : Selector? = nil
    
    override init() {
        super.init()
    }
    
    init(name : String, color: UIColor, alpha: CGFloat, width: CGFloat, selector:Selector) {
        super.init()
        self.name = name
        self.selector = selector
        
        let savedConfig = self.loadAnnotationConfig(name, color, alpha, width)
        self.color = savedConfig.color
        self.alpha = savedConfig.alpha
        self.width = savedConfig.width
    }
    
    private func saveAnnotationConfig() {
        guard let name = self.name else {
            return
        }
        var dictionary = [String:Any]()
        dictionary["color"] = self.color.toHexString()
        dictionary["alpha"] = self.alpha
        dictionary["width"] = self.width
        UserDefaults.standard.setValue(dictionary, forKey: name)
    }
    
    private func loadAnnotationConfig(_ name : String, _ defColor : UIColor, _ defAlpha : CGFloat, _ defWidth : CGFloat) -> AnnotationParams {
        let annot = AnnotationParams()
        guard let dic = UserDefaults.standard.dictionary(forKey: name) else {
            annot.color = defColor
            annot.alpha = defAlpha
            annot.width = defWidth
            return annot
        }
        
        if let strColor = dic["color"] as? String, let color = UIColor(hex: strColor) {
            annot.color = color
        } else {
            annot.color = defColor
        }
        
        if let alpha = dic["alpha"] as? CGFloat {
            annot.alpha = alpha
        } else {
            annot.alpha = defAlpha
        }
        
        if let width = dic["width"] as? CGFloat {
            annot.width = width
        } else {
            annot.width = defWidth
        }
        return annot
    }
}
