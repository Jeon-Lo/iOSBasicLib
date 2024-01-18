//
//  ProgressDialog.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/16.
//

import UIKit

class JUProgress: BaseAlert<JUProgress> {
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbSubMessage: UILabel!
//    @IBOutlet weak var progressBar: LinearProgressBar!
    @IBOutlet weak var ivCharacter: UIImageView!
    @IBOutlet weak var ivSimple: UIImageView!
    @IBOutlet weak var simpleAnimContainer: UIView!
    @IBOutlet weak var characterContainer: UIView!
    
    private var loadingType : LOADING_TYPE = .CHARACTER
    
    override func awakeFromNib() {
        super.awakeFromNib(true)
        self.isViewTapClose = false
    }
    
    public func show(loadingType : LOADING_TYPE = .CHARACTER, view : UIView? = nil, isNeedDimmed : Bool = true) {
        super.show(isNeedDimmed, view)
        self.loadingType = loadingType
        
        if self.loadingType == .CHARACTER {
            self.characterContainer.layer.cornerRadius = self.characterContainer.height / 2
            self.characterContainer.clipsToBounds = true
            
//            self.progressBar.layer.cornerRadius = 5
//            self.progressBar.clipsToBounds = true
            
            self.ivCharacter.animationImages = self.getAnimationImages(.RANDOM)
            self.ivCharacter.startAnimating()
            
        }
        else if self.loadingType == .LOGO {
            self.ivSimple.animationImages = self.getAnimationImages(.NONE)
            self.ivSimple.startAnimating()
        }
        self.characterContainer.isHidden = self.loadingType != .CHARACTER
        self.simpleAnimContainer.isHidden = self.loadingType != .LOGO
        /*self.progressBar.isHidden = self.loadingType == .NONE
//        self.progressBar.transition(to: .indeterminate, delay: 0)
        if self.loadingType != .LOGO {
            self.progressBar.progressBarWidth = 10
            self.progressBar.backgroundColor = UIColor(hexString: "#25262")
            self.progressBar.progressBarColor = UIColor(hexString: "6C90FF")
            self.progressBar.cornerRadius = 10
            self.progressBar.startAnimating()
        }*/
    }
    
    public func close() {
        self.removeFromSuperview()
        guard let handler = self.dismissHandler else {
            return
        }
        handler()
    }
}

extension JUProgress {
    public func getAnimationImages(_ _type : LOADING_CHARACTER_TYPE) -> [UIImage] {
        var type = _type
        if type == .NONE {
            return self.getBasicAnimationImages()
        }
        if type == .RANDOM {
            type = LOADING_CHARACTER_TYPE(rawValue: Int.random(in: 1..<4))!
        }
        return self.getCharacterAnimationImages(type)
    }
    
    private func getBasicAnimationImages() -> [UIImage] {
        var images = [UIImage]()
        for i in 0 ..< 27 {
            guard let image = UIImage(named: "loading/loadingAnim1_\(i + 1)") else {
                continue
            }
            images.append(image)
        }
        return images
    }
    
    private func getCharacterAnimationImages(_ type : LOADING_CHARACTER_TYPE) -> [UIImage] {
        var images = [UIImage]()
        if type == .NONE || type == .RANDOM {
            return images
        }
        for i in 0 ..< 8 {
            guard let image = UIImage(named: "loading/loadingAnim\(type.rawValue + 1)_\(i + 1)") else {
                continue
            }
            images.append(image)
        }
        return images
    }
    

}

enum LOADING_TYPE : Int {
    case NONE = 0
    case CHARACTER = 1
    case LOGO = 2
}


enum LOADING_CHARACTER_TYPE : Int {
    case NONE = 0
    case WORK = 1
    case FLY = 2
    case HEAD = 3
    case RANDOM = 4
}
