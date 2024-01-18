//
//  JSProgress.swift
//  editor
//
//  Created by Jeon on 2023/07/03.
//

import Foundation
import SwiftUI

struct JSProgress<Content>: View where Content: View{
    let content: Content

    init(content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack {
                
                content
                    .frame(maxWidth:300, minHeight: 60, alignment: .center)
                    .padding(.top, 7)
                
                
                ProgressView()
            }
            .frame(maxWidth:270)
        }
    }
}


struct JSProgress_Previews: PreviewProvider {
    static var previews: some View {
        JSProgress {
            VStack(alignment: .center){
            }
        }
    }
}
extension View {
    func progress<Content>(isPresented:Binding<Bool>, progress: () -> JSProgress<Content>) -> some View where Content: View{
        let keyWindow = UIApplication.shared.connectedScenes.filter ({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene}).compactMap {$0}.first?.windows.filter { $0.isKeyWindow }.first!
        
        let vc = UIHostingController(rootView: progress())
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = .clear
        vc.definesPresentationContext = true
        
        return self.onChange(of: isPresented.wrappedValue, perform: {
            if $0{
                if let presented = keyWindow?.rootViewController?.presentedViewController {
                    presented.present(vc, animated: true)
                }
                else {
                    keyWindow?.rootViewController?.present(vc, animated: true)
                }
            }
            else{
                if let presented = keyWindow?.rootViewController?.presentedViewController {
                    presented.dismiss(animated: true)
                }
                else {
                    keyWindow?.rootViewController?.dismiss(animated: true)
                }
            }
        })
    }
}
