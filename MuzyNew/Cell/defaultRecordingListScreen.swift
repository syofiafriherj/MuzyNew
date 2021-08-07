//
//  defaultRecordingListScreen.swift
//  MuzyNew
//
//  Created by MBP - EPs on 02/08/21.
//

import UIKit

class DefaultRecordingCell: UITableViewCell {
    
//    var zoomBackground : ZoomBackground
//
//    @IBOutlet var judulRecording: UILabel!
//    @IBOutlet var playBtn: UIButton!
//
//    func updateUI(){
//        playBtn.button = zoomBackground.button
//        judulRecording.text = zoomBackground.title
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var action : ()->()  = {}
    
    @IBOutlet weak var sampleLabel: UILabel!
    
    @IBAction func previewBtn(_ sender: Any) {
        action()
    }
    
}
//
//struct ZoomBackground {
//    var button:String!
//    var title:String!
//}
