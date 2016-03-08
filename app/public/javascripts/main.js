var socket = io();
socket.on('log', function (data) {
  $('.log-list').append('<li class="mdl-list__item"><span class="mdl-list__item-primary-content"><i class="material-icons mdl-list__item-icon">chevron_right</i>' + data.message + '</span></li>');
});
socket.on('category', function (data) {
  $('.log-list').append('<li class="category mdl-list__item"><span class="mdl-list__item-primary-content"><i class="material-icons mdl-list__item-icon">star</i>' + data.message + '</span></li>');
});
socket.on('poem', function (data) {
  $('.quote-container').append('<h4 class="quote">' + data.message + '</h4>');
});

var drop = $("input");
drop.on('dragenter', function(e) {
  $(".drop").css({
    "border": "4px dashed #09f",
    "background": "rgba(0, 153, 255, .05)"
  });
  $(".cont").css({
    "color": "#09f"
  });
}).on('dragleave dragend mouseout drop', function(e) {
  $(".drop").css({
    "border": "3px dashed #DADFE3",
    "background": "transparent"
  });
  $(".cont").css({
    "color": "#8E99A5"
  });
});

function handleFileSelect(evt) {
  var files = evt.target.files; // FileList object

  // Loop through the FileList and render image files as thumbnails.
  for (var i = 0, f; f = files[i]; i++) {

    // Only process image files.
    if (!f.type.match('image.*')) {
      continue;
    }

    var reader = new FileReader();

    // Closure to capture the file information.
    reader.onload = (function(theFile) {
      return function(e) {
        var fd = new FormData();
        fd.append( "cook" , theFile );

        $.ajax({
          url: '/',
          type: 'POST',
          data: fd,
          processData: false,
          contentType: false,
          success: function(data) {
            console.log('ファイルがアップロードされました。');
            $('.drop').hide();
            $('.cook-pic').css({'background': 'url(' + e.target.result + ') center / cover'});
            $('.meta strong').text(theFile.name);
            $('.mask').fadeOut('fast');
          }
        });
      };
    })(f);

    // Read in the image file as a data URL.
    reader.readAsDataURL(f);
  }
}

$('#file').change(handleFileSelect);