//
//  FolderCell.swift
//  MyVoice
//
//  Created by Pierre on 12/23/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit


class FolderCell: UICollectionViewCell {
    private var backCoverView: UIView!
    private var pagesView: UIView!
    private var frontCoverView: UIView!
    private var bindingView: UIView!
    private var titleLabel: UILabel!
    var folder:Folder? {
        didSet {
            titleLabel.text = folder?.title
            color = folder?.color
        }
    }
    var color: UIColor? {
        didSet {
            backCoverView.backgroundColor = getDarkColor(color, minusValue: 20.0)
            frontCoverView.backgroundColor = color
            bindingView.backgroundColor = getDarkColor(color, minusValue: 50.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func configure() {
        backCoverView = UIView(frame: bounds)
        backCoverView.backgroundColor = getDarkColor(UIColor.blue, minusValue: 20.0)
        backCoverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        pagesView = UIView(frame: CGRect(x: 15.0, y: 5, width: bounds.width - 25.0, height: bounds.height - 5.0  ))
        pagesView.backgroundColor = UIColor.white
        pagesView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        frontCoverView = UIView(frame: CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height))
        frontCoverView.backgroundColor = UIColor.blue
        frontCoverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        bindingView = UIView(frame: CGRect(x: 0, y: 0, width: 15.0, height: bounds.height))
        bindingView.backgroundColor = getDarkColor(backCoverView?.backgroundColor, minusValue: 50.0)
        bindingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bindingView.layer.borderWidth = 1.0
        bindingView.layer.borderColor = UIColor.black.cgColor
        
        titleLabel = UILabel(frame: CGRect(x: 15.0, y: 30.0, width: bounds.width - 16.0, height: 30.0))
        titleLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        contentView.addSubview(backCoverView)
        contentView.addSubview(pagesView)
        contentView.addSubview(frontCoverView)
        contentView.addSubview(bindingView)
        contentView.addSubview(titleLabel)
        
        let backPath = UIBezierPath(roundedRect: backCoverView!.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let backMask = CAShapeLayer()
        backMask.frame = backCoverView!.bounds
        backMask.path = backPath.cgPath
        let backLineLayer = CAShapeLayer()
        backLineLayer.frame = backCoverView!.bounds
        backLineLayer.path = backPath.cgPath
        backLineLayer.strokeColor = UIColor.black.cgColor
        backLineLayer.fillColor = UIColor.clear.cgColor
        backLineLayer.lineWidth = 2.0
        backCoverView!.layer.mask = backMask
        backCoverView!.layer.insertSublayer(backLineLayer, at: 0)
        
        let frontPath = UIBezierPath(roundedRect: frontCoverView!.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let frontMask = CAShapeLayer()
        frontMask.frame = frontCoverView!.bounds
        frontMask.path = frontPath.cgPath
        let frontLineLayer = CAShapeLayer()
        frontLineLayer.path = frontPath.cgPath
        frontLineLayer.strokeColor = UIColor.black.cgColor
        frontLineLayer.fillColor = UIColor.clear.cgColor
        frontLineLayer.lineWidth = 2.0
        frontCoverView!.layer.mask = frontMask
        frontCoverView!.layer.insertSublayer(frontLineLayer, at: 0)
    }
    
    private func getDarkColor(_ color: UIColor?, minusValue: CGFloat) -> UIColor? {
        if color == nil {
            return nil
        }
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color!.getRed(&r, green: &g, blue: &b, alpha: &a)
        r -= max(minusValue / 255.0, 0)
        g -= max(minusValue / 255.0, 0)
        b -= max(minusValue / 255.0, 0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class Folder: NSObject {
    var title: String?
    var color: UIColor?
    
    init(title: String?, color: UIColor) {
        super.init()
        self.title = title
        self.color = color
    }
}

