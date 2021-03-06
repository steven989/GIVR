
// high level triggers

var browser_info = navigator.appVersion;

$(function() {                  // document ready
  infiniteScroll();
  triggerApproval();
  filterProjects();
  showProject();
  buttonsInsideShowProject();
  removeUpload();
  subscribeToMailchimp();
  admin_edit();
  adminDelete();
  finishProjectPrompt();
  applicationDetails();
  create_project();
  saveProgress();
});

$(window).on('beforeunload',function(){     // navigating away from a page
  endView();  // indicate the end of a particular project if user navigates away
});


  // save progress

  function saveProgress() {
    $('.save_progress').off('click').on('click',function(event){
       var _this = $(this);

       if(event.preventDefault) {
        event.preventDefault();
      } else {
        event.returnValue = false;
      };

      if ($(this).hasClass('check_required_fields')) {
        if (generalFromValidationForPresence.call($(this)) == 'missing') {
          return false
        };
      };
      var method
      if ($(this).hasClass('edit')) {
        method = 'PATCH';
      } else if ($(this).hasClass('create')) {
        method = 'POST';
      }

      $.ajax({
        url:$(this).attr('href'),
        type: method,
        dataType: 'json',
        data: $(this).parent().parent().serialize()
      }).done(function(data){
        var message = data.message;
        dimmedModalMessage(message);
        if (!_this.hasClass('no_reload')) {
          if (data.successFlag == 1) {
            $('.basic.modal .content .button').on('click',function(){
              location.reload();
            }); 
          }
        };  
      });
    });
  }

  // create project

  function create_project() {
    $('.create_project').off('click').on('click',function(event){
      if(event.preventDefault) {
        event.preventDefault();
      } else {
        event.returnValue = false;
      };
      if ($(this).hasClass('check_required_fields')) {
        if (generalFromValidationForPresence.call($(this)) == 'missing') {
          return false
        };
      };
      $.ajax({
        url: $(this).parent().parent().attr('action'),
        type: 'POST',
        dataType: 'json',
        data: $(this).parent().parent().serialize()
      }).done(function(data){
        var message = data.message;
        dimmedModalMessage(message);
          if (data.successFlag == 1) {
          $('.basic.modal .content .button').on('click',function(){
          location.reload();
          }); 
        };
      });
    });
  }

  // admin edit

  function admin_edit() {
    $('.admin_edit, .admin_create').off('click').on('click',function(event){
      if(event.preventDefault) {
        event.preventDefault();
      } else {
        event.returnValue = false;
      };
      var _this = $(this);
      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        dataType: 'html'
      }).done(function(data){
        if (_this.hasClass('admin_edit')) {
          var method = 'PUT'
        } else if (_this.hasClass('admin_create')) {
          var method = 'POST'
        }
        $('.edit_info_popup').html(data);
        slimScroll();
        saveProgress();
        buttonsInsideShowProject();
        $('#close_project, #close_project_2').off('click').on('click', function(event) {
          if(event.preventDefault) {
            event.preventDefault();
          } else {
            event.returnValue = false;
          };
          endProjectShow();
          endView();
        });
        adminDelete();
        datePickers();
        $('.profile_form .submit').off('click').on('click',function(event){
            if(event.preventDefault) {
              event.preventDefault();
            } else {
              event.returnValue = false;
            };
          if ($(this).hasClass('check_required_fields')) {
            if (generalFromValidationForPresence.call($(this)) == 'missing') {
              return false
            };
          };
          $.ajax({
            url: $(this).parent().parent().attr('action'),
            type: method,
            dataType: 'json',
            data: $(this).parent().parent().serialize()
          }).done(function(data){
            if(_this.hasClass('replace_upon_update')){
              _this.html(data.replaceWith);
            }
            if (data.successFlag != 0) {endProjectShow()};
            var message = data.message;
            dimmedModalMessage(message);
            if (!_this.hasClass('no_reload')) {
              $('.basic.modal .content .button').on('click',function(){
                location.reload();
              }); 
            };         
          });
        });
        animateProjects(3);
      });
    });
  }

  // admin delete

  function adminDelete() {
    $('.admin_delete').off('click').on('click',function(event){
      var _this = $(this);
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        dataType: 'json'
      }).done(function(data){
        if (data.successFlag != 0) {endProjectShow()};
        // var message = data.message;
        // dimmedModalMessage(message);
        if (_this.hasClass('no_reload')) {
          if ((_this).hasClass('application')) {
            _this.parent().parent().parent().remove(); // this is for the removal of application card in the profile view once deleted
          } else if ((_this).hasClass('project')) {
            $('a.admin_edit').filter(function(){return $(this).data('projectid') == _this.data('projectid')}).remove(); // this is for the removal of project card in the profile view once deleted
          }
        } else {
          $('.basic.modal .content .button').on('click',function(){
            location.reload();
          }); 
        };        
      });
      event.stopImmediatePropagation(); // this is to prevent project details from showing up when deleting shortlisted projects
      if(event.preventDefault) {
        event.preventDefault();
      } else {
        event.returnValue = false;
      };   // this is to prevent project details from showing up when deleting shortlisted projects   
    });
  }

  // Subscribe to mailing list hosted on Mailchimp

  function subscribeToMailchimp() {
    $('.subscribe').off('click').on('click',function(event){
      var _this = $(this);
      if(event.preventDefault) {
        event.preventDefault();
      } else {
        event.returnValue = false;
      };
      if ($(this).hasClass('disabled')) 
        {return false} else {
          $(this).html("<i class='fa fa-circle-o-notch spinner'></i>");
          $.ajax({
            url:  $(this).parent().attr('action'),
            type: 'POST',
            dataType: 'json',
            data: $(this).parent().serialize()
          }).done(function(data){
            _this.html("Submit");
            var message = data.message;
            dimmedModalMessage(message);
          });
        };
    });
  }

  // infinite scroll on the projects page
  
  function infiniteScroll() {
    if ($('.pagination').length) {
      $(window).scroll(function() {
        var url = $('.pagination span.next').children().attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 200) {
          $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x pagination_load spinner'></i>");
          return $.getScript(url).done(showProject);
        }
      });
    }
  }

  // view more application details
  function applicationDetails() {
    $('.view_application').off('click').on('click',function(event){
      if(event.preventDefault) {
        event.preventDefault();
      } else {
        event.returnValue = false;
      };
      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        dataType: 'html'
      }).done(function(data){
        $('.edit_info_popup').html(data);
        slimScroll();
        $('#close_project, #close_project_2').off('click').on('click', function(event) {
          if(event.preventDefault) {
            event.preventDefault();
          } else {
            event.returnValue = false;
          };
          endProjectShow();
          endView();
        });
        animateProjects(3);
      });      
    });
  }

  // complete an application at the end of an engagement

  function finishProjectPrompt() {
    $('.user_action_button_complete_application').off('click').on('click',function(event){
      event.stopImmediatePropagation(); //not sure why preventDefault does not work here    
      var _this = $(this);
      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        dataType: 'html'
      }).done(function(data){
        $('.edit_info_popup').html(data);
        slimScroll();
        $('#close_project, #close_project_2').off('click').on('click', function(event) {
          if(event.preventDefault) {
            event.preventDefault();
          } else {
            event.returnValue = false;
          };
          endProjectShow();
          endView();
        });
        $('.profile_form .submit').off('click').on('click',function(event){
          if(event.preventDefault) {
            event.preventDefault();
          } else {
            event.returnValue = false;
          };
          if ($(this).hasClass('check_required_fields')) {
            if (generalFromValidationForPresence.call($(this)) == 'missing') {
              return false
            };
          };
          $.ajax({
            url: $(this).parent().parent().attr('action'),
            type: 'PUT',
            dataType: 'json',
            data: $(this).parent().parent().serialize()
          }).done(function(data){
            if (data.successFlag == 1) {
              endProjectShow();
              _this.parent().parent().parent().parent().replaceWith(data.replaceWith);
              admin_edit();
              applicationDetails();
            } else {
            var message = data.message;
            dimmedModalMessage(message);
            };            
          });
        });
        animateProjects(3);
      });
    return false  //not sure why preventDefault does not work here
    });
  }


  // approve projects from the user profile. 

  function triggerApproval() {
    $('.user_action_button').off('click').on('click',function(event){
    event.stopImmediatePropagation(); //not sure why preventDefault does not work here
    var _this = $(this);
    var _this_value = $(this).html();
    $(this).html("<i class='fa fa-circle-o-notch do_project spinner' style='font-size: 0.9rem;'></i>");
    $.ajax({
      url: $(this).attr('href'),
      type: 'PUT',
      dataType: 'json',
      data: {todo: $(this).data('todo')}
    }).done(function(data){
      _this.html(_this_value);
      _this.parent().parent().parent().parent().replaceWith(data.replaceWith);
      $('#error_messages').html(data.alertMessage);
      triggerApproval();
      applicationDetails();
    });
   return false  //not sure why preventDefault does not work here
    });
  }

  // Filter projects based on category, cause and location selected

  function filterProjects() {
    var spinners = [];
    $('.filter_button').off('click').on('click',function(){
      spinners.push($(this).parent().find('.filter_checkbox.spinner'));
      spinners[spinners.length-1].removeClass('hidden'); // this shows the spinning icon next to the filter checkbox while filter is being updated by adding the hidden class to the last element of the array (which is the newest jQuery object to be added)
      $(this).data('on', 1 - $(this).data('on'));  // a data attribute of 1 represent checked, while a 0 represents unchecked. This is a toggle
      var allCheckedButtonsObject = $('.filter_button').filter(function(){
        return $(this).data('on') == 1
      });
      var allCheckedButtons = [];
      allCheckedButtonsObject.each(function(){allCheckedButtons.push($(this).data())})
      $.ajax({
        url: $(this).attr('href'),
        type: 'POST',
        dataType: 'script',
        data: JSON.stringify(allCheckedButtons),
        contentType: 'application/json'
      }).always(function(){
        infiniteScroll();
        showProject();
        spinner = spinners.splice(0,1); // take the first element of the array of jQuery objects (they represent the spinners), and remove that element from the array
        spinner[0].addClass('hidden'); // hide the spinner
      });
    });
  }

  // Show individual projects inside a div on the page

  function showProject() {
    $('.project_link, .pop_application').off('click').on('click', function(event) {
      
      if ($(this).hasClass('project_link')) {
        var dataType = 'script'
      } else if ($(this).hasClass('pop_application')) {
        var dataType = 'html'
      }

      var _this = $(this)
        if(event.preventDefault) {
          event.preventDefault();
        } else {
          event.returnValue = false;
        };
      
      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        dataType: dataType,
        data: { view: $(this).data('view'), browser_info: browser_info}
      }).done(function(data){
        if (dataType == 'html') {
          $('.projects_detail').html(data);
        }
        buttonsInsideShowProject();
        toggleApplicationForm();
        animateProjects(2);
        removeUpload();
        datePickers();
        slimScroll();
      });        
    });
  }

  // apply and shortlist button on the project show page

  function buttonsInsideShowProject(){
    // this is to make sure that the error we get from Facebook API doesn't disable other scripts
    try {
      FB.XFBML.parse();
      IN.parse();
    } catch (e) {
      console.log(e);
    }

            $('.open_login_box').off('click').on('click',function(){
              highlightButton.call($('.nav_sign_in'));
              hideShowThings.call($('.login_box'));  
              hideShowThings.call($('.projects_overlay_transparent'));
              $('.projects_detail').fadeOut('fast');
              $('.projects_overlay').fadeOut('fast');
            });

            $('.application_submit, #application_shortlist').off('click').on('click',function(event){
              event.stopImmediatePropagation(); //not sure why preventDefault does not work here
              if ($(this).hasClass('check_required_fields')) {
                if (generalFromValidationForPresence.call($('.form_validation_source_button')) == 'missing') {
                  return false
                };
              };
              var original_text = $(this).html();
              $(this).html("<i class='fa fa-circle-o-notch do_project spinner'></i>");
              var _this = $(this);
              $.ajax({
                url: $(this).attr('href'),
                type: $(this).data('method'),
                data: $('.ui.form form').serialize(),
                dataType: 'JSON'
              }).done(function(data){
                if (data.successFlag == 1) {
                      $('.projects_detail').fadeOut('fast');
                      $('.edit_info_popup').fadeOut('fast');
                      $('.projects_overlay').fadeOut('fast');
                };
                _this.html(original_text);
                var message = data.message+" "+data.alertMessage;
                dimmedModalMessage(message);
              });
              return false  //not sure why preventDefault does not work here
            });

          $('.projects_overlay').off('click').on('click', function() {
            endProjectShow();
            endView();
          });

          $('#close_project, #close_project_2').off('click').on('click', function(event) {
            if(event.preventDefault) {
              event.preventDefault();
            } else {
              event.returnValue = false;
            };
            endProjectShow();
            endView();
          });

          $(document).off('keydown').on('keydown',function(event){
            if (event.which == 27){           // escape key
            endProjectShow();
            endView();          
            };
          });
      };

  //Button to remove uploaded resume or logo

  function removeUpload() {

    $('.remove_upload').off('click').on('click',function(event){
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
    $('#close_project, #close_project_2').on('click',endView);
  }

  // send a message to the server to turn all the application into "read"

  function projectApplicationRead() {
    $.ajax({
      url: $(this).data('readapp'),
      type: 'PATCH',
      dataType: 'JSON'
    });
  }

