//
//  ChannelPopup.swift
//  vineent_social
//
//  Created by infovine on 2021/01/06.
//  Copyright © 2021 Infovine. All rights reserved.
//

import UIKit
import SDWebImage


protocol ChannelPopupDelegate: class {
    func didSelectItem(item:Channel_Popup_Model)
}

struct Channel_Popup_Model: Codable {
    var GroupCD : Int?
    var channelIcon : String?
    var channelName: String?
    var isOn : Bool?
}

class ChannelPopupViewController: UIViewController {
    
    var channelModel : [Channel_Popup_Model]?
    var ChannelPopupDelegate: ChannelPopupDelegate?
    var parentVc : UIViewController?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backView :UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    func initModel()  {
        let starGroup = DataBaseManager.sharedInstance.selectStarGroup()
        self.channelModel = []
        for item in starGroup {
            channelModel?.append(Channel_Popup_Model(GroupCD: item.GroupCD, channelIcon: item.groupSymbolURL, channelName: item.GroupNM, isOn: false)) //isOn : 선택된 스타
        }
    }
    
    override func viewDidLoad() {
        self.setDelegate()
        self.setupUI()
    }
    
    func setupUI() {
        self.headerLabel.text = "subscribedChannel".localized()
        if let channelModel = self.channelModel {
            self.calculateContentHeight(model: channelModel)
            self.view.layoutSubviews()
        }
    }
    
    func setDelegate() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "ChannelPopupTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ChannelPopupTableViewCell")
    }
    
    func calculateContentHeight(model:[Channel_Popup_Model]) {
        let naviBar = Int(self.parentVc?.topbarHeight ?? 0)
        let instarBar = 57
        let y = Int(self.view.frame.size.height)
        let maxHeight = y - (naviBar + instarBar)
            
            
        let header = 63
        let height = (model.count * 72) + header
        
        if (height >= maxHeight){
            self.viewHeight.constant = CGFloat(maxHeight)
        }else {
            self.viewHeight.constant = CGFloat(height)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false) {}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            if (touch.view == self.backView) {
                self.dismiss(animated: false) {
                }
            }
        }
    }
}

extension ChannelPopupViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = channelModel {
            return model.count
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ChannelPopupTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChannelPopupTableViewCell.self), for: indexPath) as! ChannelPopupTableViewCell
        if let model = channelModel?[indexPath.row] {
            //onoff
            if let isOn = model.isOn {
                if isOn {
                    cell.oval.isHidden = false
                    cell.statName.textColor = UIColor(rgb: 0x4672EE)
                }else {
                    cell.oval.isHidden = true
                    cell.statName.textColor = UIColor(rgb: 0x333333)
                }
            }
            //icon
            if let channelIcon = model.channelIcon {
                cell.starIcon.sd_setImage(with: URL(string: Base.sharedInstance.makeRemoteUrl(dataurl: channelIcon)), placeholderImage: UIImage(named: "placeholder.png"), options: []) { (theImage, error, cache, url) in
                if let errors = error {
                    print(errors)
                    return
                }
                      
                }
                
            }
            //name
            if let channelName = model.channelName {
                cell.statName.text = channelName
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<(self.channelModel?.count ?? 0) {
            self.channelModel?[i].isOn = false
        }
        self.channelModel?[indexPath.row].isOn = true
        
        if let item = self.channelModel?[indexPath.row] {
            if let delegate = self.ChannelPopupDelegate {
                delegate.didSelectItem(item: item)
            }
        }
        
        tableView.reloadData()
    }
    
}
extension UIViewController {
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return self.navigationController?.navigationBar.frame.size.height ?? 0
        }
    }
}
