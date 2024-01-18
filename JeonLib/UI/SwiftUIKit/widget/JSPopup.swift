//
//  JSPopup.swift
//  editor
//
//  Created by Jeon on 2023/09/25.
//

import SwiftUI

struct JSPopup<Content: View>: View {
    let content : Content
    let width : CGFloat
    let height : CGFloat
    
    init(width : CGFloat, height : CGFloat, @ViewBuilder Content: () -> Content)  {
        self.width = width
        self.height = height
        self.content = Content()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    self.content
                }
                .frame(width: width, height: height)
                .background {
                    RoundedRectangle(cornerRadius: 22).foregroundColor(Color(hex: "#2C2C2C"))
                }
                .clipped()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background {
            Color.black.opacity(0.5)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct JSPopup_Previews: PreviewProvider {
    
    static var previews: some View {
        JSPopup(width: 460, height: 550) {
                
        }

        /*
        GeometryReader { proxy in
            JSPopup(width: 460, height: 550) {
                ZStack {
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Button {
                                LogEx.e("취소")
                            } label: {
                                Text("취소").font(.system(size: 16)).foregroundColor(Color(hex: "#B0B0B0"))
                            }
                            .frame(width: 28, height: 19)
                            .padding(.top, 17)
                            .padding(.leading, 21)
                            Spacer()
                        }
                        Spacer()
                    }
                    Text("PDF 합치기").font(.system(size: 20, weight: .bold)).foregroundColor(Color.white)
                }
                .frame(height: 67)
                Divider().frame(height: 1).foregroundColor(Color(hex: "#505154"))
                List {
                    
                }
                .frame(height: 302)
                .padding(.horizontal, 20)
                
                HStack(spacing: 0) {
                    Button {
                        LogEx.e("내 파일에서 파일 추가")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .strokeBorder(lineWidth: 1.5, antialiased: true)
                                .foregroundColor(Color(hex: "#5C5C5C"))
                            
                            HStack {
                                Image("iconScSearchSel").frame(width: 10, height: 10).padding(.trailing, 7)
                                Text("내 파일에서 파일 추가").font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#C3C3C3"))
                                
                                Spacer()
                            }
                            .padding(.leading, 15)
                        }
                        .background {
                            Color(hex: "#28292C")
                        }
                    }
                    .frame(width: 169, height: 36)
                    
                    Text("").frame(width: 13)
                    
                    Button {
                        LogEx.e("다른 위치 파일 추가")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .strokeBorder(lineWidth: 1.5, antialiased: true)
                                .foregroundColor(Color(hex: "#5C5C5C"))
                            
                            HStack {
                                Image("iconScSearchSel").frame(width: 10, height: 10).padding(.trailing, 7)
                                Text("다른 위치 파일 추가").font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#C3C3C3"))
                                
                                Spacer()
                            }
                            .padding(.leading, 15)
                        }
                        .background {
                            Color(hex: "#28292C")
                        }
                    }
                    .frame(width: 169, height: 36)
                }
                .padding(.top, 15)
                
                Divider().padding(.top, 13).foregroundColor(Color(hex: "#464748"))
                
                TextField("", text: .constant("Text"), prompt: Text("파일제목_combine"))
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "8DA9FF"))
                    .submitLabel(.done)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                    .padding(.horizontal, 10)
                    .background{
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .foregroundColor(Color(hex: "#212121"))
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .strokeBorder(lineWidth: 1.5, antialiased: true)
                                .foregroundColor(Color(hex: "#5C5C5C"))
                        }
                        .frame(height: 40)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                
                Button {
                    
                } label: {
                    VStack(spacing: 0) {
                        Spacer()
                        HStack(spacing: 0) {
                            Spacer()
                            Text("파일 합치기").font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#8DA9FF"))
                            Spacer()
                        }
                        Spacer()
                    }
                    .background {
                        Color(hex: "#3149AC")
                    }
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                }
                .padding(.top, 8)
            }
        }*/
    }
}
