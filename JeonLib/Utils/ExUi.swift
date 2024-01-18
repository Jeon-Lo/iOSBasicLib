//
//  ExUi.swift
//  eBook
//
//  Created by Gi Soo Hur on 2023/03/07.
//

import UIKit
import SwiftUI
import SafariServices

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView
{
    func downloadImageFrom(urlString: String, imageMode: UIView.ContentMode)
    {
        guard let url = URL(string: urlString) else {
            return
        }
        
        self.downloadImageFrom(url: url, imageMode: imageMode)
    }
    
    func downloadImageFrom(url: URL, imageMode: UIView.ContentMode)
    {
        contentMode = imageMode
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        }
        else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    
                    self.image = imageToCache
                }
            }.resume()
        }
    }
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit)
    {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit)
    {
        guard let url = URL(string: link) else {
            return
        }
        
        downloaded(from: url, contentMode: mode)
    }
}

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var hexStr = hex
        if hexStr.hasPrefix("#") {
            hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        }
        let hexValue: Int = Int(hexStr, radix: 16)!
        let red = Double((hexValue >> 16) & 0xff) / 255
        let green = Double((hexValue >> 8) & 0xff) / 255
        let blue = Double((hexValue >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

extension UITextField {
    static let INPUT_MAX_SIZE = 16
    
    func addDoneToolbar(_ text : String = "닫기") {
        let toolbar = UIToolbar()
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem.init(title: text, style: .done, target: self, action: #selector(done))
        toolbar.items = [flexible, doneButton]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}


extension UIWindow
{
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static var topViewController: UIViewController? {
        if var topVC = UIWindow.key?.rootViewController {
            while let presentVC = topVC.presentedViewController {
                topVC = presentVC
            }
            return topVC
        }
        return nil
    }
}

extension UIView
{
    var x : CGFloat {
        get
        {
            return frame.origin.x
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y : CGFloat {
        get
        {
            return frame.origin.y
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width : CGFloat {
        get
        {
            return frame.size.width
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height : CGFloat {
        get
        {
            return frame.size.height
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX : CGFloat {
        get
        {
            return center.x
        }
        set
        {
            var tempCenter : CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    var centerY : CGFloat {
        get
        {
            return center.y
        }
        set
        {
            var tempCenter : CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    
    var size : CGSize {
        get
        {
            return frame.size
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var right : CGFloat {
        get
        {
            return frame.origin.x + frame.size.width
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var bottom : CGFloat {
        get
        {
            return frame.origin.y + frame.size.height
        }
        set
        {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
}

enum TabBarItem: Hashable {
    case home, myFiles, favorites, search,
    //editMode
    merge, share, upload, delete
    
    var iconName: (nor : String, sel : String) {
        switch self {
        case .home:
            return ("icoHomeBtnNor", "icoHomeBtnSel")
        case .myFiles:
            return ("icoHomeMyFileNor", "icoHomeMyFileSel")
        case .favorites:
            return ("icoHomeFavorNor", "icoHomeFavorSel")
        case .search:
            return ("icoHomeSearchNor", "icoHomeSearchSel")
        case .merge:
            return ("icoEditBotMergeNor", "icoEditBotMergePre")
        case .share:
            return ("icoEditBotShareNor", "icoEditBotSharePre")
        case .upload:
            return ("icoEditBotUploadNor", "icoEditBotUploadPre")
        case .delete:
            return ("icoEditBotDeleteNor", "icoEditBotDeletePre")
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .myFiles:
            return "내 파일"
        case .favorites:
            return "즐겨찾기"
        case .search:
            return "검색"
        case .merge:
            return "PDF 합치기"
        case .share:
            return "공유"
        case .upload:
            return "에디터온 클라우드에 업로드"
        case .delete:
            return "삭제"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return Color.blue
        case .myFiles:
            return Color.blue
        case .favorites:
            return Color.blue
        case .search:
            return Color.blue
        case .merge:
            return Color.white
        case .share:
            return Color.white
        case .upload:
            return Color.white
        case .delete:
            return Color.white
        }
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}

