



$('document').ready(function() {
    

    $(document).on('scroll', scrollCheck);

    window.headerHeight = $('#visible_blue').outerHeight(false);    // taking a snapshot of the height of the header as an anchor

    $('.search_bar .clickable').each(function(){    // search bar 

        $(this).on('click',highlightButton);
        $(this).on('click',slideUpDown);
        
        });

    // $('.profile_view_nav .profile_view_button').each(function(){    // profile nav bar

    //         $(this).on('click',function(){

    //             var all_buttons = $('.profile_view_nav .profile_view_button')
    //             var _this = $(this)


    //                 all_buttons.each(function(){

    //                     if ($(this).text() == _this.text() || _this.attr('class').indexOf('clicked') >= 0) {

    //                         highlightButton(_this);

    //                     };

    //                 });

    //         });
        
    //     });


    navigationUnderline();  // will add underline to the navigation link that's currently active

    profile_toggle();

    });


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


// this code is for the user profile page, the toggle between application, project and shortlist 

function profile_toggle() {

    $('.profile_view_button').on('click',function(){

        _this = $(this)

        $('.profile_view_content').each(function(){

            if (_this.attr('id') === $(this).attr('id')) {

                $(this).show()

            } else { 

                $(this).hide()          

            };

        });

    });

}


// this code is to highlight the categories, causes and locations that are filtered on and unhighlight those that are not on

function putHighlightOnProjectFilter(_this) {

    if (_this.data('on') == 0) {

        _this.removeClass('filter_on')

    } else if (_this.data('on') == 1) {

        _this.addClass('filter_on')


    }


}


