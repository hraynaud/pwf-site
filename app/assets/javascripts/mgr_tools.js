$(function(){
 initSeasonChangeSelect();

})

function initSeasonChangeSelect(){
	$(".season-change").change(function(){
		$(this).parent("form").submit();
	});
}