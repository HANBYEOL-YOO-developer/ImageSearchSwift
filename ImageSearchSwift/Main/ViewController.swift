//
//  ViewController.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/09.
//
import UIKit
import Alamofire

class ViewController: UIViewController {
    let shared = DataManager.sharedInstance
    var workItem = DispatchWorkItem {}
    var textForSearch = "" {
        didSet {
            workItem.cancel()
            guard textForSearch != "" else {
                collectionView.reloadData()
                return
            }
            workItem = DispatchWorkItem {
                self.requestImage(query: self.textForSearch, page: self.shared.currentPage)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
    
    func requestImage(query: String, page: Int) {
        let headers: HTTPHeaders = [
            .authorization("KakaoAK 2962a9faf8ec4f7260cf341077c60ed2")
        ]
        let parameters: [String: Any] = ["query": query, "sort": "accuracy", "page": page]
        
        AF.request("https://dapi.kakao.com/v2/search/image", method: .get, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let obj):
                print("success")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    do {
                        let instance = try JSONDecoder().decode(ImageData.self, from: jsonData)
                        if self.shared.currentPage == 1 {
                            self.shared.imageDatas = instance
                        } else {
                            self.shared.imageDatas.documents.append(contentsOf: instance.documents)
                        }
                        switch self.shared.imageDatas.documents.count {
                        case 0:
                            self.showBasicAlert("'\(self.textForSearch)'에 대한 검색 결과가 없습니다.")
                            return
                        case 1...30:
                            self.shared.imageCount = self.shared.imageDatas.documents.count
                        case 31...80:
                            self.shared.imageCount = 30
                        default:
                            _ = ""
                        }
                    } catch {
                        print("getting instance has failed: \(error.localizedDescription)")
                    }
                } catch {
                    print("making jsonData failed: \(error.localizedDescription)")
                }
                guard self.shared.currentPage == 1 else {
                    return
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.searchBar.resignFirstResponder()
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // 검색어 변경 시 동작
        shared.imageCount = 0
        shared.currentPage = 1
        shared.imageDatas = nil
        textForSearch = searchText
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shared.imageCount // 셀 수 반환
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.loadImageUsingCacheWithURLString(stringImageUrl: shared.imageDatas.documents[indexPath.row].thumbnail_url, placeHolder: nil)
        return cell // 셀 반환
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3    // 3 X N 그리드뷰 구성
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // 셀 눌렀을 때 동작
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailImageVC") as! DetailImageVC
        vc.index = indexPath.row
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // scroll 끝까지 내렸을 때 동작
        if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.frame.size.height) {
            switch shared.imageDatas.documents.count - shared.imageCount {
            case 140...:
                shared.imageCount += 30
            case 60...139:
                shared.imageCount += 30
                if !shared.imageDatas.meta.is_end {     // data fetch (버퍼를 두기 위해 미리 불러옴)
                    shared.currentPage += 1
                    requestImage(query: textForSearch, page: shared.currentPage)
                }
            case 31...59:
                shared.imageCount += 30
                if !shared.imageDatas.meta.is_end {     // data fetch
                    shared.currentPage += 1
                    requestImage(query: textForSearch, page: shared.currentPage)
                }
            case 1...30:
                shared.imageCount = shared.imageDatas.documents.count
            case 0:
                return
            default:
                print("imageCount error occured")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
