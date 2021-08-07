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

enum MicState {
    case start
    case stop
}

class RecordingListScreenViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var micSystem:MicState = .stop
    @IBOutlet weak var navbarView: UIImageView!
    @IBOutlet weak var handleViewer: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var recordingListScreenTableView: UITableView!
    
    var dummyData = [RecordingModel]()
    var indexPlaying = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupUITable()
        
        recordingListScreenTableView.dataSource = self
        recordingListScreenTableView.delegate = self
        recordingListScreenTableView.estimatedRowHeight = 120
        recordingListScreenTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    @IBAction func buttonStart(_ sender: UIButton) {
      
        if micSystem == .start {
            micSystem = .stop
          
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
           
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  self.handleViewer.alpha = 1
                  self.handleViewer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: -162)
                  self.handleViewer.layoutIfNeeded()
            }, completion: nil)
            
          addData()
    
              
        } else {
            micSystem = .start
          
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                      self.handleViewer.alpha = 1
                      self.handleViewer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: -300)
                      self.handleViewer.layoutIfNeeded()
                }, completion: nil)
        }
    }
        
    
    func setupUITable() {
        recordButton.layer.cornerRadius = recordButton.bounds.size.width / 2
        handleViewer.layer.cornerRadius = 26
        recordingListScreenTableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 20,right: 0)
        self.recordingListScreenTableView.rowHeight = 92

    }
    
    
    func addData(){
//        dummyData = [
//            RecordingModel(title: "Coba1", duration: 10, audio: Data()),
//            RecordingModel(title: "Coba2", duration: 3, audio: Data()),
//            RecordingModel(title: "Coba3", duration: 4, audio: Data()),
//            RecordingModel(title: "Coba4", duration: 3, audio: Data()),
//        ]
        var data =  RecordingModel(title: "Coba1", duration: 10, audio: Data())
        dummyData.append(data)
        recordingListScreenTableView.reloadData()
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "AudioViewer", bundle: nil)
        let vc = UIStoryboard(name:"AudioViewer", bundle: nil).instantiateViewController(identifier: "AudioViewerViewController") as! AudioViewerViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == indexPlaying{
            //cell playing
            let cell = recordingListScreenTableView.dequeueReusableCell(withIdentifier: "custom2") as! IfTappedCell
            cell.action = {
                self.indexPlaying = -1
                self.recordingListScreenTableView.reloadData()
            }
            
            let sound = Bundle.main.path(forResource: "Test1", ofType: "mp3")
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                
            }
            catch {
                print(error)
            }
            audioPlayer.play()
            
            return cell
            
        } else {
            if indexPlaying == -1 {
            audioPlayer.stop() }
            print(indexPlaying)
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
            return UITableView.automaticDimension
        }else{
            // tinggi cell default
            return UITableView.automaticDimension
        }
    }
}


