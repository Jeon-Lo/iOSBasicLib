//
//  BrightnessView.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/10.
//

import UIKit

protocol BrightnessViewDelegate: class {
   func brightnessSelected(_ brightness: CGFloat)
}

class BrightnessView: UIView {
  
    weak var delegate: BrightnessViewDelegate?
  
    var colorLayer: CAGradientLayer!
    
//    var point: CGPoint!
//    var indicator = CAShapeLayer()
    // Layer for the indicator
    var indicatorLayer: CAShapeLayer!
    var point: CGPoint!
    var indicatorCircleRadius: CGFloat = 12.0
    var indicatorColor: CGColor = UIColor.lightGray.cgColor
    var indicatorBorderWidth: CGFloat = 2.0
    
    
    // Retina scaling factor
    let scale: CGFloat = UIScreen.main.scale
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        
        // Init the point at the correct position
        point = getPointFromColor(color)
        
        // Clear the background
        backgroundColor = UIColor.clear
        
        // Create a gradient layer that goes from black to white
        // Create a gradient layer that goes from black to white
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        colorLayer = CAGradientLayer()
        colorLayer.colors = [
            UIColor.black.cgColor,
            UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1).cgColor
        ]
        colorLayer.locations = [0.0, 1.0]
        colorLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        colorLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        colorLayer.frame = CGRect(x: 0, y: 2, width: self.frame.size.width, height: 50)
        // Insert the colorLayer into this views layer as a sublayer
        self.layer.insertSublayer(colorLayer, below: layer)
        
        // Add the indicator
        /*indicator.strokeColor = indicatorColor
        indicator.fillColor = indicatorColor
        indicator.lineWidth = indicatorBorderWidth
        self.layer.addSublayer(indicator)*/
        
        // Layer for the indicator
        indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = indicatorColor
        indicatorLayer.lineWidth = indicatorBorderWidth
        indicatorLayer.fillColor = nil
        self.layer.addSublayer(indicatorLayer)
        
        drawIndicator()
    }
    
    private var color : UIColor = UIColor.red
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        // Init the point at the correct position
        point = getPointFromColor(color)
        
        // Clear the background
        backgroundColor = UIColor.clear
        
        // Create a gradient layer that goes from black to white
        // Create a gradient layer that goes from black to white
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        colorLayer = CAGradientLayer()
        colorLayer.colors = [
            UIColor.black.cgColor,
            UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1).cgColor
        ]
        colorLayer.locations = [0.0, 1.0]
        colorLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        colorLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        colorLayer.frame = CGRect(x: 0, y: 2, width: self.frame.size.width, height: self.frame.size.height)
        // Insert the colorLayer into this views layer as a sublayer
        self.layer.insertSublayer(colorLayer, below: layer)
        
        // Add the indicator
        /*
        indicator.strokeColor = indicatorColor
        indicator.fillColor = indicatorColor
        indicator.lineWidth = indicatorBorderWidth
        self.layer.addSublayer(indicator)*/
        
        // Layer for the indicator
        indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = indicatorColor
        indicatorLayer.lineWidth = indicatorBorderWidth
        indicatorLayer.fillColor = nil
        self.layer.addSublayer(indicatorLayer)
        
        drawIndicator()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorCircleRadius = 18.0
        touchHandler(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorCircleRadius = 12.0
        touchHandler(touches)
    }
    
    func touchHandler(_ touches: Set<UITouch>) {
        /*
        // Set reference to the location of the touchesMoved in member point
        if let touch = touches.first {
            point = touch.location(in: self)
        }
        
        point.y = self.frame.height/2
        point.x = getXCoordinate(point.x)
        // Notify delegate of the new brightness
        delegate?.brightnessSelected(getBrightnessFromPoint())
        
        drawIndicator()*/
        
        // Set reference to the location of the touch in member point
        if let touch = touches.first {
            point = touch.location(in: self)
        }
        
        let indicator = getIndicatorCoordinate(point)
        point = indicator.point
        var color = (hue: CGFloat(0), saturation: CGFloat(0))
        if !indicator.isCenter  {
            color = hueSaturationAtPoint(CGPoint(x: point.x*scale, y: point.y*scale))
        }
        
        self.color = UIColor(hue: color.hue, saturation: color.saturation, brightness: 1.0, alpha: 1.0)
        
        // Notify delegate of the new Hue and Saturation
//        delegate?.hueAndSaturationSelected(color.hue, saturation: color.saturation)
        delegate?.brightnessSelected(getBrightnessFromPoint())
        
        // Draw the indicator
        drawIndicator()
    }
    
    //Wheel 이동반경을 정함
    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel
        
        let dimension: CGFloat = min(colorLayer.frame.width, colorLayer.frame.height)
        let radius: CGFloat = dimension/2
        let wheelLayerCenter: CGPoint = CGPoint(x: colorLayer.frame.origin.x + radius, y: colorLayer.frame.origin.y + radius)

        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx*dx + dy*dy)
        var outputCoord: CGPoint = coord
        
        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }
        
        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        let whiteThreshold: CGFloat = 10
        var isCenter = false
        if (distance < whiteThreshold) {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
            isCenter = true
        }
        return (outputCoord, isCenter)
    }
    
    func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        // Get hue and saturation for a given point (x,y) in the wheel
        
        let c = colorLayer.frame.width * scale / 2
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat (dx * dx + dy * dy))
        
        let saturation: CGFloat = d
        
        var hue: CGFloat
        if (d == 0) {
            hue = 0;
        } else {
            hue = acos(dx/d) / CGFloat(M_PI) / 2.0
            if (dy < 0) {
                hue = 1.0 - hue
            }
        }
        return (hue, saturation)
    }
    
    
    func getXCoordinate(_ coord: CGFloat) -> CGFloat {
        // Offset the x coordinate to fit the view
        if (coord < 1) {
            return 1
        }
        if (coord > frame.size.width - 1 ) {
            return frame.size.width - 1
        }
        return coord
    }
    
    func drawIndicator() {
        // Draw the indicator
        /*if (point != nil) {
            indicator.path = UIBezierPath(roundedRect: CGRect(x: point.x-3, y: 0, width: 6, height: 50), cornerRadius: 3).cgPath
        }*/
        // Draw the indicator
        if (point != nil) {
            indicatorLayer.path = UIBezierPath(roundedRect: CGRect(x: point.x-indicatorCircleRadius, y: point.y-indicatorCircleRadius, width: indicatorCircleRadius*2, height: indicatorCircleRadius*2), cornerRadius: indicatorCircleRadius).cgPath

            indicatorLayer.fillColor = self.color.cgColor
        }
    }
    
    func getBrightnessFromPoint() -> CGFloat {
        // Get the brightness value for a given point
        return point.x/self.frame.width
    }
    
    func getPointFromColor(_ color: UIColor) -> CGPoint {
        // Update the indicator position for a given color
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }

        return CGPoint(x: brightness * frame.width, y: frame.height / 2)
    }
    
    func setViewColor(_ color: UIColor!) {
        // Update the Gradient Layer with a given color
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        colorLayer.colors = [
            UIColor.black.cgColor,
            UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1).cgColor
        ]
    }
}
