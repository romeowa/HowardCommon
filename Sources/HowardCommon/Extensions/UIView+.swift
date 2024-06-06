//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import UIKit

public extension UIView {
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) { // gpt 버전
        let path = UIBezierPath()
        
        // 시작점 (왼쪽 상단)
        path.move(to: CGPoint(x: bounds.minX + topLeft, y: bounds.minY))
        
        // 상단 라인 및 오른쪽 상단 모서리
        path.addLine(to: CGPoint(x: bounds.maxX - topRight, y: bounds.minY))
        path.addArc(withCenter: CGPoint(x: bounds.maxX - topRight, y: bounds.minY + topRight),
                    radius: topRight,
                    startAngle: CGFloat(3 * Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        
        // 오른쪽 라인 및 오른쪽 하단 모서리
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRight))
        path.addArc(withCenter: CGPoint(x: bounds.maxX - bottomRight, y: bounds.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)
        
        // 하단 라인 및 왼쪽 하단 모서리
        path.addLine(to: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY))
        path.addArc(withCenter: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY - bottomLeft),
                    radius: bottomLeft,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)
        
        // 왼쪽 라인 및 왼쪽 상단 모서리
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topLeft))
        path.addArc(withCenter: CGPoint(x: bounds.minX + topLeft, y: bounds.minY + topLeft),
                    radius: topLeft,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(3 * Double.pi / 2),
                    clockwise: true)
        
        // 경로를 닫습니다.
        path.close()
        
        // 레이어 마스크를 설정합니다.
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    func toImage() -> UIImage {
        // UIGraphicsBeginImageContextWithOptions를 사용하여 현재 뷰의 그래픽 컨텍스트를 생성합니다.
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // 뷰의 계층을 현재의 그래픽 컨텍스트에 렌더링합니다.
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // 현재의 그래픽 컨텍스트에서 이미지를 가져옵니다.
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 그래픽 컨텍스트를 종료합니다.
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func roundCorners(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func makeCircular() {
        let radius = min(self.bounds.width, self.bounds.height) / 2
        self.roundCorners(radius: radius)
    }
    
    func makeCircularWithBorder(borderWidth: CGFloat, borderColor: UIColor) {
        // 이미지 뷰를 원형으로 만들기
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        
        // 원형 테두리 추가
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(borderLayer)
    }
    
    func makeCircularWithGradientBorder(borderWidth: CGFloat, colors: [UIColor]) {
        // 이미지 뷰를 원형으로 만들기
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // 원형 마스크 레이어 추가
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = borderWidth
        shapeLayer.path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        // 그라데이션 레이어에 마스크 적용
        gradientLayer.mask = shapeLayer
        self.layer.addSublayer(gradientLayer)
    }
}
  

