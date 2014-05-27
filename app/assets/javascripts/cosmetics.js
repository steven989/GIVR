
$('document').ready(function() {
    configureDropzone();
    window.scrollTo(0,0);
    $(document).on('scroll', scrollCheck);
    window.headerHeight = $('#visible_blue').outerHeight(false);    // taking a snapshot of the height of the header as an anchor
    $('.search_bar .clickable').each(function(){    // search bar 
        $(this).on('click',highlightButton);
        $(this).on('click',slideUpDown);
        });
    buttonHighlightToggle($('.profile_view_nav .profile_view_button'));
    buttonHighlightToggle($('.login_box .horizontal_tab'));
    navigationUnderline();  // will add underline to the navigation link that's currently active
    profile_toggle();
    signin_toggle();
    signinVisibilityToggle();
    if (window.location.href.indexOf('profile')>-1) jumpToTheRightProfileSection(); // will jump to the profile section indicated by the url fragment
});

// toggle between showing the sign in form and not showing the sign in form

function signinVisibilityToggle(){
    $('.nav_sign_in').on('click',function(){
    $(this).addClass('signin_clicked')
    event.preventDefault();
    hideShowThings.call($('.login_box'));     
    });
}

// Button toggle; can be applied to many buttons

function buttonHighlightToggle(buttons) {   // this takes a jquery array of clickable objects you want to turn into buttons
    buttons.each(function(){    // profile nav bar
            $(this).on('click',function(){
                if ($(this).attr('class').indexOf('clicked') >= 0) {return false}
                var all_buttons = buttons
                var _this = $(this)
                    all_buttons.each(function(){
                        if ($(this).text() == _this.text() || $(this).attr('class').indexOf('clicked') >= 0) {
                            highlightButton.call($(this));
                        };
                    });
            });
        });
}
// this is to set the header transition from blue to white
// the approach is to use javascript to set the height of the blue div so that upon every scroll action the height is decreased a little 

function scrollCheck() {
    var scrollPosition = window.scrollY
    var threshold = $('#who_are_we').outerHeight(false) // the threshold is set to the height of the #who_are_we div because when we scroll past the bottom of this div we want to trigger the header shrinking
    var transitionLength = 200;
    if (scrollPosition > threshold) { 
        // $('#visible_white').fadeIn(); 
        $('#visible_blue').fadeOut(transitionLength);
    }
    else 
        {  
            // $('#visible_white').fadeOut(transitionLength);
            $('#visible_blue').fadeIn(); 
    }    
}


// this code is to make the underline below the navigation bar stay if the user is currently on the page

function navigationUnderline() {
    var linksToHighlightBlueHeader = $('.header .nav').find('li').filter(function(){return $(this).find('a').attr('href') == $(location).attr('pathname')});
    linksToHighlightBlueHeader.css({"border-bottom": "2px solid white"});
    var linksToHighlightWhiteHeader = $('.alt_header .nav').find('li').filter(function(){return $(this).find('a').attr('href') == $(location).attr('pathname')});
    linksToHighlightWhiteHeader.css({"border-bottom": "2px solid #76D7B3"});
}

// this code is to enable the exanding of the search items in the "find a project" bar

function slideUpDown() {
    var list = $(this).parent().children().eq(1)
    if (list.css('display')=="none") {list.slideDown()}
        else {list.slideUp()}
}

// this code is so that when a search group button is clicked, it is always highlighted even without mouseover

function highlightButton() {
    var notClicked = $(this).attr('class').indexOf('clicked') < 0
    if (notClicked) {$(this).addClass('clicked')} 
        else {$(this).removeClass('clicked')}
}


// this code is for the user profile page, the toggle among the profile sections (summary, applications, etc.)

function profile_toggle() {
    $('.profile_view_button').on('click',function(){
        execute_profile_toggle.call($(this));
        window.scrollTo(0,0);
        if ($(this).attr('id') == 'applications') {
            projectApplicationRead.call($(this));
            hideNotification();
        };
    });
}

    // this function is extracted out of the function above because we need to call this function elsewhere (when we first load the page, we need to call this function to highlight the correct nav button using url fragment)

    function execute_profile_toggle(){                          
            var _this = $(this)
            window.location.hash=$(this).attr('id')
            $('.profile_view_content').each(function(){
                if (_this.attr('id') === $(this).attr('id')) {
                    $(this).show()
                } else { 
                    $(this).hide()          
                };
            });
        }

// this code is to jump to the correct section when we first land on the profile page

function jumpToTheRightProfileSection(){
    var raw_hash = window.location.hash.substring(1); // get the fragment from the url
    var arrayOfExistingButtonIds = $.map($('.profile_view_nav .profile_view_button'),function(element,index){return element.id});   // this converts an array of the buttons into an array of the IDs of the buttons; used to check of the fragment in the url actually matches one of the buttons
    var section_id;
    if (arrayOfExistingButtonIds.indexOf(raw_hash) >= 0) {
        section_id = raw_hash
    } else {
        section_id = 'summary'
    }
    var content_context = $('.profile_view_content').filter(function(){return $(this).attr('id') == section_id}); // find the content div whose id matches the fragment
    execute_profile_toggle.call(content_context);
    var button_context = $('.profile_view_nav .profile_view_button').filter(function(){return $(this).attr('id') == section_id}); // find the button whose id matches the fragment
    highlightButton.call(button_context);
}

