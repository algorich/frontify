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

(function() {
    function toogleClass(ele, klass) {
      ele.classList.toggle(klass);
    }

    function openOrCloseNavigation () {
      var page = document.querySelector('#js-page');
      toogleClass(page, 'is-compact');
    }

   var element = document.querySelector('#js-mainNavigation-toggle');

   element.addEventListener("change", openOrCloseNavigation);
})();

(function() {
  function filterItems(){
    var searchValue = serchInputField.value.toLowerCase()

    for (var i = 0; i < serchItems.length; i++) {
      var item = serchItems[i];
      var lowerText = item.attributes['data-search-text'].value.toLowerCase();

      if(lowerText.startsWith(searchValue)) {
        item.classList.remove('is-hidden');
      } else {
        item.classList.add('is-hidden');
      }
    }
  }

  var navigationSelector = document.querySelector('.alg-mainNavigation');
  var serchInputField    = navigationSelector.querySelector('[data-search-field]');
  var serchItems         = navigationSelector.querySelectorAll('[data-search-item]');

  serchInputField.addEventListener('keyup', filterItems);
})();

(function() {
  function changeViewport(elem){
    var viewport = elem.target.parentNode.parentNode;
    var viewportContent = viewport.querySelector('.js-viewport-content');
    viewportContent.setAttribute('data-viewport-size', elem.target.value)
  }

  var resizer = document.querySelectorAll('[data-view-port-resize]')
  for (var i = 0; i < resizer.length; i++) {
    resizer[i].addEventListener('change', changeViewport);
  }
})();
