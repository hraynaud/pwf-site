//= require ../vue/components/report_card
(function(){
  function intitReportCardApp(data){
    new Vue({
      el: '#report-card-app',
      template: '<reportcard v-bind:disabled="disabled" v-bind:getPath="getPath" v-bind:postPath="postPath"/>',
      data: data,
      components: {
        'reportcard': ReportCard,
      },
    });
  }

  document.addEventListener('DOMContentLoaded', function(){
    if(document.getElementById("edit_report_card")){
      let el = document.getElementsByClassName("report-card")[0];
      let data = {
        getPath: el.getAttribute('data-get-path'),
        postPath: el.getAttribute('data-post-path'),
        disabled: el.getAttribute('data-disabled') == "true"
      };

      intitReportCardApp(data);
    }
  });
 })();
