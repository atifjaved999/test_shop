// Go to top button for bitset templetes

$(document).ready(function(){
	// show or hide sticy go to top button
	$(window).scroll(function(){
		if($(this).scrollTop() > 200){
			$('.go-top').fadeIn(300);
		} else {
			$('.go-top').fadeOut(300);
		}
	});
	// animate go to button
	$('.go-top').click(function(event){
		event.preventDefault();

		$('html, body').animate({scrollTop: 0}, 500);
	})
});