//
//  HTPleyFastForwardView.swift
//  Cartoon
//
//  Created by James on 2023/6/17.
//

import Foundation

class HTPleyFastForwardView:UIView {
    
    public var text:String = "" {
        didSet {
            
            timeLabel.text = text
        }
    }
    
    public func ht_setIsFastForward( _ fastForward:Bool ) {
        
        if fastForward {
            iconImageView.image = UIImage(named: "icon_pley_fastword")
        }
        else {
            iconImageView.image = UIImage(named: "icon_pley_back_up")
        }
    }
    
    private lazy var contentView: UIView = {
       let contentView = UIView()
        contentView.backgroundColor = .clear
       return contentView
    }()
    
    private lazy var iconImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_pley_back_up")
        
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "Helvetica-Helvetica", size: 14.fit) ?? UIFont.systemFont(ofSize: 14.fit)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_viewPrepare()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ht_viewPrepare() {
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.layer.cornerRadius = 6.fit
        contentView.layer.masksToBounds = true
        
        contentView.backgroundColor = YNHexString("#000000",alpha: 0.5)
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.width.equalTo(44)
            make.height.equalTo(44)
            
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(6.fit)
            make.centerX.equalTo(contentView)
        }

    }

}
