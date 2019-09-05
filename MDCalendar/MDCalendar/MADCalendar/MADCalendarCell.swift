//
//  MADCalendarCell.swift
//  OstrichBlockChain
//
//  Created by 梁宪松 on 2018/10/31.
//  Copyright © 2018 ipzoe. All rights reserved.
//

import UIKit

class MADCalendarCell: UICollectionViewCell {
    
    let defualtTextHighlightColor = UIColor.init(red: 0, green: 122.0/255, blue: 1, alpha: 1)
    
    // MARK: Var
    var model: MADCalendarDayModel? {
        willSet {
            if let _ = newValue {
                
                titleLabel.text = "\(newValue!.day)"
                pointButton.isHidden = true
//                backgroundColor = UIColor.purple
//                layer.masksToBounds = true
//                layer.cornerRadius = 20
              
                // if is today
                if newValue!.isToday == true {
                  
                  titleLabel.textColor = defualtTextHighlightColor
                  titleLabel.backgroundColor = UIColor.white
                  titleLabel.mad_set(cornerRadius: 17)
                  addAnimation()
                  
                } else {
                  titleLabel.textColor = UIColor.white
                  titleLabel.backgroundColor = UIColor.clear
                  titleLabel.mad_resetCornerRadius()
                  
                  switch newValue!.dayTag {
                  case .currentMonth:
                    titleLabel.textColor = UIColor.white
                  default:
                    titleLabel.textColor = UIColor.red//UIColor.white.withAlphaComponent(0.5)
                  }
                  
                }
//              }
            }
        }
    }
    
    // MARK: UI Component
    lazy var titleLabel: UILabel = {
        
        let label = UILabel.init()
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        } else {
            label.font = UIFont.systemFont(ofSize: 14)
        }
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "12"
        return label
    }()
    
    lazy var pointButton: UIButton = {
        
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setBackgroundImage(UIImage.mad_getImage(color: UIColor.white, size: CGSize.init(width: 3, height: 3), cornerRadius: 1.5), for: .normal)
        button.setBackgroundImage(UIImage.mad_getImage(color: defualtTextHighlightColor, size: CGSize.init(width: 3, height: 3), cornerRadius: 1.5), for: .selected)
        button.isHidden = true
        return button
    }()
  
  lazy var bgImageView: UIImageView = {
    let imageView = UIImageView.init(image: UIImage(named: "date_frame_bg"))
    return imageView
  }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        addSubview(bgImageView)
        addSubview(titleLabel)
        addSubview(pointButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
//        bgImageView.frame = self.frame
      
        titleLabel.frame = CGRect.init(x: bounds.midX - 17,
                                            y: bounds.midY - 17,
                                            width: 34,
                                            height: 34)
        pointButton.frame = CGRect.init(x: bounds.midX - 1.5,
                                             y: bounds.height - 4.5,
                                             width: 3,
                                             height: 3)
    }
    
    func addAnimation() {
        
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "transform.scale"
        animation.calculationMode = kCAAnimationPaced
        animation.duration = 0.25
        titleLabel.layer.add(animation, forKey: nil)
    }
}


extension UILabel {
    
    func mad_set(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    func mad_resetCornerRadius() {
        layer.masksToBounds = false
        layer.cornerRadius = 0
    }
}
