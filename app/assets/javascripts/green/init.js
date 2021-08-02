// ********************************tinyNav menu plugin initialization********************************

// TinyNav.js 1

  $('#nav').tinyNav({
    header: 'Navigation'
  });


 $('.t-nav').tinyNav({
    header: 'Click here'
  });

// ********************************flexslider initialization********************************

  $(window).load(function() {
    $('#main-slide').flexslider({
      animation: "fade",
      controlNav: false,             
      directionNav: true
    });
  });

  $(window).load(function() {
    $('#main-slide-1').flexslider({
      animation: "slide",
      controlNav: false,             
      directionNav: true
    });
  });

  $(window).load(function() {
    $('#main-slide-2').flexslider({
      animation: "fade",
      controlNav: true,             
      directionNav: true
    });
  });


  //product detail display slider

  $(window).load(function() {

  // The slider being synced must be initialized first

    $('#display-carousel').flexslider({
      animation: "slide",
      controlNav: false,
      animationLoop: false,
      slideshow: false,
      itemWidth: 100,
      itemMargin: 20,
      asNavFor: '#display-slider'
    });

     

    $('#display-slider').flexslider({
      animation: "slide",
      controlNav: false,
      animationLoop: false,
      slideshow: false,
      sync: "#display-carousel"
    });

  });



// ********************************bootstrap dropdown toggle********************************

  $('.dropdown-toggle').dropdown()


// ********************************CaroFredSel initialization********************************

//  Responsive layout, resizing the items

  $(function() {

        //  Responsive layout, resizing the items

        $('#carousel-featured').carouFredSel({
          circular: false,
          infinite: false,
          auto: false,
          responsive: true,
          prev: '#prev2',
          next: '#next2',
          pagination: "#pager2",
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },         
          width: '100%',
          scroll: 1,
          items: {
            width: 370,
            height: '145%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });

        //  Responsive layout, resizing the items

        $('#carousel-featured-1').carouFredSel({
          circular: false,
          infinite: false,
          auto: false,
          responsive: true,
          prev: '#prev4',
          next: '#next4',
          pagination: "#pager2",
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 370,
            height: '145%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
        //  Responsive layout, resizing the items

        $('#carousel-featured-2').carouFredSel({
          circular: false,
          infinite: false,
          auto: false,
          responsive: true,

          prev: '#prev5',
          next: '#next5',
          pagination: "#pager2",
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 370,
            height: '145%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
        //  Responsive layout, resizing the items
        $('#carousel-featured-3').carouFredSel({
          circular: false,
          infinite: false,
          auto: false,
          responsive: true,
          prev: '#prev6',
          next: '#next6',
          pagination: "#pager2",
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 370,
            height: '145%',  //  optionally resize item-height
            visible: {              
              min: 1,
              max: 4
            }
          }
        });
        //  Responsive layout, resizing the items

        $('#carousel-client').carouFredSel({
          circular: false,
          infinite: false,
          responsive: true,
          auto: false,
          prev: '#prev3',
          next: '#next3',
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 280,
            height: '48%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 5
            }
          }
        });

        $('#carousel-sp1').carouFredSel({
          circular: false,
          infinite: false,
          responsive: true,
          auto: false,
          prev: '#prev7',
          next: '#next7',
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 300,
            height: '120%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
        $('#carousel-sp2').carouFredSel({
          circular: false,
          infinite: false,
          responsive: true,
          auto: false,
          prev: '#prev8',
          next: '#next8',
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 300,
            height: '120%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
        $('#carousel-sp3').carouFredSel({
          circular: false,
          infinite: false,
          responsive: true,
          auto: false,
          prev: '#prev9',
          next: '#next9',
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 300,
            height: '120%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
        $('#carousel-sp4').carouFredSel({
          circular: false,
          infinite: false,
          responsive: true,
          auto: false,
          prev: '#prev10',
          next: '#next10',
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 300,
            height: '120%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
        $('#carousel-sp5').carouFredSel({
          circular: false,
          infinite: false,
          responsive: true,
          auto: false,
          prev: '#prev11',
          next: '#next11',
          mousewheel: true,
          swipe: {
            onMouse: false,
            onTouch: true
          },
          width: '100%',
          scroll: 1,
          items: {
            width: 300,
            height: '120%',  //  optionally resize item-height
            visible: {
              min: 1,
              max: 4
            }
          }
        });
  });


// ************************* Google Maps jQuery Initialization ************************************

jQuery(document).ready(function ($) {

    var mapObject = $('#map');
    if ($().gMap && mapObject.length > 0) {
        var lat = mapObject.data('lat'); //uses data-lat attribute
        var lng = mapObject.data('lng'); //uses data-lng attribute
        var addr = mapObject.data('address'); //uses data-address attribute
        var zoom = mapObject.data('zoom'); //uses data-zoom attribute
        var markers = {};
        if (addr) {
            markers['address'] = addr;
        } else {
            markers['latitude'] = lat;
            markers['longitude'] = lng;
        }
        mapObject.gMap({ markers:[markers], zoom:zoom });
    }
    function resizeGoogleMap() {
        if (mapObject.length > 0) {
            var mapWidth = mapObject.width();
            var mapHeight = Math.round(mapWidth * 0.425);
            mapObject.height(mapHeight);
        }
    }
    resizeGoogleMap();
});

// ************************* jquery-ui slider Initialization ************************************

$(function() {
    $( "#slider-range" ).slider({
      range: true,
      min: 0,
      max: 500,
      values: [ 75, 300 ],
      slide: function( event, ui ) {
        $( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
      }
    });
    $( "#amount" ).val( "$" + $( "#slider-range" ).slider( "values", 0 ) +
      " - $" + $( "#slider-range" ).slider( "values", 1 ) );
  });

// ************************* bootstraps tabs Initialization ************************************

$('#myTab a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

$('.home-tab a').click(function (e) {
  e.preventDefault()
  $(this).tab('show');
  $('.carousel-product').trigger('updateSizes');
})







