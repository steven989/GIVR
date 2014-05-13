
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

// Show individual products inside a div on the page

  $('.project_link').on('click', function() {
    event.preventDefault();
    // console.log($(this).attr('href'));
    
    $('.projects_detail').removeClass('hidden');

    $.ajax({
      url: $(this).attr('href'),
      type: 'GET',
      dataType: 'script',
      data: { view: $(this).data('view')}
    });
  });

  // show project, application and shortlist buttons on the user profile page for both professional and npos
  
  $('.profile_view_button').on('click',function(){
      event.preventDefault();
  

      $.ajax({
          url: $(this).attr('href'),
          type: 'GET',
          dataType: 'script'
      });
  });

  // apply and shortlist button on the project show page

  $('.do_project').on('click',function(){

    event.stopImmediatePropagation(); //not sure why preventDefault does not work here

    $.ajax({
      url: $(this).attr('href'),
      type: 'POST',
      dataType: 'JSON'
    }).always(function(data){alert(data.message)});

    return false  //not sure why preventDefault does not work here

  });


});
