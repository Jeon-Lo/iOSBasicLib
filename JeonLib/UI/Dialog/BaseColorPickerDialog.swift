//
//  BaseColorPickerDialog.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/11.
//

import UIKit

class BaseColorPickerDialog<T> : BaseCustomDialog<T> {
    var annotationParams : AnnotationParams!
    
    func showColorPickerDialog(_ annotationParams : AnnotationParams) {
        let colorPickerDialog = ColorPickerDialog.instanceFromNib()
        colorPickerDialog.setTapHandler {
            self.settingAnnotConfig(self.annotationParams)
        }
        colorPickerDialog.setDismissHandler {
            self.settingAnnotConfig(self.annotationParams)
        }
        colorPickerDialog.show(annotationParams)
    }
    
    func settingAnnotConfig(_ annotationParams: AnnotationParams) {
        self.annotationParams = annotationParams
        self.settingAnnotColor(annotationParams)
        self.settingAnnotAlpha(annotationParams)
        self.settingAnnotWidth(annotationParams)
    }
    
    func settingAnnotColor(_ annotationParams : AnnotationParams) {
    }
    
    func settingAnnotAlpha(_ annotationParams : AnnotationParams) {
    }
    
    func settingAnnotWidth(_ annotationParams : AnnotationParams) {
    }
    
    public func show(_ anchorView : UIView, _ annotationParams : AnnotationParams, _ contentView : UIView, _ bottomAnchorView : UIView? = nil) {
        super.show(false)
    }
    
    
}