// this code is to highlight the categories, causes and locations that are filtered on and unhighlight those that are not on

function putHighlightOnProjectFilter(_this) {
    if (_this.data('on') == 0) {
        _this.removeClass('filter_on')
    } else if (_this.data('on') == 1) {
        _this.addClass('filter_on')
    }
}

// this code is to hide the notification once user clicks on the Applications tab in the profile

function hideNotification() {
    $('.notification_count').fadeOut(600);
}

// this code customizes the parameters for the dropzone drag and drop resume and logo upload

function configureDropzone() {

    Dropzone.options.profileResumeUpload = {
      // The params used to work with the server
      paramName: 'user[resume]',
      // Prevents Dropzone from uploading dropped files immediately
      autoProcessQueue: true,
      // Only one file at at ime
      uploadMultiple: false,
      maxFiles: 1,
      forceFallback: false,
      // acceptedFiles: 'application/pdf,.doc,.docx',
      addRemoveLinks: true,

      init: function() {
        var submitButton = $("#resume_upload")
            myDropzone = this; // closure

        submitButton.hide(); 

        submitButton.off("click").on("click", function() {
          event.preventDefault();
          myDropzone.processQueue(); // Tell Dropzone to process all queued files.
        });

        // // show the submit button only when files are dropped here:
        // this.on("addedfile", function() {
        //   // Show submit button here and/or inform user to click it.
        //   submitButton.show();
        // });

        // this is the hover effect
        this.on('dragover', function(){
            $('.upload .dropzone').addClass('draghover');
        });

        this.on('dragleave', function(){
            $('.upload .dropzone').removeClass('draghover');
        }); 

        this.on('success',function(file, response){
            $('.upload_container').html(response.replaceWith);
            $('.error_messages').html(response.message);
            Dropzone.discover(); 
            removeUpload(); //this calls the function to assign an AJAX listner to the remove resume button 
            if (response.successflag == 1) {
            makeSubmitButtonAvailable(); // this makes the submit button available again
            };
        });

      }
    };

    Dropzone.options.profileLogoUpload = {
      // The params used to work with the server
      paramName: 'user[logo]',
      // Prevents Dropzone from uploading dropped files immediately
      autoProcessQueue: true,
      // Only one file at at ime
      uploadMultiple: false,
      maxFiles: 1,
      forceFallback: false,
      acceptedFiles: 'image/jpg,image/jpeg,image/gif,image/png',
      addRemoveLinks: true,

      init: function() {
        var submitButton = $("#logo_upload")
            myDropzone = this; // closure

        submitButton.hide(); 

        submitButton.off("click").on("click", function() {
          event.preventDefault();
          myDropzone.processQueue(); // Tell Dropzone to process all queued files.
        });

        // this is the hover effect
        this.on('dragover', function(){
            $('.upload .dropzone').addClass('draghover');
        });

        this.on('dragleave', function(){
            $('.upload .dropzone').removeClass('draghover');
        }); 

        this.on('success',function(file, response){
            $('.upload_container').html(response.replaceWith);
            $('.error_messages').html(response.message);
            Dropzone.discover(); 
            removeUpload();
        });

      }
    };
}

// This is used to animate the show project details div when we click on it on the marekt place

function animateProjects() {
    $('.projects_overlay').show();
    $('.projects_detail').show();    
}


// a generic function to hide and show things

function hideShowThings(){
    var notHidden = $(this).attr('class').indexOf('hidden') < 0
    if (notHidden) {$(this).addClass('hidden')} 
        else {$(this).removeClass('hidden')}
}

// this code is for the sign up / login page tab toggle

function signin_toggle() {
    $('.login_box .horizontal_tab').on('click',function(){
        execute_signin_toggle.call($(this));
    });
}

    // called by the sign up / login page tab toggle; 

    function execute_signin_toggle(){                          
            var _this = $(this)
            $('.login_box .form').each(function(){
                if (_this.attr('id') === $(this).attr('id')) {
                    $(this).show()
                } else { 
                    $(this).hide()          
                };
            });
        }

// function to reveal the application form in the show project pop up

function toggleApplicationForm() {
    $('.load_application').off('click').on('click', function(){
        if ($('.project_card_in_popup').data('shown') == 1){
                $('.project_card_in_popup').animate({top: '-=30rem'}, 300);
                $('.proto_form').animate({top: '-=30rem'}, 300);
                $('.project_card_in_popup').data('shown',0);
        } else {
                $('.project_card_in_popup').animate({top: '+=30rem'}, 300);
                $('.proto_form').animate({top: '+=30rem'}, 300);
                $('.project_card_in_popup').data('shown',1);
        };
    });
}

// function to make the submit button available once a resume is uploaded

function makeSubmitButtonAvailable() {
    $('#application_submit').removeClass('do_project');
    $('#application_submit').removeClass('show_project_buttons');
    $('#application_submit').removeClass('show_project_buttons_disabled');
    $('#application_submit').addClass('do_project');
    $('#application_submit').addClass('show_project_buttons');
    buttonsInsideShowProject(); // this assigns the listener for submit 
}
