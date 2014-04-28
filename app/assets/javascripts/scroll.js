
var headerHeight

$('document').ready(function() {
    
    $(document).on('scroll', scrollCheck)
    headerHeight = $('#visible_blue').outerHeight(false)

    });


function scrollCheck() {


    var scrollPosition = window.scrollY

    var threshold = $('#who_are_we').outerHeight(false) // the threshold is set to the height of the #who_are_we div because when we scroll past the bottom of this div we want to trigger the header shrinking

    var heightToSubtract = Math.max(0,Math.min(scrollPosition - threshold,headerHeight))

    $('#visible_blue').css({height: headerHeight - heightToSubtract })

}

