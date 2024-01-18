//
//  ProgressDialog.swift
//  PDFApp
//
//  Created by Jeon on 2023/05/16.
//

import UIKit

class ProgressDialog: BaseCustomDialog<ProgressDialog> {
    public func show() {
        super.show(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isViewTapClose = false
    }
    
    public func close() {
        self.removeFromSuperview()
        guard let handler = self.dismissHandler else {
            return
        }
        handler()
    }
}
