//
//  SeniorTableViewCell.swift
//  bruincave
//
//  Created by user128030 on 1/2/18.
//  Copyright © 2018 user128030. All rights reserved.
//

import UIKit

class SeniorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likedByMeImage: UIButton!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                postedImageView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                aspectConstraint?.priority = UILayoutPriority(rawValue: 999)  //add this
                postedImageView.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    override func layoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 0
    }
    
    func setPostedImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        aspectConstraint = NSLayoutConstraint(item: postedImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: postedImageView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        
        postedImageView.image = image
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
