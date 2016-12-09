
display = function(id1, id2, id3) {
  $(id1).click(function() {
    $(id2).toggle();
    $(id3).toggle();
  });
};




$(document).ready(function() {


  $('.your-class').slick({
    dots: true,
    autoplay: true,
    adaptiveHeight: true,
    centerPadding: 200
  });

  $(".add_input").click(function() {
    $(".starting_input").append("<div class='form-group'><input class='form-control' type='text' name='name[]' placeholder='Another Actor'></div>");
  });

  display("#new_cust", "#cust_form", ".die-hard");
  display("#new_movie", "#movie_form", ".die-hard");
  display("#all_cust", ".all_cust", ".die-hard");
  display("#all_movie", ".all_movies", ".die-hard");
});
