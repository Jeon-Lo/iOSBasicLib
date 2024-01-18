//
//  CookieManager.swift
//  eBook
//
//  Created by unidocsmac on 2023/01/03.
//

import UIKit
import WebKit


class CookieManager {
    
    static let shared = CookieManager()
    
    private init(){
    }
        
    public var cookies:Array<HTTPCookie>{
        get{
            return HTTPCookieStorage.shared.cookies ?? []
        }
    }
    
    func update(cookies: [HTTPCookie]) -> Void {
        for cookie in cookies {
            LogEx.d("domain = \(cookie.domain), name = \(cookie.name), value = \(cookie.value)")
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        save()
    }
    
    func sync(cookies:[HTTPCookie]) -> Void {
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    func reset(_ webview:WKWebView) -> Void {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        LogEx.d("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                LogEx.d("Cookie ::: \(record) deleted")
            }
        }
        webview.configuration.processPool = WKProcessPool()
    }
    
    func save() -> Void {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.cookies)
        LogEx.d("Cookies Data Size = \(data.count)")
        UserDefaults.standard.set(data, forKey: "cookies")
        UserDefaults.standard.synchronize()
    }
    
    func remove() -> Void {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        LogEx.d("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                LogEx.d("Cookie ::: \(record) deleted")
            }
        }
    }

    func restore() -> Void {
        guard let data = UserDefaults.standard.object(forKey: "cookies") as? Data else {
            return
        }
        guard let restored = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Array<HTTPCookie> else {
            return
        }
        sync(cookies: restored)
    }
    
    func cookie(_ url:URL?) -> String {
        guard let host = url?.host else {
            LogEx.d("CookieManager cookies \(url) error = host is null")
            return ""
        }
        guard let cookie = cookies.first(where: {$0.domain.contains(host) }) else {
            LogEx.d("CookieManager cookies \(url) error = cookie is null")
            return ""
        }
        return "\(cookie.name)=\(cookie.value)"
    }
    
    func getMergedCookieStr(_ url:URL?) -> String {
        guard let host = url?.host else {
            LogEx.d("CookieManager cookies \(url) error = host is null")
            return ""
        }
        let cookieList = cookies.filter { inCookie in
            inCookie.domain.contains(host)
        }
        if cookieList.isEmpty {
            LogEx.d("CookieManager cookies \(url) error = cookie is null")
            return ""
        }
        
        var mergedCookieStr = ""
        for cookie in cookieList {
            mergedCookieStr += "\(cookie.name)=\(cookie.value);"
        }
        return mergedCookieStr
    }
    
    func httpCookie(_ url:URL?) -> [HTTPCookie]? {
        guard let host = url?.host else {
            LogEx.d("CookieManager cookies \(url) error = host is null")
            return nil
        }
        
        let cookies = cookies.filter { inCookie in
            inCookie.domain.contains(host)
        }
        if cookies.isEmpty {
            LogEx.d("CookieManager cookies \(url) error = cookie is null")
            return nil
        }

        return cookies
    }
    
    func setCookie(cookie:HTTPCookie) {
        HTTPCookieStorage.shared.setCookie(cookie)
    }
}

extension HTTPCookie {
    func debugPrint() {
        LogEx.d("domain = \(domain), name = \(name), value = \(value)")
    }
}
