//
//  JUContextMenu.swift
//  editor
//
//  Created by Jeon on 2023/09/22.
//

import UIKit
import RxSwift
import RxGesture

extension JUContextMenu {
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> JUContextMenu {
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! JUContextMenu
    }
}

class JUContextMenu : UIView {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var btnTouch: JUTouchPassButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var containerLeading: NSLayoutConstraint!
    @IBOutlet weak var containerTop: NSLayoutConstraint!
    private var onItemTappedHandler : ((JUContextMenuAction) -> Void)? = nil
    public func setOnItemTappedHandler(_ handler : @escaping (JUContextMenuAction) -> Void) {
        self.onItemTappedHandler = handler
    }
    
    private var dismissHandler : (() -> Void)? = nil
    public func setDismissHandler(_ handler : @escaping () -> Void) {
        self.dismissHandler = handler
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.container.layer.cornerRadius = 25
        self.container.clipsToBounds = true
    }
    
    let edgeMargin : CGFloat = 10
    
    func attach(parent: UIView, limitView : UIView, sourceView : CGRect, menuActionList : [JUContextMenuAction], isTextAnnot : Bool = false) {
        self.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        self.removeFromSuperview()
        parent.addSubview(self)
        parent.insetsLayoutMarginsFromSafeArea = true
        parent.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0).isActive = true
        for menuAction in menuActionList {
            let view = JUContextMenuActionView.instanceFromNib()
            view.configureWithData(menuAction) { menuAction in
                self.onItemTappedHandler?(menuAction)
                self.dismiss()
            }
            self.stackView.addArrangedSubview(view)
        }
        containerWidth.constant = CGFloat((32 * menuActionList.count) + (5 * (menuActionList.count - 1)) + 48)
        let limitFrame = limitView.convert(parent.frame, to: nil)
        let remainTop = (sourceView.minY - (self.edgeMargin * (isTextAnnot ? 1 : 2))) - limitFrame.minY
        containerTop.constant = remainTop
        if remainTop <= self.container.height {
            containerTop.constant += self.container.height + sourceView.height + (self.edgeMargin * (isTextAnnot ? 2 : 4))
        }
        let leading = sourceView.midX - (containerWidth.constant / 2)
        let trailing = leading + containerWidth.constant
        let overDis = trailing - parent.frame.width > 0 ? (trailing - parent.frame.width) + self.edgeMargin : 0
        containerLeading.constant = leading > 0 ? leading - overDis : self.edgeMargin
        
        self.setShadow(self.container, CGSize(width: 3, height: 3), 10, 0.5)
        self.btnTouch.linkedView = parent
        self.btnTouch.setHittedHandler {
            self.dismiss()
        }
    }
    
    private func dismiss() {
        self.removeFromSuperview()
        guard let handler = self.dismissHandler else {
            return
        }
        handler()
    }
    
    public func setShadow(_ view : UIView, _ offset : CGSize, _ radius : CGFloat, _ alpha : CGFloat) {
        // 검정색 사용
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = offset
        // 반경?
        view.layer.shadowRadius = radius
        // alpha값입니다.
        view.layer.shadowOpacity = Float(alpha)
    }
}

class JUContextMenuActionView : UIView {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var button: UIButton!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> JUContextMenuActionView {
        return UINib(nibName: "JUContextMenu", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! JUContextMenuActionView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapItem)))
    }
    
    @objc func onTapItem() {
        onTapHandler?(self.menuAction)
    }
    
    private var onTapHandler : ((JUContextMenuAction) -> Void)? = nil
    
    private var menuAction : JUContextMenuAction!
    
    func configureWithData(_ menuAction : JUContextMenuAction, _ onTapHandler : @escaping (JUContextMenuAction) -> Void) {
        self.menuAction = menuAction
        self.onTapHandler = onTapHandler
        self.backgroundColor = menuAction.backgroundColor
        self.button.setImage(UIImage(named: "context/\(menuAction.image)Nor"), for: .normal)
        self.button.setImage(UIImage(named: "context/\(menuAction.image)Sel"), for: .highlighted)
    }
}

struct JUContextMenuAction {
    let title : String
    let image : String
    let action : Selector
    var backgroundColor : UIColor = UIColor.clear
    
    init(title: String, image: String, action: Selector,_ backgroundColor: UIColor = UIColor.clear) {
        self.title = title
        self.image = image
        self.action = action
        self.backgroundColor = backgroundColor
    }
}

