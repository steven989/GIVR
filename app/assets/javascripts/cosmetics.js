
$('document').ready(function() {
    configureDropzone();
    window.scrollTo(0,0);
    $(document).on('scroll', scrollCheck);
    window.headerHeight = $('#visible_blue').outerHeight(false);    // taking a snapshot of the height of the header as an anchor
    $('.search_bar .clickable').each(function(){    // search bar 
        $(this).on('click',function () {
            var notClicked = $(this).parent().attr('class').indexOf('active') < 0
            if (notClicked) {$(this).parent().addClass('active')} 
            else {$(this).parent().removeClass('active')}
        });
        $(this).on('click',slideUpDown);
        });
    buttonHighlightToggle($('.profile_view_nav .profile_view_button'));
    navigationUnderline();  // will add underline to the navigation link that's currently active
    profile_toggle();
    signin_toggle();
    signinVisibilityToggle();
    urlCommands();
    searchBarClickListener();
    clickingOnTransparentLayer();
    toggleUserProfileMenu();
    setMinHeightToElements();
    landingPageScroll();
    landingPageScrollMouseover();
    showDataTable();
});

// show JQuery DataTable

function showDataTable() {
    $('#admin_projects').DataTable({
        "order": [[ 13, "desc" ]]
    });

    $('#admin_applications').DataTable({
        "order": [[ 4, "desc" ]]
    });

    $('#admin_categories').DataTable();
    $('#admin_causes').DataTable();
    $('#admin_locations').DataTable();
}

// dimmed page message

function dimmedModalMessage(message) {
    $('.basic.modal .content .message').html(message)
    $('.basic.modal').modal('show');
    $('.basic.modal .content .button').off('click').on('click',function(){
      $('.basic.modal').modal('hide');
    });  
}

// welcome page button to scroll to individual sections

function landingPageScroll() {
    $('.pro_summ_button, .npo_summ_button, .faq_button, .get_invite, .section_nav_button, .link_to_categories').off('click').on('click',function(){
        var target = $(this).data('scrollto');
        var targetYPosition = $(target).offset().top;
        $('html, body').animate({
            scrollTop: targetYPosition
        },500);
    });
}

    // welcome page button to scroll to individual sections highlight on mouseover

    function landingPageScrollMouseover() {
        $('.section_nav_button').off('mouseover').on('mouseover',function(){
            $(this).addClass('clicked_alt');
            $(this).find('p').removeClass('hidden');
        });

        $('.section_nav_button').off('mouseleave').on('mouseleave',function(){
            $(this).removeClass('clicked_alt');
            $(this).find('p').addClass('hidden');
            scrollCheck(); // this is added so that the currently highlighted button does not disappear on mouseleave
        });
    }

// set the minimum height of container elements intially upon page load

function setMinHeightToElements() {
    $('.background_div').css({
        'min-height': $(window).height() 
    });

    $('.profile_view_content').css({
        'min-height': $(window).height() * 0.8
    }); 

    $('#who_are_we').css({
        'height': $(window).height() 
    }); 
}

// toggle the user profile menu

function toggleUserProfileMenu() {

        $('.profile_dropdown').off('mouseover').on('mouseover',function(){
                $('.user_options_menu').removeClass('hidden');
        });
    
        $('.profile_dropdown').off('mouseleave').on('mouseleave',function(){
                $('.user_options_menu').addClass('hidden');
        });
        
        $('.profile_dropdown').off('click').on('click',function(){
                window.open("/user/profile#summary","_self")
        });
}

// toggle between showing the sign in form and not showing the sign in form

function signinVisibilityToggle(){
    $('.nav_sign_in').on('click',function(){
    event.preventDefault();
    highlightButton.call($(this));
    hideShowThings.call($('.login_box'));  
    hideShowThings.call($('.projects_overlay_transparent'));
    });
}

function clickingOnTransparentLayer(){
    $('.projects_overlay_transparent').off('click').on('click',function(){
        hideShowThings.call($('.login_box')); // hide the login box
        hideShowThings.call($(this));   // disable the transparent layer
        highlightButton.call($('.nav_sign_in')); //restore the highlighted signin navigation button
    });
}

// function to deal with all url-fragment-based commands 

