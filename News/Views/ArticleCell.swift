//
//  ArticleCell.swift
//  News
//
//  Created by user198890 on 7/28/21.
//

import UIKit

// Class that links article Cell UI to article data
class ArticleCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
