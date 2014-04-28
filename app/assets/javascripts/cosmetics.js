

navigationUnderline();  // will add underline to the navigation link that's currently active

$('document').ready(function() {
    
    $(document).on('scroll', scrollCheck);

    window.headerHeight = $('#visible_blue').outerHeight(false);    // taking a snapshot of the height of the header as an anchor

    $('.search_bar .clickable').each(function(){

        $(this).on('click',slideUpDown)

        });

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

function slideUpDown(event) {

    var list = $(this).parent().children().eq(1)

    if (list.css('display')=="none") {list.slideDown()}
        else {list.slideUp()}

}
