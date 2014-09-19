$(document).ready(function() {
  $('.myPopover').on('click', function () {
    $(this).popover({
      html: true
    }).popover('show')
  })
  $('a.myPopover').on('click', function(e) {e.preventDefault(); return true;});
})