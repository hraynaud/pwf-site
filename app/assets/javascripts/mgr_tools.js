$(function(){
 initSeasonChangeSelect();

})

function initSeasonChangeSelect(){
	$(".season-change").change(function(){
    $("#change_year").hide();
    $("#loading_report_cards").removeClass("hidden");
		$(this).parent("form").submit();
	});
}
