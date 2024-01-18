//
//  JUKit.swift
//  editor
//
//  Created by Jeon on 2023/06/27.
//

import Foundation
import UIKit

class JUKit {
    static func popToRootView() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let rootVC = findNavigationController(viewController: keyWindow?.rootViewController)
        rootVC?.popToRootViewController(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}

extension JUKit {
    //ViewController
    class VC {
        static func present(_ storyboardName : String, _ vid : String? = nil) {
            guard let vc : UIViewController = JUKit.VC.getInstanceViewController(storyboardName, vid) else {
                return
            }
            JUKit.VC.present(vc)
        }
        
        static func getInstanceViewController<T : UIViewController>(_ storyBoardName : String, _ vcName : String? = nil) -> T? {
            let viewControllerName = vcName ?? storyBoardName
            let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: Bundle.main)
            let vc = storyBoard.instantiateViewController(withIdentifier: viewControllerName) as? T
            return storyBoard.instantiateViewController(withIdentifier: viewControllerName) as? T
        }
        
        static func push<T : UIViewController>(_ vc : T) {
            vc.modalPresentationStyle = .fullScreen
            if let rootVc = UIWindow.key?.rootViewController {
                for child in rootVc.children {
                    if let nv = child as? UINavigationController {
                        nv.pushViewController(vc, animated: true)
                        return
                    }
                }
                if let nRoot = rootVc as? UINavigationController {
                    nRoot.pushViewController(vc, animated: true)
                }
                else if let presented = rootVc.presentedViewController {
                    JUKit.VC.presentPushStyle(presented, vc)
                }
                else {
                    JUKit.VC.presentPushStyle(rootVc, vc)
                }
            }
            else {
                LogEx.e("not founded rootViewController")
            }
        }
        
        static func present<T : UIViewController>(_ vc : T, isCloseable : Bool = false, animated : Bool = false, isPresentFromLastVC : Bool = false) {
            vc.isModalInPresentation = !isCloseable
            if let rootVc = UIWindow.key?.rootViewController {
                if isPresentFromLastVC {
                    if let last = rootVc.children.last{
                        last.modalPresentationStyle = .fullScreen
                        last.present(vc, animated: animated)
                        return
                    }
                }
                if let presented = rootVc.presentedViewController {
                    presented.modalPresentationStyle = .fullScreen
                    presented.present(vc, animated: animated)
                }
                else {
                    rootVc.modalPresentationStyle = .fullScreen
                    rootVc.present(vc, animated: animated)
                }
            }
            else {
                LogEx.e("not founded rootViewController")
            }
        }
        
        private static func presentPushStyle(_ vc : UIViewController, _ willPresentViewController : UIViewController) {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            vc.view.window!.layer.add(transition, forKey: kCATransition)
            vc.present(willPresentViewController, animated: false)
        }
        
        public static func dismissPushStyle(_ vc : UIViewController) {
            /*
             let transition = CATransition()
             transition.duration = 0.5
             transition.type = CATransitionType.push
             transition.subtype = CATransitionSubtype.fromLeft
             transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
             vc.view.window!.layer.add(transition, forKey: kCATransition)*/
            if let navi = vc.navigationController {
                navi.popViewController(animated: false)
            }
            else {
                vc.dismiss(animated: false)
            }
        }
    }
}
extension JUKit {
    class Activity {
        static func shareText(_ title : String?, _ text : String, _ completionHandler : ((Bool) -> Void)? = nil) {
            var shareObj = [Any]()
            // Add the path of the file to the Array
            shareObj.append(text)
            let avc = UIActivityViewController(activityItems: shareObj, applicationActivities: nil)
            // Be notified of the result when the share sheet is dismissed
            avc.title = title
            avc.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                LogEx.e("activityType : \(activityType), completed : \(completed),  returnedItems : \(returnedItems),  activityError : \(activityError)")
                completionHandler?(completed)
                if let error = activityError {
                    JUKit.Toast.show("공유를 실패했습니다. error : \(error.localizedDescription)")
                }
                else if completed {
                    JUKit.Toast.show("공유를 완료 했습니다.")
                }
            }
            // Show the share-view
            if let viewController = UIWindow.key?.rootViewController, let view = viewController.view, UIViewController.isPad() {
                avc.popoverPresentationController?.sourceView = view
                avc.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY,width: 0,height: 0)
                avc.popoverPresentationController?.permittedArrowDirections = []
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                UIWindow.key?.rootViewController?.present(avc, animated: true, completion: nil)
            }
        }
        
        static func show(_ title : String?, _ filePathes : [String], _ completionHandler : ((Bool) -> Void)? = nil) {
            var filesToShare = [Any]()
            
            for path in filePathes {
                filesToShare.append(NSURL(fileURLWithPath: path))
            }
            // Make the activityViewContoller which shows the share-view
            let avc = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            // Be notified of the result when the share sheet is dismissed
            avc.title = title
            avc.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                LogEx.e("activityType : \(activityType), completed : \(completed),  returnedItems : \(returnedItems),  activityError : \(activityError)")
                completionHandler?(completed)
                if let error = activityError {
                    JUKit.Toast.show("공유를 실패했습니다. error : \(error.localizedDescription)")
                }
                else if completed {
                    JUKit.Toast.show("공유를 완료 했습니다.")
                }
            }
            // Show the share-view
            if let viewController = UIWindow.key?.rootViewController, let view = viewController.view, UIViewController.isPad() {
                avc.popoverPresentationController?.sourceView = view
                avc.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY,width: 0,height: 0)
                avc.popoverPresentationController?.permittedArrowDirections = []
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                UIWindow.key?.rootViewController?.present(avc, animated: true, completion: nil)
            }
        }
        
        static func show(_ title : String?,_ filePath : String, _ completionHandler : ((Bool) -> Void)? = nil) {
            let fileURL = NSURL(fileURLWithPath: filePath)
            // Create the Array which includes the files you want to share
            var filesToShare = [Any]()
            // Add the path of the file to the Array
            filesToShare.append(fileURL)
            // Make the activityViewContoller which shows the share-view
            let avc = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            // Be notified of the result when the share sheet is dismissed
            avc.title = title
            avc.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                LogEx.e("activityType : \(activityType), completed : \(completed),  returnedItems : \(returnedItems),  activityError : \(activityError)")
                completionHandler?(completed)
                if let error = activityError {
                    JUKit.Toast.show("공유를 실패했습니다. error : \(error.localizedDescription)")
                }
                else if completed {
                    JUKit.Toast.show("공유를 완료 했습니다.")
                }
            }
            // Show the share-view
            if let viewController = UIWindow.key?.rootViewController, let view = viewController.view, UIViewController.isPad() {
                avc.popoverPresentationController?.sourceView = view
                avc.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY,width: 0,height: 0)
                avc.popoverPresentationController?.permittedArrowDirections = []
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                UIWindow.key?.rootViewController?.present(avc, animated: true, completion: nil)
            }
        }
        
    }
}

