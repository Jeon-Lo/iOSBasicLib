//
//  JUImagePicker.swift
//  editor
//
//  Created by Jeon on 2023/11/09.
//

import Foundation
import UIKit

class JUImagePicker : UIImagePickerController, UINavigationControllerDelegate {
    var pickHandler : ((UIImage) -> ())?
//    var multiPickHandler : (([UIImage]) -> ())?
    var cancelHandler : (() -> Void)?
    
    public func setPickHandler(pickHandler : @escaping ((UIImage) -> ())) {
        self.pickHandler = pickHandler
    }
    
//    public func setMultiPickHandler(pickHandler : @escaping (([UIImage]) -> ())) {
//        self.multiPickHandler = pickHandler
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension JUImagePicker : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cancelHandler?()
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //카메라 사진첨부
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.pickHandler?(image)
        }
        //갤러리 사진첨부
        else if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            self.pickHandler?(image)
        }
        self.dismiss(animated: true)
    }
}
