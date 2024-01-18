//
//  ColorPickerDialog.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

class ColorPickerDialog: BaseCustomDialog<ColorPickerDialog> {
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var colorWheel: ColorWheel!
    @IBOutlet weak var brightnessView: BrightnessView!
    @IBOutlet weak var selectedColorView: UIView!
    
    var color : UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    
    @IBOutlet weak var paletteColor1: UIView!
    @IBOutlet weak var paletteColor2: UIView!
    @IBOutlet weak var paletteColor3: UIView!
    @IBOutlet weak var paletteColor4: UIView!
    @IBOutlet weak var paletteColor5: UIView!
    @IBOutlet weak var paletteColor6: UIView!
    @IBOutlet weak var btnConfirm: UIView!
    private var palettes = [UIView]()
    
    private func initPaletteView() {
        paletteColor1.layer.cornerRadius = paletteColor1.height / 2
        paletteColor1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paletteTapped(_:))))
        self.palettes.append(paletteColor1)
        paletteColor2.layer.cornerRadius = paletteColor2.height / 2
        paletteColor2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paletteTapped(_:))))
        self.palettes.append(paletteColor2)
        paletteColor3.layer.cornerRadius = paletteColor3.height / 2
        paletteColor3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paletteTapped(_:))))
        self.palettes.append(paletteColor3)
        paletteColor4.layer.cornerRadius = paletteColor4.height / 2
        paletteColor4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paletteTapped(_:))))
        self.palettes.append(paletteColor4)
        paletteColor5.layer.cornerRadius = paletteColor5.height / 2
        paletteColor5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paletteTapped(_:))))
        self.palettes.append(paletteColor5)
        paletteColor6.layer.cornerRadius = paletteColor6.height / 2
        paletteColor6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paletteTapped(_:))))
        self.palettes.append(paletteColor6)
    }
    
    private var annotationParams : AnnotationParams!
    static var paletteColors : [String] {
        get {
            guard let colors = UserDefaults.standard.stringArray(forKey: "paletteColors") else {
                return [String]()
            }
            return colors
        }
        set (value) {
            UserDefaults.standard.setValue(value, forKey: "paletteColors")
        }
    }
    
    public func show(_ annotationParams : AnnotationParams) {
        super.show()
        
        self.annotationParams = annotationParams
        let pColorsCount = ColorPickerDialog.self.paletteColors.count
        for i in 0 ..< (pColorsCount > self.palettes.count ? self.palettes.count : pColorsCount) {
            palettes[i].backgroundColor = UIColor(hexString: ColorPickerDialog.self.paletteColors[i])
        }
        self.color = annotationParams.color
        self.colorWheel.setViewColor(self.color)
        self.brightnessView.setViewColor(self.color)
        self.selectedColorView.backgroundColor = self.color.withAlphaComponent(annotationParams.alpha)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.masksToBounds = false
        container.layer.cornerRadius = 5
        container.clipsToBounds = true

        colorWheel.delegate = self
        colorWheel.setViewColor(UIColor.red)
        brightnessView.delegate = self
        brightnessView.setViewColor(UIColor.red)
        
        self.btnConfirm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmTapped)))
        self.initPaletteView()
    }
    
    private var tapHandler : (() -> Void)? = nil
    public func setTapHandler(_ tapHandler :  @escaping (() -> Void)) {
        self.tapHandler = tapHandler
    }
    
    @IBAction func close(_ sender: Any) {
        viewTapped()
    }
    
    @objc func viewTapped() {
        self.removeFromSuperview()
        guard let handler = self.dismissHandler else {
            return
        }
        handler()
    }
    
    @objc func confirmTapped() {
        self.annotationParams.color = self.color
        let hexString = self.annotationParams.color.toHexString()
        if ColorPickerDialog.paletteColors.contains(hexString) {
            let index = ColorPickerDialog.paletteColors.firstIndex(of: hexString)!
            ColorPickerDialog.paletteColors.remove(at: index)
        }
        ColorPickerDialog.paletteColors.insert(hexString, at: 0)
        
        if ColorPickerDialog.paletteColors.count > 6 {
            ColorPickerDialog.paletteColors.removeLast()
        }
        viewTapped()
    }
    
    @objc func paletteTapped(_ recognizer : UITapGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        self.color = view.backgroundColor ?? UIColor.clear
        self.annotationParams.color = self.color
        brightnessView.setViewColor(self.color)
        colorWheel.setViewColor(self.color)
        selectedColorView.backgroundColor = self.color
    }
}


extension ColorPickerDialog : ColorWheelDelegate, BrightnessViewDelegate {
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = 1
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0).getSafeAreaColor()
        colorWheel.setViewBrightness(self.brightness)
        brightnessView.setViewColor(self.color)
        selectedColorView.backgroundColor = self.color
        
    }
    
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0).getSafeAreaColor()
        colorWheel.setViewBrightness(brightness)
        selectedColorView.backgroundColor = self.color
    }
}

extension UIColor {
    func getSafeAreaColor() -> UIColor {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        if r < 0 {
            r = 0
        }
        if g < 0 {
            g = 0
        }
        if b < 0 {
            b = 0
        }
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
