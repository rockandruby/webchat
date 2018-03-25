var pusher = new Pusher('0fa6459464e50332b8b5', {
  cluster: gon.cluster,
  authEndpoint: '/pusher/auth/' + gon.user_id,
  auth: {
    headers: {
      'X-CSRF-Token': gon.csrf_token
    }
  }
});

var privateChannel = pusher.subscribe('private-notifications_user_' + gon.user_id);

privateChannel.bind('pusher:subscription_succeeded', function() {
  console.log('Subscribed to private channel!')
});

privateChannel.bind('pusher:subscription_error', function(status) {
  console.log(status)
});

$(document).ready(function () {

  $('.user').on('click', function () {
    $('.user').removeClass('active');
    var user = $(this);
    user.addClass('active');
    $('.heading-name-meta').text(user.data('nickname'));
    $.ajax({
      url: Routes.chatter_path(user.data('user-id'), {format: 'js'}),
      headers: {
        'X_CSRF_TOKEN': gon.csrf_token
      }
    });
  });

  $('.reply-send').on('click',function () {
    $.ajax({
      url: Routes.chatters_path(),
      headers: {
        'X_CSRF_TOKEN': gon.csrf_token
      },
      method: 'POST',
      data: {user_id: $('.active').data('user-id'), message: $('#comment').val()},
      success: function(data){
        $('#comment').val('')
      }
    });
  })

});