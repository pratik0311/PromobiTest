//
//  MyLocationsTableViewCell.swift
//  ProMobiTest

import UIKit

class MyLocationsTableViewCell: UITableViewCell {

    @IBOutlet weak var locationTitleLabel: UILabel!
    
    var location: String? {
        didSet {
            self.updateUIAccordingData(location ?? "")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Custom Methods
    private func updateUIAccordingData(_ location: String) {
        locationTitleLabel.text = location
    }
}