function urlCommands(){
    var raw_hash = window.location.hash.substring(1) // get the url fragment
    if (window.location.href.indexOf('profile')>-1 && raw_hash != '') {jumpToTheRightProfileSection(raw_hash)};  // will jump to the profile section indicated by the url fragment
    if ($('.login_box').length>0 && raw_hash.indexOf('showLogin')>-1) {     // if the login box exists on the page ()
        hideShowThings.call($('.login_box'));
        if (raw_hash.indexOf('/')>-1){
            var tab = raw_hash.substring(10);
            var jqtab = $('.login_box .horizontal_tab').filter(function(){return $(this).data('openitem') == tab});
            execute_signin_toggle.call(jqtab);
        };
    }; 
    if (raw_hash.indexOf('applications')>-1){
        _button_with_link = $('.profile_view_button').filter(function(){return $(this).attr('id') == 'applications'});
        projectApplicationRead.call(_button_with_link);
        hideNotification();
    };
}

// Button toggle; can be applied to many buttons

function buttonHighlightToggle(buttons) {   // this takes a jquery array of clickable objects you want to turn into buttons
    buttons.each(function(){    // profile nav bar
            $(this).on('click',function(){
                if ($(this).attr('class').indexOf('active') >= 0) {return false}
                var all_buttons = buttons
                var _this = $(this)
                    all_buttons.each(function(){
                        if ($(this).text() == _this.text() || $(this).attr('class').indexOf('active') >= 0) {
                            highlightButtonUI.call($(this));
                        };
                    });
            });
        });
}
// this is to set the header transition from blue to white
// the approach is to use javascript to set the height of the blue div so that upon every scroll action the height is decreased a little 

function scrollCheck() {
    var scrollPosition = window.scrollY
    var threshold_who_are_we = $('#who_are_we').outerHeight(false) // the threshold is set to the height of the #who_are_we div because when we scroll past the bottom of this div we want to trigger the header shrinking
        var threshold_professionals = threshold_who_are_we + $('#professionals').outerHeight(false)
        var threshold_nonprofits = threshold_professionals + $('#nonprofits').outerHeight(false)
        var threshold_categories = threshold_nonprofits + $('#categories').outerHeight(false)
        var threshold_faq = threshold_categories + $('#faq').outerHeight(false)
        var threshold_join = threshold_faq + $('.join').outerHeight(false)
    // this is to change the header
    var transitionLength = 200;
    if ($(location).attr('pathname') == '/') {
        if (scrollPosition > threshold_who_are_we) { 
            $('#visible_white').fadeIn(); 
            $('#visible_blue').fadeOut(transitionLength);
        } else {  
                $('#visible_white').fadeOut(transitionLength);
                $('#visible_blue').fadeIn(); 
        };
    };
    // this is to highlight the appropriate in-page section navigatino dots

    if ($(location).attr('pathname') == '/') {
        if (scrollPosition >= threshold_who_are_we && scrollPosition <= threshold_professionals) { 
            $('.section_nav_button').removeClass('clicked_alt').eq(1).addClass('clicked_alt');
            $('.section_nav_button p').addClass('hidden').eq(1).removeClass('hidden');
            $('.landing_section_nav .section_nav_button p').css({'color':'#a0a0a0'});
        } else if (scrollPosition > threshold_professionals && scrollPosition <= threshold_nonprofits) {
            $('.section_nav_button').removeClass('clicked_alt').eq(2).addClass('clicked_alt');
            $('.section_nav_button p').addClass('hidden').eq(2).removeClass('hidden');
            $('.landing_section_nav .section_nav_button p').css({'color':'#a0a0a0'});
        } else if (scrollPosition > threshold_nonprofits && scrollPosition <= threshold_categories) {
            $('.section_nav_button').removeClass('clicked_alt').eq(3).addClass('clicked_alt');
            $('.section_nav_button p').addClass('hidden').eq(3).removeClass('hidden');
            $('.landing_section_nav .section_nav_button p').css({'color':'#a0a0a0'});
        } else if (scrollPosition > threshold_categories && scrollPosition <= threshold_faq) {
            $('.section_nav_button').removeClass('clicked_alt').eq(4).addClass('clicked_alt');
            $('.section_nav_button p').addClass('hidden').eq(4).removeClass('hidden');
            $('.landing_section_nav .section_nav_button p').css({'color':'#a0a0a0'});
        } else if (scrollPosition > threshold_faq) {
            $('.section_nav_button').removeClass('clicked_alt').eq(5).addClass('clicked_alt');
            $('.section_nav_button p').addClass('hidden').eq(5).removeClass('hidden');
            $('.landing_section_nav .section_nav_button p').css({'color':'#a0a0a0'});
        } else if (scrollPosition < threshold_who_are_we) {
            $('.section_nav_button').removeClass('clicked_alt').eq(0).addClass('clicked_alt');
            $('.section_nav_button p').addClass('hidden').eq(0).removeClass('hidden');
            $('.landing_section_nav .section_nav_button p').css({'color':'white'});
        };
    };
}


