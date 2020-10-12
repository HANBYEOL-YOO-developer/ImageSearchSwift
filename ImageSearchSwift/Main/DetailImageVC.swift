//
//  DetailImageVC.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/10.
//

import UIKit

class DetailImageVC: UIViewController {
    var index: Int!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var extraView: UIView!
    @IBOutlet weak var lblSitename: UILabel!
    @IBOutlet weak var lblDatetime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeView()
    }
    
    func makeView() {
        let urlValue = DataManager.sharedInstance.imageDatas.documents[index].image_url
        let sitename = DataManager.sharedInstance.imageDatas.documents[index].display_sitename
        var datetime = DataManager.sharedInstance.imageDatas.documents[index].datetime

        if !imageView.loadImageFromURLString(urlValue) {
            let alert = UIAlertController(title: nil, message: "이미지를 불러올 수 없습니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "닫기", style: .default) { UIAlertAction -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        lblSitename.text = sitename

        if datetime.count > 10 {    // 필요한 정보만 보여주기 위해 10자리 이후는 자름
            let range = datetime.index(datetime.startIndex, offsetBy: 10)..<datetime.endIndex
            datetime.removeSubrange(range)
        }
        lblDatetime.text = datetime
    }
}
