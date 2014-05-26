
// high level triggers

var browser_info = navigator.appVersion;

$(function() {                  // document ready
  infiniteScroll();
  triggerApproval();
  filterProjects();
  showProject();
  buttonsInsideShowProject();
  removeUpload();
});

$(window).on('beforeunload',function(){     // navigating away from a page
  endView();  // indicate the end of a particular project if user navigates away
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
    $('.user_action_button').off('click').on('click',function(){
    event.stopImmediatePropagation(); //not sure why preventDefault does not work here
    var _this = $(this);
    $.ajax({
      url: $(this).attr('href'),
      type: 'PUT',
      dataType: 'json',
      data: {todo: $(this).data('todo')}
    }).done(function(data){
      _this.parent().parent().html(data.replaceWith);
      $('#error_messages').html(data.alertMessage);
      triggerApproval();
    });
   return false  //not sure why preventDefault does not work here
 });
}

  // Filter projects based on category, cause and location selected

  function filterProjects() {

    $('.filter_button').off('click').on('click',function(){
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
    $('.project_link').off('click').on('click', function() {
      
      _this = $(this)
      event.preventDefault();
      
      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        dataType: 'script',
        data: { view: $(this).data('view'), browser_info: browser_info}
      }).always(function(){
        Dropzone.discover();
        buttonsInsideShowProject();
        toggleApplicationForm();
        animateProjects.call(_this);
      });        
    });
  }

  // apply and shortlist button on the project show page

  function buttonsInsideShowProject(){
    // this is to make sure that the error we get from Facebook API doesn't disable other scripts
    try {
      FB.XFBML.parse();
    } catch (e) {
      console.log(e);
    }
            $('.do_project').off('click').on('click',function(){
              event.stopImmediatePropagation(); //not sure why preventDefault does not work here
              $.ajax({
                url: $(this).attr('href'),
                type: 'POST',
                dataType: 'JSON'
              }).always(function(data){alert(data.message)});
              return false  //not sure why preventDefault does not work here
            });

          $('.projects_overlay').on('click', function() {
            $('.projects_detail').fadeOut('fast');
            $(this).fadeOut('fast');
            endView();
          })

          $('#close_project').off('click').on('click', function() {
            event.preventDefault();
            $('.projects_detail').fadeOut('fast');
            $('.projects_overlay').fadeOut('fast');
            endView();
          })

      }

  //Button to remove uploaded resume or logo

  function removeUpload() {

    $('.remove_upload').off('click').on('click',function(){
      event.stopImmediatePropagation(); //not sure why preventDefault does not work here
      $.ajax({
        url: $(this).attr('href'),
        type: 'PATCH',
        dataType: 'JSON'
      }).done(function(data){
        $('.upload_container').html(data.replaceWith);
        Dropzone.discover(); // this will rerun the Dropzone discover function to find all the forms to replace with Dropzone drag & drop
      });
      return false  //not sure why preventDefault does not work here
    });
  }

  // function to record the ending of viewing a particular project. This is the AJAX action, and should be called either on leaving a project view page or leaving a page

  function endView() {
    if($('#view_closed').is(":visible")) {
      $.ajax({
        url: $('#view_closed').data('viewpath'),
        type: 'PATCH',
        dataType: 'JSON'
      });
    };
  }

  // assign listeners to the close button to send close view request

  function closeButtonListenerToAssignViewClose() {
    $('#close_project').on('click',endView);
  }

  // send a message to the server to turn all the application into "read"

  function projectApplicationRead() {
    $.ajax({
      url: $(this).data('readapp'),
      type: 'PATCH',
      dataType: 'JSON'
    });
  }

