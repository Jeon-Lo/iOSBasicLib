//
//  Date.swift
//  eBook
//
//  Created by puttana on 2023/01/05.
//

import Foundation
import CommonCrypto
import UIKit
import SafariServices

extension String {
    func date() -> Date? {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toDate(_ format : String = "yyyy.MM.dd") ->  Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        //        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        if let date = dateFormatter.date(from: self) {
            return date
        }
        else {
            return nil
        }
    }
    
    func removeExtension() -> String
    {
        
        guard let lastIndex = self.lastIndex(of:"."), self.contains(".") else {
            return self
        }
        return String(self[..<lastIndex])
    }
    
    func `extension`() -> String
    {
        guard let lastIndex = self.lastIndex(of:".") else {
            return ""
        }
        let i = self.index(lastIndex, offsetBy: 1)
        return String(self[i..<endIndex]).lowercased()
    }
    
    func lastPath() -> String
    {
        guard let lastIndex = self.lastIndex(of:"/") else {
            return self
        }
        return String(self[lastIndex..<self.endIndex])
    }
    
    func removeLastPath() -> String
    {
        guard let lastIndex = self.lastIndex(of:"/") else {
            return self
        }
        return String(self[..<lastIndex])
    }

    
    func fileName() -> String
    {
        guard let lastIndex = self.lastIndex(of:"/") else {
            return self
        }
        var ret = String(self[lastIndex..<self.endIndex])
        ret.remove(at: String.Index(utf16Offset:0, in: ret))
        return ret
    }
    
    func getRelativePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return self.replacingOccurrences(of: documentPath, with: "")
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
    }
    func decodeHex() -> Data {
        let stringArray = Array(self)
        var data: Data = Data()
        for i in stride(from: 0, to: self.count, by: 2) {
            let pair: String = String(stringArray[i]) + String(stringArray[i+1])
            if let byteNum = UInt8(pair, radix: 16) {
                let byte = Data([byteNum])
                data.append(byte)
            }
            else{
                fatalError()
            }
        }
        return data
    }
    func isFileExist() -> Bool {
        return FileManager.default.fileExists(atPath: self)
    }
    
    func removeFile() {
        do {
            try FileManager.default.removeItem(atPath: self)
        } catch {            
        }
    }
}

extension DateFormatter {
    static func LocalDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }
}

extension Date {
    func string(_ format : String = "yyyyMMddHHmmss") -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func string_ebook() -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
    func string_note() -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func string_memo() -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func yyyy() -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func MM() -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    func dd() -> String {
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    static func of(_ year:Int, _ month:Int, _ day:Int) -> Date {
        return DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date ?? Date()
    }
    
    static func getCurrentTime(_ dateFormat : String = "yyyy-MM-dd HH:mm:ss.SSS") -> String {
        let now=NSDate()
        let dateFormatter = DateFormatter.LocalDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: now as Date)
    }
}

extension Int64 {
    func fileSize() -> String {
        if Double(self) >= 1e+9 {
            return String(format: "%.2f GB", Double(self)/1e+9)
        } else if self >= 1048576 {
            return String(format: "%.2f MB", Double(self)/1048576.0)
        } else if self >= 1024 {
            return String(format: "%.2f KB", Double(self)/1024.0)
        } else {
            return "\(self) BYTE"
        }
    }
    
    func displayFileSize() -> String {
        if Double(self) >= 1e+9 {
            return "\((round(Double(self)/1e+9)*100)/100) GB"
        } else if self >= 1048576 {
            return "\((round(Double(self)/1048576.0)*100)/100) MB"
        } else if self >= 1024 {
            return "\((round(Double(self)/1024.0)*100)/100) KB"
        } else {
            return "\(self) BYTE"
        }
    }
}

extension Int {
    func color() -> UIColor {
        return UIColor(argb: self)
    }
    
    func fileSize() -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = .useAll
        byteCountFormatter.countStyle = .file
        let folderSizeToDisplay = byteCountFormatter.string(fromByteCount: Int64(self))
        return self == 0 ? "0 MB" : folderSizeToDisplay
    }
    
}

extension Data {
    func encodeHex() -> String {
        return map { String(format: "%02hhx ", $0) }.joined()
    }
}

extension UIColor
{
    public convenience init(argb: Int) {
        let iBlue = argb & 0xFF
        let iGreen =  (argb >> 8) & 0xFF
        let iRed =  (argb >> 16) & 0xFF
        let iAlpha =  (argb >> 24) & 0xFF
        self.init(red: CGFloat(iRed)/255, green: CGFloat(iGreen)/255,
                  blue: CGFloat(iBlue)/255, alpha: CGFloat(iAlpha)/255)
    }

    public convenience init?(hex: String)
    {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    
                    return
                }
            }
            else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    
                    return
                }
            }

        }

        return nil
    }
    
    func argb() -> Int {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let argb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return argb
        } else {
            // Could not extract ARGB components:
            return 0
        }
    }
    
    static let TRANSPARENT = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
}


extension UIView
{
    func initRoundLayer()
    {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor  // UIColor.lightGray.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = true
    }
    
    func initCircleLayer()
    {
        self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height)/2.0;
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true
    }
    
    func initCircleBorderLayer()
    {
        self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height)/2.0;
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
}


extension NSMutableAttributedString
{
    func highlight(_ target: String, _ color: UIColor)
    {
        if target == "" {
            return
        }
        
        let targetValue = target
        let regPattern = targetValue
        
        if let regex = try? NSRegularExpression(pattern: regPattern, options: [.caseInsensitive]) {
            let matchesArray = regex.matches(in: self.string, options: [], range: NSRange(location: 0, length: self.length))
            
            for match in matchesArray {
                let attributedText = NSMutableAttributedString(string: targetValue)
                attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: NSRange(location: 0, length: attributedText.length))
                self.replaceCharacters(in: match.range, with: attributedText)
            }
        }
    }
}

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}

        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {

            let key = pair.components(separatedBy: "=")[0]

            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""

            queryStrings[key] = value
        }
        return queryStrings
    }
}

extension Data {
    func string() -> String? {
        return String(data: self, encoding: .utf8)
    }
}


extension UIViewController {
    
    func openSafariController(_ strUrl : String) {
        LogEx.d("openSafariController strUrl : \(strUrl)")
        guard let url = URL(string: strUrl) else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func openSafariController(_ urlreq : URLRequest?) {
        guard let request = urlreq, let url = request.url else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    
    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    static func isLandscape() -> Bool {
        return (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight)
    }
    
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
