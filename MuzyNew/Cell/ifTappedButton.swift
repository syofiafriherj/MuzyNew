//
//  ifTappedButton.swift
//  MuzyNew
//
//  Created by MBP - EPs on 02/08/21.
//

import UIKit

class IfTappedCell: UITableViewCell {
   
    @IBOutlet var judulRecording: UILabel!
    @IBOutlet var startTimeLbl: UILabel!
    @IBOutlet var endTimeLbl: UILabel!
    @IBOutlet var pauseBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var action : ()->()  = {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pauseRecording(_ sender: Any) {
        action()
    }
}
