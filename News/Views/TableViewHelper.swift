//
//  TableViewHelper.swift
//  News
//
//  Created by user198890 on 8/5/21.
//

import UIKit


// Extension for tableview
extension UITableView {
    
    // displays message when API query returns no articles
    func setEmptyMessage(_ message: String) {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .white
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.systemFont(ofSize: 15)
            messageLabel.sizeToFit()

            self.backgroundView = messageLabel
            self.separatorStyle = .none
        }
    
    // removes background message
        func restore() {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
}
