$(function() {

  // Set menu click behaviour
  var ID_BUTTON_MOBILE_NAV_EXPAND = '#mobileNavExpandButton';
  var ID_MENU_MOBILE_NAV = '#mobileNavMenu';

  // Set mobile navigation display mechanism
  $(ID_BUTTON_MOBILE_NAV_EXPAND).click(function() {
    // Toggle class '.expanded'
    $(ID_MENU_MOBILE_NAV).toggleClass('expanded');
  });

});
