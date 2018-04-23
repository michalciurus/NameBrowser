//  Created by Michal Ciurus

import UIKit

class NamesListViewCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(name: String) {
        nameLabel.text = name
    }
    
}
