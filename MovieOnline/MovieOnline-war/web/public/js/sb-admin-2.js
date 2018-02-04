$(function() {
    $('#side-menu').metisMenu();
});

//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
$(function() {
    if($('div').hasClass("circle-diskspace")){
        var $bar = $('.circle-diskspace').find(".bar");
        var $val = $('#disk-usager');
        var perc = parseInt( $val.text(), 10);
        $({p: 0}).animate({p: perc}, {
            duration: 3000,
            easing: "swing",
            step: function(p) {
                $bar.css({
                    transform: "rotate(" + (45 + (p * 1.8)) + "deg)", // 100%=180° so: ° = % * 1.8
                    // 45 is to add the needed rotation to have the green borders at the bottom
                });
                $val.text(p | 0);
            }
        });
    }
    if($('div').hasClass("circle-bankwidth")){
        var $bar1 = $('.circle-bankwidth').find(".bar");
        var $val1 = $('#network-bankwidth');
        var perc1 = parseFloat( $val1.text(), 10);
        $({p: 0}).animate({p: perc1}, {
            duration: 1000,
            easing: "swing",
            step: function(p) {
                $bar1.css({
                    transform: "rotate(" + (45 + (p * 1.8)) + "deg)", // 100%=180° so: ° = % * 1.8
                    // 45 is to add the needed rotation to have the green borders at the bottom
                });
                $val1.text(p.toFixed(2));
            }
        });
    }
});
$(function() {
    $(window).bind("load resize", function() {
        var topOffset = 50;
        var width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }
        var height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
    });

    var url = window.location;
//     var element = $('ul.nav a').filter(function() {
//         return this.href == url;
//     }).addClass('active').parent().parent().addClass('in').parent();
    var element = $('ul.nav a').filter(function() {
        return this.href == url;
    }).addClass('active').parent();
    while (true) {
        if (element.is('li')) {
            element = element.parent().addClass('in').parent();
        } else {
            break;
        }
    }
});
