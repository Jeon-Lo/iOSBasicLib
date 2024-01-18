//
//  JSButton.swift
//  editor
//
//  Created by Jeon on 2023/08/21.
//

import SwiftUI

struct JSStateButton : View {
    var imageSet : (nor : String, sel : String)
    
    @State private var isPressed = false
    var tabHandler : (() -> Void)?
    @GestureState var isTapping = false
    @GestureState private var location: CGPoint = .zero
    
    var body: some View {
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($location) { value, state, transaction in
                state = value.location
            }
            .onEnded({ _ in
                if isPressed {
                    tabHandler?()
                }
            })
        Image(isPressed ? imageSet.sel : imageSet.nor)
            .gesture(dragGesture)
            .background(rectReader())
    }
    
    func rectReader() -> some View {
        return GeometryReader { (geometry) -> AnyView in
            //왜 이걸 해야 통하는지...
            self.location
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
                self.isPressed = geometry.frame(in: .global).contains(self.location)
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }
    
    func isContainFrame(_ frame : CGRect, _ location : CGPoint) -> Bool {
        var isContainX = false
        if location.x > frame.minX && location.x < (frame.minX + frame.width) {
            isContainX = true
        }
        var isContainY = false
        if location.y > frame.minY && location.y < (frame.minY + frame.height) {
            isContainY = true
        }
        
        return isContainX && isContainY
    }
    
}

struct JSStateButton_Previews: PreviewProvider {
    static var previews: some View {
        JSStateButton(imageSet: (nor: "icoListStarNor", sel: "icoListStarSel")) {
            LogEx.e("dsadasd")
        }
    }
}

