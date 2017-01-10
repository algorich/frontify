domManipulator = (function() {
  function changePageContent(newContent) {
    var content = document.querySelector('[data-component="content"]');
    content.innerHTML = newContent;
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
