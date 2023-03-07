//
//  MealCell.swift
//  soyfri
//
//  Created by Jordy Gonzalez on 3/6/23.
//

import UIKit

class MealCell: UITableViewCell {
    static let mealCellIdentifier = "MealCell"
    @IBOutlet weak var mealThumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var linkToYoutube: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(meal: Meal) {
        title.text = meal.name
        category.text = "\(meal.category ?? "") - \(meal.area ?? "")"
        linkToYoutube.text = meal.youtubeUrl
        
        mealThumb?.image = nil
        if let urlString = meal.thumbUrl, let url = URL(string: urlString) {
            mealThumb?.af.setImage(withURL: url, placeholderImage: nil)
        }
    }
}
