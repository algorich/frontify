domManipulator = (function() {
  function changePageContent(newContent) {
    var content = document.querySelector('[data-component="content"]');
    content.innerHTML = newContent;
    changeViewPort.load();
  }

  function changePageTitle(newTitle) {
    var title = document.querySelector('[data-component="page-title"]');
    title.innerText = newTitle;
  }

  function changePageNavigation(newNavigation) {
    var navigation = document.querySelector('[data-component="page-navigation"]');
    navigation.innerHTML = newNavigation;
  }

  return {
    changePageContent: changePageContent,
    changePageTitle: changePageTitle,
    changePageNavigation: changePageNavigation
  }
})();

changeViewPort = (function() {
  function _changeViewport(elem){
    var viewport = elem.target.parentNode.parentNode;
    var viewportContent = viewport.querySelector('.js-viewport-content');

    viewportContent.setAttribute('data-viewport-size', elem.target.value);
  }

  function load() {
    var resizer = document.querySelectorAll('[data-viewport-resize]');

    for (var i = 0; i < resizer.length; i ++) {
      resizer[i].addEventListener('change', _changeViewport);
    }
  }

  load();

  return {
    load: load
  }
})();
