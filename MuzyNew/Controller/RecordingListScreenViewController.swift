//
//  RecordingListScreenViewController.swift
//  MuzyNew
//
//  Created by Syofia Friherdina on 28/07/21.
//

import UIKit
import AVFoundation

struct RecordingModel{
    var title : String = ""
    var duration : Int = 0
    var audio : Data = Data()
}

class RecordingListScreenViewController: UIViewController {

    @IBOutlet var recordingListScreenTableView: UITableView!
    
    var dummyData = [RecordingModel]()
    var indexPlaying = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()
        setupDummy()
        recordingListScreenTableView.dataSource = self
        recordingListScreenTableView.delegate = self
    }
    
    func setupDummy(){
        dummyData = [
            RecordingModel(title: "Coba1", duration: 10, audio: Data()),
            RecordingModel(title: "Coba2", duration: 3, audio: Data()),
            RecordingModel(title: "Coba3", duration: 4, audio: Data()),
            RecordingModel(title: "Coba4", duration: 3, audio: Data()),
        ]
    }
    
    func setupTable(){
        let nib = UINib(nibName: "defaultRecordingListScreen", bundle: nil)
        recordingListScreenTableView.register(nib, forCellReuseIdentifier: "custom1")
        let nib2 = UINib(nibName: "ifTappedButton", bundle: nil)
        recordingListScreenTableView.register(nib2, forCellReuseIdentifier: "custom2")
        
    }

}

extension RecordingListScreenViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == indexPlaying{
            //cell playing
            let cell = recordingListScreenTableView.dequeueReusableCell(withIdentifier: "custom2") as! IfTappedCell
            cell.action = {
                self.indexPlaying = -1
                self.recordingListScreenTableView.reloadData()
            }
            
            return cell
            
        }else{
            //cell default
            let cell = recordingListScreenTableView.dequeueReusableCell(withIdentifier: "custom1") as! DefaultRecordingCell
            
            cell.action = {
                self.indexPlaying = indexPath.row
                self.recordingListScreenTableView.reloadData()
            }
            
            return cell
            
        }
    
    }
    
}


extension RecordingListScreenViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.indexPlaying{
            // tinggi cell pas playing
            return 81
        }else{
            // tinggi cell default
            return 44
        }
    }
}


