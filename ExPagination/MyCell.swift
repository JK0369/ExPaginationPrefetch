//
//  MyCell.swift
//  ExPagination
//
//  Created by 김종권 on 2022/05/21.
//

import UIKit
import RxSwift
import Then
import SnapKit
import Kingfisher

final class MyCell: UITableViewCell {
  // MARK: Constant
  enum Constant {
    static let id = "MyCell"
    static let imageSize = CGSize(width: 120, height: 120)
    static let placeholderImage = UIImage(named: "placeholder")
  }
  
  // MARK: UI
  private let someImageView = UIImageView()
  
  // MARK: Initializers
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.contentView.addSubview(self.someImageView)
    
    self.someImageView.snp.makeConstraints {
      $0.edges.equalToSuperview().priority(999)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.prepare()
  }
  
  func prepare(imageURL: String? = nil) {
    guard let imageURL = imageURL, let url = URL(string: imageURL) else {
      self.someImageView.image = nil
      return
    }
    
    self.someImageView.kf.setImage(
      with: url,
      placeholder: Constant.placeholderImage,
      options: [
        .processor(DownsamplingImageProcessor(size: UIScreen.main.bounds.size)),
        .cacheOriginalImage,
        .keepCurrentImageWhileLoading,
        .progressiveJPEG(ImageProgressive(isBlur: false, isFastestScan: true, scanInterval: 0.1))
      ],
      completionHandler: nil
    )
  }
}
