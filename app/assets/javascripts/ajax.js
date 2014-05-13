
$(function() {

  // infinite scroll on the projects page
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination span.next').children().attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 200) {
        $('.pagination').text("Fetching more projects...");
        return $.getScript(url);
      }
    });
  }


  // buttons on the user profile page
  
  $('.profile_view_button').on('click',function(){

      event.preventDefault();
  

      $.ajax({
          url: $(this).attr('href'),
          type: 'GET',
          dataType: 'script'
      });

  });

});
