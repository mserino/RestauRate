$(document).ready(function(){
  $('.new_review').on('submit', function(event) {
    event.preventDefault();
    var restaurant = $(this).closest('.restaurant');

    $.post($(this).attr('action'), $(this).serialize(), function(review) {
      restaurant.find('ul.reviews').append('<li>' + review.thoughts + ' (' + review.rating + ')</li>')
      restaurant.find('.average_rating').text(review.new_average_rating)
      restaurant.find('.review_count').text('( ' + review.new_review_count + ' reviews )')
    }).always(function(){
			$('#review_thoughts').val('');
		}); // .always(function())
  }) // $('.new_review').on('submit', function(event)
})// document ready