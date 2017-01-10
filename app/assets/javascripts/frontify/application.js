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
//= require frontify/components/dom_manipulator
//= require_self


// Navigation

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

      if(lowerText.includes(searchValue)) {
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

(function(){
  function pushStateSlider(url) {
    history.pushState({ urlPath: url }, "", url)
  }

  function assyncRequest(elem) {
    elem.preventDefault();
    var loader = new XMLHttpRequest();
    loader.open("GET", elem.target.href, true);
    loader.setRequestHeader("Accept", "*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript");
    loader.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    loader.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    loader.onreadystatechange = function() {
      if ((loader.status == 200) && (loader.readyState == 4)) {
        eval(loader.responseText);
        pushStateSlider(elem.target.href);
      }
    };
    loader.send();
  }

  pushStateSlider(window.location.href);
  var targets = document.querySelectorAll('[data-assync-request]')

  for (var i = 0; i < targets.length; i++) {
    targets[i].addEventListener('click', assyncRequest);
  }
})();


(function() {
  function clearNavigation(navigationItems) {
    for (var i = 0; i < navigationItems.length; i++) {
      navigationItems[i].classList.remove('is-active');
    }
  }

  function activeNavigation(elem) {
    var target = elem.target;
    var viewPosition = target.offsetTop + parseInt(target.scrollTop) + 32
    var navigationItems = document.querySelectorAll('[data-component="page-navigation"] a');
    var titles = document.querySelectorAll('.alg-page-content h1')
    var currentPosition = 0

    clearNavigation(navigationItems);

    for (var i = 0; i < titles.length; i++) {
      if(titles[i].offsetTop <= viewPosition) {
        currentPosition = i;
      }
    }

    if(navigationItems[currentPosition] !== undefined) {
      navigationItems[currentPosition].classList.add('is-active');
    }
  }

  var content = document.querySelector('[data-component="content"]');
  content.addEventListener("scroll", activeNavigation);
})();



// Viewport
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

window.onpopstate = function(e){
  if(e.state !== undefined && e.state !== null) {
    e.state.urlPath
  } else {
    return e
  }
}
