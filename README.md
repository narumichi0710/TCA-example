## 設計
TCAを採用。  
https://github.com/pointfreeco/swift-composable-architecture

## データフロー

基本的には公式通り。<br>
状態を管理するStateとそのステートの更新や副作用の発生を行うReducerがある。<br>
ViewからActionを発行するとReducerが検知し、値の更新やEnvirmentからAPIリクエストを発行する。<br>
各画面では状態とActionを内包したStoreを購読し、状態に変更があれば、購読している画面の再描画が行われる。<br>
API等のやり取りはEnviroment経由で行う。Storeの生成時に必要な依存を注入する。

<img width="1062" alt="スクリーンショット 2022-08-22 9 46 48" src="https://user-images.githubusercontent.com/101316051/185818974-1062b08a-533a-477e-b388-6b824a208fd6.png">

<br>

## 親→子→孫Viewへのデータの伝搬と更新

TCAでは基本的に画面一つに対して一つのStoreを購読しており、子Viewに対して親ViewからStateとActionを内包したStoreインスタンスをコンピューテットプロパティとして受け渡す。<br>

コンポーネントや表示を行うだけの画面にはStoreインスタンスとして渡すことはせず、値を定数で受け渡す方が良い。<br>

<img width="904" alt="スクリーンショット 2022-08-22 3 02 13" src="https://user-images.githubusercontent.com/101316051/185818981-afbe2b95-fe91-406d-b47b-0cc6f8a9e56c.png">

最下層のViewから発行したアクションは一階層上のViewへと伝えられる。

<img width="892" alt="スクリーンショット 2022-08-22 3 02 21" src="https://user-images.githubusercontent.com/101316051/185818983-f29e564e-eb81-40e1-839f-ec0e09d8166a.png">

最上層のViewで受け取ったアクションを最上層のViewがReducerが検知し、副作用の発生やAPI処理などを行う。
子ViewのRecucerをCombineで監視している場合は子ViewのReducerの処理も行う。

<img width="928" alt="スクリーンショット 2022-08-22 3 02 32" src="https://user-images.githubusercontent.com/101316051/185818984-89141514-3b74-4b17-b75c-062d838b7504.png">

親View, 子View, 孫Viewの重複レンダリングを防止するための処理がTCAの内部で行われている
<img width="972" alt="スクリーンショット 2022-08-22 3 02 58" src="https://user-images.githubusercontent.com/101316051/185818988-7eadda2a-2f06-4a1a-9dfb-b8567354f538.png">

