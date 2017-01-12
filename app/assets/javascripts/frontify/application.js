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

(function(){
  function pushStateSlider(url) {
    history.pushState({ urlPath: url }, "", url);
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
  var targets = document.querySelectorAll('[data-assync-request]');

  for (var i = 0; i < targets.length; i++) {
    targets[i].addEventListener('click', assyncRequest);
  }
})();


(function() {
  function clearNavigation(navigationItems) {
    for (var i = 0; i < navigationItems.length; i ++) {
      navigationItems[i].classList.remove('is-active');
    }
  }

  function activeNavigation(elem) {
    var target = elem.target;
    var viewPosition = target.offsetTop + parseInt(target.scrollTop) + 32;
    var navigation = document.querySelector('[data-component="page-navigation"]');
    var navigationItems = navigation.querySelectorAll('a');
    var titles = document.querySelectorAll('.alg-page-content h1');
    var navigationWidth = navigation.clientWidth;
    var currentView = navigationWidth + navigation.scrollLeft;
    var currentPosition = 0;

    clearNavigation(navigationItems);

    for (var i = 0; i < titles.length; i ++) {
      if (titles[i].offsetTop <= viewPosition) {
        currentPosition = i;
      }
    }

    currentNavItem = navigationItems[currentPosition];

    if(currentNavItem !== undefined) {
      currentNavItem.classList.add('is-active');
    }

    var navWidth = navigation.clientWidth;
    var visibleNavStart = navigation.scrollLeft;
    var visibleNavEnd = visibleNavStart + navWidth;
    var startItemPosition = currentNavItem.offsetLeft
    var endItemPosition = startItemPosition + currentNavItem.clientWidth;

    if (startItemPosition <= visibleNavStart) {
      navigation.scrollLeft = startItemPosition;
    } else {
      if (endItemPosition >= visibleNavEnd) {
        navigation.scrollLeft = endItemPosition - navWidth;
      }
    }
  }

  var content = document.querySelector('[data-component="content"]');

  content.addEventListener("scroll", activeNavigation);
})();


window.onpopstate = function (e) {
  if(e.state !== undefined && e.state !== null) {
    e.state.urlPath;
  } else {
    return e;
  }
}

(function() {
  function searchItems(e){
    var searchValue = e.target.value.toLowerCase();
    var target = e.target.attributes['data-search-target'];

    if (target !== undefined) {
      var wrappers = document.querySelectorAll('[data-search-wrapper="' + target.value + '"]');

      for (var i = 0; i < wrappers.length; i ++) {
        var wrapper = wrappers[i];

        var searchItems = wrapper.querySelectorAll('[data-search-text]');

        for (var j = 0; j < searchItems.length; j ++) {
          var item = searchItems[j];
          var lowerText = item.attributes['data-search-text'].value.toLowerCase();

          if (lowerText.includes(searchValue)) {
            item.classList.remove('is-hidden');
          } else {
            item.classList.add('is-hidden');
          }
        }
      }
    }
  }

  var searchInputs = document.querySelectorAll('[data-component="search"]');

  for (var i = 0; i < searchInputs.length; i ++) {
    searchInputs[i].addEventListener('keyup', searchItems);
  }
})();

// Sidebar

(function() {
  function activeSideMenuItem (e) {
    var items = e.target.parentNode.parentNode.querySelectorAll('[data-component="side-menu-item"]');

    for (var i = 0; i < items.length; i ++) {
      items[i].classList.remove('is-active');
    }

    e.target.classList.add('is-active');
  }

  var sideMenuItems = document.querySelectorAll('[data-component="side-menu-item"]');

  for (var i = 0; i < sideMenuItems.length; i ++) {
    sideMenuItems[i].addEventListener('click', activeSideMenuItem);
  }
})();
