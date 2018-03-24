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