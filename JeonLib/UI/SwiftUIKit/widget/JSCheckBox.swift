//
//  JSCheckBox.swift
//  editor
//
//  Created by Jeon on 2023/06/26.
//

import SwiftUI

struct JSCheckBox: ToggleStyle {
    var normalImage : Image
    var checkImage : Image
    var foregroundColor : Color? = nil
    init(normalImage: Image, checkImage: Image,_ foregroundColor: Color? = nil) {
        self.normalImage = normalImage
        self.checkImage = checkImage
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                if let foregroundColor = self.foregroundColor {
                    configuration.isOn ? checkImage.foregroundColor(foregroundColor) : normalImage.foregroundColor(foregroundColor)
                }
                else {
                    configuration.isOn ? checkImage : normalImage
                }
                configuration.label
            }
        }
    }
}

