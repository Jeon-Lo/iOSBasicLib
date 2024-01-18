//
//  ColorAlphaSelectDialog.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

class ColorAlphaSelectDialog: BaseColorPickerDialog<ColorAlphaSelectDialog> {
    var backgroundView: UIView?
    
    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var trailingConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    @IBOutlet weak var colorRadioGroup: RadioGroup!
    @IBOutlet weak var alphaRadioGroup: RadioGroup!
    
    @IBOutlet weak var lbBorderWidth: UILabel!
    @IBOutlet weak var horizontalSlider: UISlider!
    @IBOutlet weak var sizeCheckView: SizeCheckView!
    
    @IBOutlet weak var btnTouch: TouchPassButton!
    
    var anchorView : UIView!
    
    @IBAction func onSliderChanged(_ sender: UISlider) {
        self.lbBorderWidth.text = "\(Int(sender.value))"
        self.sizeCheckView.radius = (CGFloat(sender.value))
        self.annotationParams.width = CGFloat(sender.value)
    }
    
    @IBOutlet weak var bavBottomConst: NSLayoutConstraint!
    
    override func show(_ anchorView : UIView, _ annotationParams : AnnotationParams, _ contentView : UIView, _ bottomAnchorView : UIView? = nil) {
        super.show(anchorView, annotationParams, contentView, bottomAnchorView)
        self.anchorView = anchorView
        
        container.leadingAnchor.constraint(equalTo: self.anchorView.leadingAnchor, constant: 0).isActive = true
        container.topAnchor.constraint(equalTo: self.anchorView.bottomAnchor, constant: 0).isActive = true
        container.trailingAnchor.constraint(equalTo: self.anchorView.trailingAnchor, constant: 0).isActive = true
        
        if let bav = bottomAnchorView {
            self.btnTouch.translatesAutoresizingMaskIntoConstraints = false
            self.bavBottomConst.isActive = false

            self.bavBottomConst = self.btnTouch.bottomAnchor.constraint(equalTo: bav.topAnchor, constant: bav.isHidden ? bav.bounds.height : 0)
            self.bavBottomConst.isActive = true
        }
        
        self.btnTouch.linkedView = contentView
        self.btnTouch.setHittedHandler {
            self.removeFromSuperview()
            guard let handler = self.dismissHandler else {
                return
            }
            handler()
        }
        
        self.settingAnnotConfig(annotationParams)
    }
    
    public func bringToFront() {
        guard let parentView = UIWindow.key else {
            return
        }
        parentView.bringSubviewToFront(self)
    }
    
    @objc func viewSwipped() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leadingConst.isActive = false
        trailingConst.isActive = false
        topConst.isActive = false
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        colorRadioGroup.setCheckedChangedHandler { tag, checked in
            switch tag {
            case 100:
                self.annotationParams.color = UIColor.black
                break
            case 101:
                self.annotationParams.color = UIColor.red
                break
            case 102:
                self.annotationParams.color = UIColor.blue
                break
            case 103:
                self.showColorPickerDialog(self.annotationParams)
                break
            default:
                break
            }
            self.sizeCheckView.color = self.annotationParams.color.withAlphaComponent(self.annotationParams.alpha)
        }
        alphaRadioGroup.setCheckedChangedHandler { tag, checked in
            switch tag {
            case 200:
                self.annotationParams.alpha = 1
                break
            case 201:
                self.annotationParams.alpha = 0.6
                break
            case 202:
                self.annotationParams.alpha = 0.3
                break
            default:
                break
            }
            self.sizeCheckView.color = self.annotationParams.color.withAlphaComponent(self.annotationParams.alpha)
        }
    }
    
    private var tapHandler : ((Int) -> Void)? = nil
    public func setTapHandler(_ tapHandler :  @escaping ((Int) -> Void)) {
        self.tapHandler = tapHandler
    }
    
    @objc func viewTapped() {
        self.removeFromSuperview()
        guard let handler = self.dismissHandler else {
            return
        }
        handler()
    }
    
    @IBAction func closeDialog(_ sender: Any) {
        viewTapped()
    }
    
    func setProgressParam(_ minProgress : CGFloat, _ maxProgress : CGFloat) {
        horizontalSlider.minimumValue = Float(minProgress)
        horizontalSlider.maximumValue = Float(maxProgress)
    }
    
    override func settingAnnotColor(_ annotationParams : AnnotationParams) {
        self.sizeCheckView.color = annotationParams.color.withAlphaComponent(annotationParams.alpha)
        
        switch annotationParams.color {
        case UIColor.black:
            self.colorRadioGroup.setChecked(100)
            break
        case UIColor.red:
            self.colorRadioGroup.setChecked(101)
            break
        case UIColor.blue:
            self.colorRadioGroup.setChecked(102)
            break
        default:
            self.colorRadioGroup.setChecked(103)
            break
        }
    }
    
    override func settingAnnotAlpha(_ annotationParams : AnnotationParams) {
        if annotationParams.alpha == 1 {
            self.alphaRadioGroup.setChecked(200)
        }
        else if annotationParams.alpha == 0.6 {
            self.alphaRadioGroup.setChecked(201)
        }
        else if annotationParams.alpha == 0.3 {
            self.alphaRadioGroup.setChecked(202)
        }
        else {
            annotationParams.alpha = 1
            settingAnnotAlpha(annotationParams)
        }
    }
    
    override func settingAnnotWidth(_ annotationParams : AnnotationParams) {
        self.lbBorderWidth.text = "\(Int(annotationParams.width))"
        self.sizeCheckView.radius = (CGFloat(annotationParams.width))
        self.horizontalSlider.value = Float(annotationParams.width)
    }
}
