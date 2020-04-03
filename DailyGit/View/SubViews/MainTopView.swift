//
//  MainTopView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/2/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class MainTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.blueColor
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        initializeUI()
        createConstraints()
    }
    
    private func initializeUI() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    public func createConstraints() {
        profileImage.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(Constants.profileImageWidth)
            $0.height.equalTo(profileImage.snp.width)
            $0.right.equalToSuperview().inset(14)
            #warning("This doesn't quite look right on larger devices")
            $0.centerY.equalToSuperview().multipliedBy(0.5)
        }

        
        nameLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.left.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview().multipliedBy(0.4)
        }
        
        bioLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.left.equalTo(nameLabel.snp.left).inset(3)
            $0.top.equalTo(nameLabel.snp.bottom).offset(-1)
            //            $0.height.equalTo(profileImage.snp.height).multipliedBy(1.2)
        }
        //  bioLabel.sizeToFit()
        
    }
    
    public let profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        //Provide default image
        // view.image = #imageLiteral(resourceName: "sampleIcon")
        let image = UserInfoHelper.shared.loadImageFromDiskWith(fileName: "ProfilePic")!
        view.image = image
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.tag = 0
        return view
        
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .largeTitle, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.text = ""
        label.textAlignment = .left
        label.tag = 1
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        
        #warning("Change this to light text for aestheic, we might have to opt out of using preferredFont for this")
        label.font = UIFont.scaledFont(textStyle: .title3, weight: .light)
        label.adjustsFontForContentSizeCategory = true
        label.tag = 2
        label.text = ""
        label.numberOfLines = 4
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
}
