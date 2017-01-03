// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree .

$(function () {
  $('#js-mainNavigation-toggle').on('change', function () {
    $('#js-page').toggleClass('is-compact');
  })
});

$(function () {
  $('#js-page-overlay').on('click', function () {
    console.log('ok');
    $('#js-page').removeClass('is-compact');
  });
});

$(function () {
  $('.js-viewport *[data-size]').on('click', function () {
    var $content = $(this).parents('.js-viewport').find('.js-viewport-content');

    if ($content.attr('data-size') != $(this).attr('data-size'))
      $content.attr('data-size', $(this).attr('data-size'));
    else
      $content.attr('data-size', '');
  });
})
