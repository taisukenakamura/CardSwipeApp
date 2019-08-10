//
//  ViewController.swift
//  CardSwipeApp
//
//  Created by 中村泰輔 on 2019/08/10.
//  Copyright © 2019 icannot.t.n. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //    viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    //    スワイプしてgood or badの表示
    @IBOutlet weak var likeImage: UIImageView!
    //    ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    //    ベースカードの中心
    var centerOfCard : CGPoint!
    //    ユーザーカードの配列
    var personList : [UIView] = []
    //    選択されたカードの数
    var selectedOfCardCount : Int = 0
    //    ユーザーリスト
    let nameList : [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    //    いいねされたカードの配列
    var likedName : [String] = []
    
    override func viewDidLayoutSubviews() {
        //        ベースカードの中心を代入
        centerOfCard = baseCard.center
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetView()
    }
    
    
    func resetView() {
        
        for person in personList {
            // 元に戻す処理
            person.center = self.centerOfCard
            person.transform = .identity
         
        }
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        personListにperson1~5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetView()
        selectedOfCardCount = 0
        likedName = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ToLikedList", let vc = segue.destination as? LikedListTableViewController  else {
            return
        }
        
        vc.likedName = likedName
    }
    
    //    ベースカードを元に戻す
    func resetCard(){
        //        位置を元に戻す
        baseCard.center = centerOfCard
        //        角度を戻す
        baseCard.transform = .identity
    }
    
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        //             ベースカード
        let card = sender.view!
        //        動いた距離(Viewからの距離)
        let point = sender.translation(in: view)
        //        取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        //        ユーザーカードにも同じ動きをさせる
        personList[selectedOfCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        //        元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        
        //        角度をつける処理(引数にラジアンを導入する)
        //        0.785は45度をラジアンで表現した近似値
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        
        personList[selectedOfCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        
        if xfromCenter > 0 {
            // goodを表示
            
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
            
        }else if xfromCenter < 0{
            // badを表示
            
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
            
        }
        
        
        
        
        
        //        元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended {
            
            
            if card.center.x < 50 {
                // 左へ飛ばす場合
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // X座標を左に500とばす(-500)
                    self.personList[self.selectedOfCardCount].center = CGPoint(x: self.personList[self.selectedOfCardCount].center.x - 500, y :self.personList[self.selectedOfCardCount].center.y)
                    
                })
                // ベースカードの角度と位置を元に戻す
                resetCard()
                // likeImageを消す
                likeImage.isHidden = true
                
                // 次のカードへ
                selectedOfCardCount += 1
                // カードが規定枚数に達した際に遷移先へ飛ばす
                if selectedOfCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                
            }else if card.center.x > self.view.frame.width - 50{
                // 右へ飛ばす場合
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // X座標を右に500とばす(+500)
                    self.personList[self.selectedOfCardCount].center = CGPoint(x: self.personList[self.selectedOfCardCount].center.x + 500, y :self.personList[self.selectedOfCardCount].center.y)
                })
                // ベースカードの角度と位置を元に戻す
                resetCard()
                // likeImageを消す
                likeImage.isHidden = true
                //いいねリストに追加
                likedName.append(nameList[selectedOfCardCount])
                // 次のカードへ
                selectedOfCardCount += 1
                // カードが規定枚数に達した際に遷移先へ飛ばす
                if selectedOfCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
            }
                
            else{
                
                
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    
                    //        ユーザーカードにも同じ動きをさせる
                    self.personList[self.selectedOfCardCount].center = self.centerOfCard
                    
                    
                    self.personList[self.selectedOfCardCount].transform = .identity
                    
                    // ベースカードの角度と位置を元に戻す
                    self.resetCard()
                    // likeImageを消す
                    self.likeImage.isHidden = true
                })
                
            }
            
        }
        
    }
    // badボタンの処理
    @IBAction func disLikeButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedOfCardCount].center = CGPoint(x:self.personList[self.selectedOfCardCount].center.x - 500, y:self.personList[self.selectedOfCardCount].center.y)
        })
        
        selectedOfCardCount += 1
        
        if selectedOfCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
        
        
    }
    // goodのボタンの処理
    @IBAction func likeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedOfCardCount].center = CGPoint(x:self.personList[self.selectedOfCardCount].center.x + 500, y:self.personList[self.selectedOfCardCount].center.y)
        })
        
        
        likedName.append(nameList[selectedOfCardCount])
        selectedOfCardCount += 1
        if selectedOfCardCount >= personList.count {
            // 画面遷移
            performSegue(withIdentifier: "ToLikedList", sender: self)
            
        }
        
        
        
    }
    
    
    }
    

