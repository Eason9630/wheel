//
//  wheelUIImage.swift
//  wheel
//
//  Created by 林祔利 on 2023/4/4.
//

import UIKit

class wheelUIImage: UIImageView {
    let aDegree = CGFloat.pi / 180
    let lineWidth: CGFloat = 20
    let radius: CGFloat = 130
    var startDegree: CGFloat = 270
    override func layoutSubviews() {
        //要讓圓形在layer的中心，可以使用bounds的屬性來計算出center的位置。
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let percentages: [CGFloat] = [8.33, 8.33, 8.33, 8.33, 8.33,8.33, 8.33, 8.33, 8.33, 8.33, 8.33, 8.33]
        
        for (i,percentage) in percentages.enumerated() {
            let endDegree = startDegree + 360 * percentage / 100
            let percentagePath = UIBezierPath()
            //從圓的中心開始畫線
            percentagePath.move(to: center)
            //畫出扇形角度
            percentagePath.addArc(withCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            if(i % 2 == 0){
                percentageLayer.fillColor  = UIColor(ciColor: .red).cgColor
            }else {
                percentageLayer.fillColor  = UIColor(ciColor: .black).cgColor
            }
            let percentageTextLayer = createLabel(text: "\(i + 1)", center: center, startDegree: startDegree, endDegree: endDegree)
            percentageLayer.addSublayer(percentageTextLayer)
            layer.addSublayer(percentageLayer)
           
            startDegree = endDegree
        }
        
    }

    func createLabel(text: String, center: CGPoint, startDegree: CGFloat, endDegree: CGFloat) -> CATextLayer {
        let textCenterDegree = startDegree + (endDegree - startDegree) / 2
        //文字也像圓形
        let textPath = UIBezierPath(arcCenter: center, radius: radius * 0.9, startAngle: aDegree * textCenterDegree, endAngle: aDegree * textCenterDegree, clockwise: true)
        let percentageLable = CATextLayer()
        percentageLable.string = text
        percentageLable.fontSize = 16
        percentageLable.foregroundColor = UIColor.white.cgColor
        percentageLable.alignmentMode = .center
        percentageLable.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        percentageLable.position = textPath.currentPoint
        // 根據文字所在角度計算旋轉角度
        let rotationAngle = aDegree * textCenterDegree
        // 將旋轉運用在圖片上
        percentageLable.transform = CATransform3DMakeRotation(rotationAngle, 0, 0, 1)
        return percentageLable
    }
    
    
    var currentValue: Double = 0
        func rotateGradually(handler:@escaping (String) -> ()) {
            var result = ""
            let randomDouble = Double.random(in: 0..<2 * Double.pi) // 產生0~2pi隨機的Double數字,也就是0~360度。
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            CATransaction.begin()
            rotateAnimation.fromValue = currentValue
            currentValue = currentValue + 100 * Double.pi + randomDouble //開始到結束之,總共了50圈加上randomDouble度。
            let value = currentValue.truncatingRemainder(dividingBy: Double.pi * 2) //取得currentale/Doublepi*2餘數
            let degree = value * 180 / Double.pi //將弧度轉成角度
            switch degree{
                case -30..<0:
                    result="1"
                case 0..<30:
                    result="12"
                case 30..<60:
                    result="11"
                case 60..<90:
                    result="10"
                case 90..<120:
                    result="9"
                case 120..<150:
                    result="8"
                case 150..<180:
                    result="7"
                case 180..<210:
                    result="6"
                case 210..<240:
                    result="5"
                case 240..<270:
                    result="4"
                case 270..<300:
                    result="3"
                case 300..<330:
                    result="2"
                case 330..<360:
                    result="1"
                default:
                    result="...未知"
            }
            rotateAnimation.toValue = currentValue
            rotateAnimation.isRemovedOnCompletion = false //動畫結束後仍保在結束狀態,讓轉盤不會在動畫結束時回到最初狀態。便繼再次轉動。
            rotateAnimation.fillMode = .forwards
            rotateAnimation.duration = 5 //動畫持續時間
            rotateAnimation.repeatCount = 1 // 重複幾次
            CATransaction.setCompletionBlock { //跑完動後要做的事
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){//動畫結束後暫停0.3秒
                    handler(result)
                }
            }
            rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0.9, 0.4, 1.00)//用cubic Bezier curve決定動畫速率曲線
            //也可以用內建的easeOut,但我想要最後轉一點
            self.layer.add(rotateAnimation, forKey: nil)
            CATransaction.commit()
        }


}