// this code is to make the underline below the navigation bar stay if the user is currently on the page

function navigationUnderline() {
    if ($(location).attr('pathname') != '/') {
        $('.alt_header').css({"display": "block"})
    }
    var linksToHighlightWhiteHeader = $('.alt_header .nav').find('.li').filter(function(){return $(this).attr('href') == $(location).attr('pathname')});
    linksToHighlightWhiteHeader.css({"background-color": "rgba(175,175,175,0.5)"});
}

// this code is to enable the exanding of the search items in the "find a project" bar

function slideUpDown() {
    var list = $(this).parent().children().eq(1);
    var icon = $(this).find('.fa');
    if (list.css('display')=="none") {
        list.slideDown(135);         // show the list
        icon.removeClass('fa-minus-square-o fa-plus-square-o').addClass('fa-minus-square-o');
        } else {
            list.slideUp(135);
            icon.removeClass('fa-minus-square-o fa-plus-square-o').addClass('fa-plus-square-o');
        }
}

// this code is so that when a search group button is clicked, it is always highlighted even without mouseover

function highlightButton() {
    var notClicked = $(this).attr('class').indexOf('clicked') < 0
    if (notClicked) {$(this).addClass('clicked')} 
        else {$(this).removeClass('clicked')}
}

function highlightButtonUI() {          // add "active" class for Semantic UI integration
    var notClicked = $(this).attr('class').indexOf('active') < 0
    if (notClicked) {$(this).addClass('active')} 
        else {$(this).removeClass('active')}
}

// this code is to activate a filter group

function searchBarClickListener() {
    $('.search_bar > .filter_group').off('click').on('click',function(){
        $(this).dropdown('show');
    });
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

function jumpToTheRightProfileSection(raw_hash){
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
    highlightButtonUI.call(button_context);
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
      acceptedFiles: 'application/pdf,.doc,.docx',
      addRemoveLinks: true,
      dictCancelUpload: "",
      dictDefaultMessage: "<i class='fa fa-cloud-upload'> Drop your resume here or click to upload",
      maxFilesize: 0.5, 
      previewTemplate: "<span class='file_preview'></span>",
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
        this.on('drop',function(){
            $('.upload .dropzone').removeClass('draghover');
            $('.dz-default.dz-message').html("");
        });
        // spinner when file is uploading
        this.on('sending',function(){
            $('.dz-default.dz-message').html("<i class='fa fa-circle-o-notch fa-2x upload spinner'></i>");
        });
        this.on('removedfile',function(){
            $('.dz-default.dz-message').html("<i class='fa fa-cloud-upload'> Drop your resume here or click to upload");
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
      dictCancelUpload: "",
      dictDefaultMessage: "<i class='fa fa-cloud-upload'> Drop your logo here or click to upload",
      maxFilesize: 0.5, 
      previewTemplate: "<span class='file_preview'></span>",
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
        this.on('drop',function(){
            $('.upload .dropzone').removeClass('draghover');
            $('.dz-default.dz-message').html("");
        });
        // spinner when file is uploading
        this.on('sending',function(){
            $('.dz-default.dz-message').html("<i class='fa fa-circle-o-notch fa-2x upload spinner'></i>");
        });
        this.on('removedfile',function(){
            $('.dz-default.dz-message').html("<i class='fa fa-cloud-upload'> Drop your logo here or click to upload");
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
    $('.projects_overlay').fadeIn('fast');
    $('.projects_detail').fadeIn('fast');
    $('.edit_info_popup').fadeIn('fast');    
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
                if (_this.attr('data-openitem') === $(this).attr('id')) {
                    $(this).show()
                } else { 
                    $(this).hide()          
                };
            });
            $('.login_box .horizontal_tab').each(function(){
                if ($(this).attr('data-openitem') == _this.attr('data-openitem')) {
                    $(this).removeClass('active');
                    $(this).addClass('active');
                } else {
                    $(this).removeClass('active');
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
    $('#application_submit').removeClass('disabled');
    buttonsInsideShowProject(); // this assigns the listener for submit 
}

// close the viewing of project show popup

function endProjectShow() {
    $('.projects_detail').fadeOut('fast');
    $('.projects_overlay').fadeOut('fast');
    $('.edit_info_popup').fadeOut('fast');
};
