var pusher = new Pusher(gon.pusher_key, {
  cluster: gon.cluster,
  auth: {
    headers: {
      'X-CSRF-Token': gon.csrf_token
    }
  }
});

var userNotificationsChannel = pusher.subscribe('private-notifications_user_' + gon.user_id);
var usersPresenceChannel = pusher.subscribe('presence-users');

// System events

userNotificationsChannel.bind('pusher:subscription_succeeded', function() {
  console.log('Subscribed to private channel!')
});

userNotificationsChannel.bind('pusher:subscription_error', function(status) {
  console.log(status)
});

usersPresenceChannel.bind('pusher:subscription_succeeded', function() {
  console.log('Subscribed to presence channel!');
  usersPresenceChannel.members.each(function(member) {
    $('[data-user-id = '+ member.id +']').find('.status').addClass('online')
  });
});

usersPresenceChannel.bind('pusher:subscription_error', function(status) {
  console.log(status)
});

usersPresenceChannel.bind('pusher:member_added', function(member) {
  $('[data-user-id = '+ member.id +']').find('.status').addClass('online')
});

usersPresenceChannel.bind('pusher:member_removed', function(member) {
  $('[data-user-id = '+ member.id +']').find('.status').removeClass('online')
});

// App events

userNotificationsChannel.bind('receive_message', function(data) {
  var user = $('.active'),
      sender = $('[data-user-id = '+ data.sender +']');
  if(user.data('user-id') == data.sender || user.data('user-id') == data.receiver){
    var message = $('.message-body.hide').clone();
    message.removeClass('hide');
    message.find('.message-text').html(data.message);
    message.find('.message-time').text(data.created_at);
    if(data.receiver == gon.user_id){
      message.find('.col-sm-12').addClass('message-main-receiver');
      message.find('.status').addClass('receiver')
    }else{
      message.find('.col-sm-12').addClass('message-main-sender');
      message.find('.status').addClass('sender')
    }
    $('#conversation').append(message)
  }
  if(data.sender != gon.user_id && !sender.hasClass('active')){
    sender.addClass('new_message')
  }

});

$(document).ready(function () {

  new EmojiPicker({
    emojiable_selector: '[data-emojiable=true]',
    assetsPath: 'emoji',
    popupButtonClasses: 'fa fa-smile-o'
  }).discover();

  $('.user').on('click', function () {
    $('.user').removeClass('active new_message');
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
    var message = $('#message').val();
    if(message.length < 1) return;
    $.ajax({
      url: Routes.chatters_path(),
      headers: {
        'X_CSRF_TOKEN': gon.csrf_token
      },
      method: 'POST',
      data: {user_id: $('.active').data('user-id'), message: message},
      success: function(data){
        $('.emoji-wysiwyg-editor').html('')
      }
    });
  })

});