extension JUKit {
    class Alert {
        static func show(_ title : String?, _ message : String?, _ cancel : (text : String, action : ((UIAlertAction) -> Void)), _ confirm : (text : String, action : ((UIAlertAction) -> Void))? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let cf = confirm {
                alert.addAction(UIAlertAction(title: cf.text, style: .default, handler: cf.action))
            }
            alert.addAction(UIAlertAction(title: cancel.text, style: .cancel, handler: cancel.action))
            alert.modalPresentationStyle = .automatic
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                UIWindow.key?.rootViewController?.present(alert, animated: false)
            }
            
        }
        
        static func input(_ title : String?, _ message : String?, _ placeHolder : String?, _ srcTxt : String?, _ cancel : (text : String, action : ((UIAlertAction) -> Void)), _ confirm : (text : String, action : ((UIAlertAction, String?) -> Void))? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField() { tf in
                tf.placeholder = placeHolder
                tf.text = srcTxt
                tf.font = UIFont.init(name: (tf.font?.fontName)!, size: 18.0)!
                tf.layoutIfNeeded()
                tf.clearButtonMode = .always
            }
            if let cf = confirm {
                alert.addAction(UIAlertAction(title: cf.text, style: .default) { action in
                    cf.action(action, alert.textFields?[0].text)
                })
            }
            alert.addAction(UIAlertAction(title: cancel.text, style: .cancel, handler: cancel.action))
            alert.modalPresentationStyle = .automatic
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                UIWindow.key?.rootViewController?.present(alert, animated: false)
            }
        }
    }
}

extension JUKit {
    class Toast {
        static func show(_ message : String, _ length : JUToast.LENGTH = JUToast.LENGTH.short, _ view : UIView? = nil) {
            JUToast.makeText(message, length).show(view)
        }
    }
}

extension JUKit {
    class Progress {
        static func show(loadingType : LOADING_TYPE = .CHARACTER, message : String = "잠시만 기다려주세요.", subMessage : String? = nil, view : UIView? = nil, isNeedDimmed : Bool = true) {
            JUKit.Progress.close()
            let progress = JUProgress.instanceFromNib()
            progress.lbMessage.text = message
            progress.lbSubMessage.text = subMessage
            progress.lbSubMessage.isHidden = subMessage == nil
            progress.show(loadingType: loadingType, view : view, isNeedDimmed : isNeedDimmed)
        }
        
        static func show(loadingType : LOADING_TYPE = .CHARACTER, message : String = "잠시만 기다려주세요.", subMessage : String? = nil, _ completionHandler : ((JUProgress) -> Void)? = nil) {
            JUKit.Progress.close()
            let progress = JUProgress.instanceFromNib()
            progress.lbMessage.text = message
            progress.lbSubMessage.text = subMessage
            progress.lbSubMessage.isHidden = subMessage == nil
            progress.show(loadingType: loadingType, isNeedDimmed: true)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
                completionHandler?(progress)
            }
        }
        
        static func close(_ view : UIView? = nil) {
            var parentView = view ?? UIWindow.key
            guard let window = parentView else {
                return
            }
            for subView in window.subviews {
                if let p = subView as? JUProgress {
                    p.close()
                }
            }
        }
        
        static func progressView() -> JUProgress? {
            guard let window = UIWindow.key else {
                return nil
            }
            for subView in window.subviews {
                guard let progressView = subView as? JUProgress else {
                    continue
                }
                return progressView
            }
            return nil
        }
        
        static func setText(_ message : String) {
            guard let progressView = JUKit.Progress.progressView() else {
                return
            }
            DispatchQueue.main.async {
                progressView.lbMessage.text = message
            }
        }
    }
}
