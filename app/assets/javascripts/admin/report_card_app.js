//= require ../vue/components/report_card
if(window.location.href.match(/grades|report_cards/)){
  document.addEventListener('DOMContentLoaded', function(){

    new Vue({
      el: '#report-card-app',
      template: '<reportcard/>',
      components: {
        'reportcard': ReportCard,
      }
    });

  });
}

