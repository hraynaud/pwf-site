//= require ../vue/components/report_card
if(window.location.href.match(/report_cards\/\d*\/edit/)){
  document.addEventListener('DOMContentLoaded', function(){
    let el = document.getElementsByClassName("report-card")[0];
    let data = {
      getPath: el.getAttribute('data-reportcard-get-path'),
      postPath: el.getAttribute('data-reportcard-post-path') 
    };

    new Vue({
      el: '#report-card-app',
      template: '<reportcard v-bind:disabled="disabled" v-bind:getPath="getPath" v-bind:postPath="postPath"/>',
      data: data,
      components: {
        'reportcard': ReportCard,
      },

      computed: {

        disabled: function(){
         return  el.getAttribute('data-disabled') == "true";
        }
      }
    });

  });
}

