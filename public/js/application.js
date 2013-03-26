$(document).ready(function(){
  $('textarea').limit('140', "#charsleft");
  
  $('form').submit(function(e){
    e.preventDefault();
    $('.container').hide();
    $('div.loading').show();
    var data = $(this).serialize();
    
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      data: data
    })
    .done(function(data){
      console.log("success!!!");
      $('div.loading').hide();
      $('.container').show();
      $(".success").text("Successfully tweeted: " + data);
    });
  
  });
});
