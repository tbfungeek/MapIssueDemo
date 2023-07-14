//
//  OnlineUserMarkAnnotationView.swift
//  MapIssueDemo
//
//  Created by linxiaohai on 2023/7/14.
//

import UIKit
import MapKit
import SnapKit
import Kingfisher

class BizUser :NSObject,MKAnnotation {
    
    var avatar:String?
    
    var location: CLLocation? {
        didSet {
            guard let location = location else { return }
            self.coordinate = location.coordinate
        }
    }
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 23.12916565, longitude: 113.36641303)
    
    override init() {
        super.init()
    }
    
}

class OnlineUserMarkAnnotationView: MKAnnotationView {
    
    static let kNormalMarkViewSize:CGFloat = 48.0
    static let kBorderWidth:CGFloat = 2.0
    
    override var reuseIdentifier: String? {
        return MKMapViewDefaultAnnotationViewReuseIdentifier
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = annotation as? BizUser else {
                return
            }
            self.isHidden = false
            self.containerView.isHidden = false
            self.imageView.isHidden = false
            if let avatarURLString = annotation.avatar {
                imageView.kf.setImage(with: URL(string: avatarURLString))
            }
        }
    }

    lazy var containerView: UIView = {
        let view = UIView(frame: self.frame)
        view.backgroundColor = .white
        view.layer.cornerRadius = Self.kNormalMarkViewSize/2.0
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageview = UIImageView(frame: self.frame)
        imageview.layer.cornerRadius = (Self.kNormalMarkViewSize - 2 * Self.kBorderWidth)/2
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    // MARK: Initialization
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = true
        self.isHidden = true
        self.containerView.isHidden = true
        self.imageView.isHidden = true
        layer.cornerRadius = Self.kNormalMarkViewSize/2.0
        addSubview(containerView)
        containerView.addSubview(imageView)
        
        self.containerView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: Self.kNormalMarkViewSize, height: Self.kNormalMarkViewSize))
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(Self.kBorderWidth)
        }
        
        self.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }
}

