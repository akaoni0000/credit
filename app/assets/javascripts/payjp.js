$(function() {
    Payjp.setPublicKey(gon.key);
  
    $("#token_submit").on("click", function(e) {
      $(this).prop('disabled',true);//ボタンを無効化する
      e.preventDefault();
      var card = {
          number: $("#card_number").val(),
          exp_month: $("#exp_month").val(),
          exp_year: $("#exp_year").val(),
          cvc: $("#cvc").val()
      };
     //createToken でトークンを申込を発行してpayjp側に送る => payjp側でトークンが作成されresponseでpayjp側で作成されたトークンが帰ってくる　作成されない可能性もある　トークンが作成されるだけで保存はされていない statusはトークンが作成されたかどうか200は成功
     Payjp.createToken(card, function(status, response) {
        if (status === 200) {                    
          $("#card_number").removeAttr("name");  //card_numberの値はコントローラーに送らなくていい  Payjp.createToken(card...  のcardでpayjp側にデータが送られている
          $("#exp_month").removeAttr("name");
          $("#exp_year").removeAttr("name");
          $("#cvc").removeAttr("name");
          var token = response.id;               //tokenにはトークン(number exp_month exp_yearのデータが入っている)
          $("#charge-form").append(`<input type="hidden" name="payjp-token" value=${token}></input>`)
          $("#charge-form").submit();
        } else {
          console.log("apiまちがってる");
        }
      });
    });
});

