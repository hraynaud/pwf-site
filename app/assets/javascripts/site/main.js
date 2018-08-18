//= require site/features/payments

var PWF = window.PWF || {modules:{}};

PWF.init = function(){
  for (var prop in PWF.modules) {
    if (PWF.modules.hasOwnProperty(prop)) {
     this.modules[prop].init()
    }
  }
}

$(document).ready(function() {
  PWF.init();
});
