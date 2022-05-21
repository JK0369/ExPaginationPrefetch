//
//  ViewController.swift
//  ExPagination
//
//  Created by 김종권 on 2022/05/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

class ViewController: UIViewController {
  // MARK: UI
  private let tableView = UITableView(frame: .zero).then {
    $0.allowsSelection = false
    $0.backgroundColor = UIColor.clear
    $0.separatorStyle = .none
    $0.bounces = true
    $0.showsVerticalScrollIndicator = true
    $0.contentInset = .zero
    // static let tableViewEstimatedRowHeight = 34.0
    $0.register(MyCell.self, forCellReuseIdentifier: MyCell.Constant.id)
    $0.rowHeight = UITableView.automaticDimension
  }
  
  // MARK: State
  private var dataSource = [Photo]()
  private var currentPage = -1
  private var disposeBag = DisposeBag()
  
  // MARK: Layout
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.tableView)
    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.tableView.dataSource = self
    
    self.getPhotos()
    
    // pagination
    self.tableView.rx.prefetchRows // IndexPath값들이 방출
      .compactMap(\.last?.row)
      .withUnretained(self)
      .bind { ss, row in
        guard row == ss.dataSource.count - 1 else { return }
        ss.getPhotos()
      }
      .disposed(by: self.disposeBag)
  }
  
  // MARK: Method
  private func getPhotos() {
    self.currentPage += 1
    let url = "https://api.unsplash.com/photos/"
    let photoRequest = PhotoRequest(page: self.currentPage)
    let headers: HTTPHeaders = ["Authorization" : "Client-ID Your Key"]
    
    AF.request(
      url,
      method: .get,
      parameters: photoRequest.toDictionary(),
      headers: headers
    ).responseDecodable(of: [Photo].self) { [weak self] response in
      switch response.result {
      case let .success(photos):
        self?.dataSource.append(contentsOf: photos)
        self?.tableView.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//          self?.tableView.performBatchUpdates(nil, completion: nil)
//        }
        // 애니메이션 없이
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          UIView.performWithoutAnimation {
            self?.tableView.performBatchUpdates(nil, completion: nil)
          }
        }
      case let .failure(error):
        print(error)
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.dataSource.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    (tableView.dequeueReusableCell(withIdentifier: MyCell.Constant.id, for: indexPath) as! MyCell).then {
      $0.prepare(imageURL: self.dataSource[indexPath.row].urlString)
    }
  }
}
