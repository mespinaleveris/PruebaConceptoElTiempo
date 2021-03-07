//
//  ApoloViewCell.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 5/03/21.
//

import UIKit

class ApoloViewCell: UITableViewCell
{
    @IBOutlet weak var apoloImage: UIImageView!
    @IBOutlet weak var apoloTitle: UILabel!
    @IBOutlet weak var apoloFavoriteButton: UIButton!
    
    var delegate: ApoloListViewProtocol?
    var indexPath = IndexPath()
    
    var titleText: String = "" {
        didSet {
            self.apoloTitle.text = titleText
        }
    }
    
    var isFavorite: Bool = false {
        didSet {
            apoloFavoriteButton.setImage(UIImage(named: isFavorite ? "icon_favorite_on" : "icon_favorite_off" ), for: .normal)
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
}

extension ApoloViewCell
{
    @IBAction func setFavorite(_ sender: Any)
    {
        self.isFavorite = !self.isFavorite
        
        delegate?.updateFavoriteInRow(name: self.titleText, isFavorite: self.isFavorite, indexPath: self.indexPath)
        
        awakeFromNib()
    }
}
