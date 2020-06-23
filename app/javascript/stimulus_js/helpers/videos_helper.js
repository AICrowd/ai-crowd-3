export function pauseAndPlay() {
  let scrollTimeout = null;

  $(window).scroll(function(){
    if (scrollTimeout) {
      clearTimeout(scrollTimeout);
    }
    scrollTimeout = setTimeout(function() {
      startVideoPlayers();
    }, 2000);
  });
}

function startVideoPlayers() {
  const $videos = $('video');

  if ($videos.is(':in-viewport')) {
    $videos.each(function() {
      console.log('starting video: ' + this);
      let playPromise = this.play();
    });
  }
}
