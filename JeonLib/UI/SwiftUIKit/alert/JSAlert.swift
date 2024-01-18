//
//  JSAlert.swift
//  editor
//
//  Created by Jeon on 2023/06/23.
//

import SwiftUI

struct JSAlert<Content>: View where Content: View{
    let content: Content
    let primaryButton: JSAlertButton
    let secondButton: JSAlertButton?

    init(content: () -> Content, primaryButton: () ->  JSAlertButton, secondButton: (() -> JSAlertButton)? = nil){
        self.content = content()
        self.primaryButton = primaryButton()
        self.secondButton = secondButton?()
    }
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack {
                
                content
                    .frame(maxWidth:300, minHeight: 60, alignment: .center)
                    .padding(.top, 7)
                
                VStack(spacing:0){
                    if primaryButton.color == nil{
                        Divider()
                    }
                    
                    HStack(){
                        primaryButton
                        if secondButton != nil{
                            Divider()
                            secondButton
                        }
                    }
                    .frame(height:45)
                    .font(.system(size: 18,weight: .regular))
                }
            }
            .frame(maxWidth:270)
            .background(
                Color(hex: "#EEEEEE", opacity: 0.95)
            ).cornerRadius(17)
            /*
            content
                .padding(.bottom, 60)
                .frame(maxWidth:315, minHeight: 120)
                .overlay(
                    VStack(spacing:0){
                        if primaryButton.color == nil{
                            Divider()
                        }
                        
                        HStack(){
                            primaryButton
                            if secondButton != nil{
                                Divider()
                                secondButton
                            }
                        }
                        .frame(height:48)
                        .font(.system(size: 18,weight: .regular))
                    }
                    , alignment: .bottom)
                .background(
                    Color.white.opacity(0.95)
                ).cornerRadius(20)*/
        }
    }
}

struct JSAlertButton: View {
    typealias Action = () -> ()
    
    private let action: Action
    private let title: Text
    let color: Color?
    
    init(title:Text,color:Color? = nil,action: @escaping Action){
        self.title = title
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button{
            action()
        }label: {
            title.frame(maxWidth:.infinity, maxHeight: .infinity)
        }.background(color)
    }
}


struct JSAlert_Previews: PreviewProvider {
    static var previews: some View {
        JSAlert {
            VStack(alignment: .center){
                Text("default").fontWeight(.bold)
            }
        } primaryButton: {
            JSAlertButton(title: Text("확인")) {
                print("custom Action!")
            }
        } secondButton: {
            JSAlertButton(title: Text("취소")) {
                print("custom Action!")
            }
        }
    }
}


extension View {
    func alert<Content>(isPresented:Binding<Bool>, alert: () -> JSAlert<Content>) -> some View where Content: View{
            let keyWindow = UIApplication.shared.connectedScenes.filter ({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene}).compactMap {$0}.first?.windows.filter { $0.isKeyWindow }.first!

            let vc = UIHostingController(rootView: alert())
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
