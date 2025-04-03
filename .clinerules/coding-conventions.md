# コーディング規約

- rubocop.ymlのスタイルルールに従う
  - 文字列リテラルにはシングルクォーテーションを使用する
- すべての.rbファイルの先頭に`frozen_string_literal: true`マジックコメントを追加する
- turbo_frame_tagなどでidを入れるとき
  - viewではdom_idメソッドを使用する
  - controllerではresource_dom_idメソッドを使用する
