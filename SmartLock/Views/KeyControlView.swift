//
//  KeyControlView.swift
//  SmartLock
//
//  Created by 会津慎弥 on 2017/11/13.
//  Copyright © 2017年 会津慎弥. All rights reserved.
//

import UIKit

@IBDesignable
class KeyControlView: UIView {
    
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var currentLockStatusImage: UIImageView!
    
    @IBOutlet weak var timeTextFIeld: UITextField!
    @IBOutlet weak var controledTextField: UITextField!
    
    let lockImage = UIImage(named:"Lock")!
    let unlockImage = UIImage(named:"Unlock")!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("KeyControlView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setCurrentLockStatus(isLock: Bool){
        
        if isLock {
            currentLockStatusImage.image = lockImage
        } else {
            currentLockStatusImage.image = unlockImage
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
