
$(function() {

  infiniteScroll();
  triggerApproval();
  filterProjects();
  showProject();
  buttonsInsideShowProject();


});



  // infinite scroll on the projects page
  
  function infiniteScroll() {

    if ($('.pagination').length) {
      $(window).scroll(function() {
        var url = $('.pagination span.next').children().attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 200) {
          $('.pagination').text("Fetching more projects...");
          return $.getScript(url).done(showProject);

        }
      });
    }


  }


  // approve projects from the user profile. 

  function triggerApproval() {

    $('.applicant_button').on('click',function(){

    event.stopImmediatePropagation(); //not sure why preventDefault does not work here

    var _this = $(this);

    $.ajax({
      url: $(this).attr('href'),
      type: 'PUT',
      dataType: 'json',
      data: {todo: $(this).data('todo')}
    }).done(function(data){

      _this.parent().parent().html(data.replaceWith);
      triggerApproval();

    });

   return false  //not sure why preventDefault does not work here

 });

  }


  // Filter projects based on category, cause and location selected

  function filterProjects() {

    $('.filter_button').on('click',function(){

      event.preventDefault();

      $(this).data('on', 1 - $(this).data('on'));  // a data attribute of 1 represent checked, while a 0 represents unchecked. This is a toggle

      var allCheckedButtonsObject = $('.filter_button').filter(function(){

        return $(this).data('on') == 1

      });

      var allCheckedButtons = [];

      allCheckedButtonsObject.each(function(){allCheckedButtons.push($(this).data())})

      $.ajax({

        url: $(this).parent().attr('href'),
        type: 'POST',
        dataType: 'script',
        data: JSON.stringify(allCheckedButtons),
        contentType: 'application/json'

      }).done(function(){
        
        infiniteScroll();
        showProject();

      });

      putHighlightOnProjectFilter($(this))


    });

  }


  // Show individual products inside a div on the page

  function showProject() {
    $('.projects_detail').hide();

    $('.project_link').on('click', function() {
      event.preventDefault();

      $('.projects_detail').fadeIn('fast');


      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        dataType: 'script',
        data: { view: $(this).data('view')}
      }).always(buttonsInsideShowProject);
    });

  }


  // apply and shortlist button on the project show page

  function buttonsInsideShowProject(){

    FB.XFBML.parse();

            $('.do_project').on('click',function(){

              event.stopImmediatePropagation(); //not sure why preventDefault does not work here

              $.ajax({
                url: $(this).attr('href'),
                type: 'POST',
                dataType: 'JSON'
              }).always(function(data){alert(data.message)});

              return false  //not sure why preventDefault does not work here

            });


          $('#close_project').on('click', function() {
            event.preventDefault();
            $('.projects_detail').fadeOut('fast');
          })

      }
