![logo_for_kid](https://user-images.githubusercontent.com/57529705/81412093-4ce1e180-917e-11ea-9949-c5f605ebfa02.png)
# KidsVillage概要
**■作成のきっかけ**  
  大学時代にとある学童保育施設にて学生スタッフとして勤務しており、  
  その中で感じた課題を解決できないかと考え本アプリの作成に至りました。  

**■解決したい課題 : 保護者が学童に通わせている子どもの状況をお迎え時点まで把握できない**  
  多くの保護者は子どもが宿題を終えているか、また学校から学童に到着したかを気にされていました。  
  保護者が上記の情報を知ることができるのは子どものお迎えの際に限られていましたが、  
  その時間は保護者・スタッフともに忙しく、十分なコミュニケーションが取れていませんでした。    
  
**■課題に対する解決策**  
  子どもたちが施設への到着/宿題の完了を保護者に簡単なボタン操作で連絡できるようにすることで、
  保護者がお迎え前に子どもの状況を把握できると考えました。  

# 具体的なアプリ使用方法
1. 学童運営者(User)がユーザー登録する  
1. 運営者は自身が運営する学童施設(Facility)を登録する  
1. 運営者は施設に通う子ども(Child)を登録する  
1. 運営者は「児童用のページを開く」を押して子ども用のページを表示し、  
   端末を子どもたちの目に付くところ(施設の入口など)に設置する  
   ![FireShot Capture 013 - Kids Duo - Ruby on Rails Sample App - localhost](https://user-images.githubusercontent.com/57529705/81415041-d693ae00-9182-11ea-9d9d-b880344acf29.png)
1. 学校から戻り次第、子どもは自分の名前をトップページから選択して、  
   「学校から戻りました!」ボタンから保護者に連絡を行う  
1. 同様に宿題が終わり次第、子どもは「宿題が終わりました!」ボタンから  
   宿題の完了を保護者に連絡する
   ![FireShot Capture 014 - 工藤 葵 - Ruby on Rails Sample App - localhost](https://user-images.githubusercontent.com/57529705/81415151-0347c580-9183-11ea-9a10-bb5dbc6015e6.png)
    
    
# 実装した機能
1. 学童運営者(以下User)の登録機能
2. Userのログイン機能
3. User情報の編集/削除機能
4. 学童施設(Facility)のCRUD機能(Userのみ)
5. 学童に属する子ども(Kid)のCRUD機能(Userのみ)
6. 日記(Post)のCRUD機能(更新/削除はUserのみ)
7. 子ども用のページをブラウザの別タブで開くことができる(子どものいたずら防止)
8. 画像をクリックすることで、保護者に下記の連絡を行うことができる  
  ・学童施設への到着  
  ・宿題の完了
9. テストユーザーログイン機能
 
# 言語・使用技術  
●フロント  
  ERB/SCSS/JavaScript  
●バックエンド  
  ruby 2.6.3  
  Ruby on Rails 5.1.6  
●サーバー  
  Docker web container  
●データベース  
  Docker db container  
  PostgreSQL  
●インフラ・仮想環境  
  Docker/docker-compose  
  Heroku  
●テスト  
  RSpec, factory_bot  
  
# 実装中の機能  
●ユーザープロフィールの画像設定  
●AWSへのデプロイ  

# コンセプトイメージ
![how_to](https://user-images.githubusercontent.com/57529705/81411483-5f0f5000-917d-11ea-9ae3-76a1222940da.png)
