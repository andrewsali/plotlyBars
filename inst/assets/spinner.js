/* When recalculating starts, show the spinner container & hide the output */
$(document).on('shiny:recalculating', function(event) {
    $("#"+event.target.id).siblings(".shiny-spinner-spinner-container").show();
    $("#"+event.target.id).siblings(".shiny-spinner-spinner-container").siblings().css('visibility', 'hidden');
});

/* When new value or error comes in, hide spinner container (if any) & show the output */
$(document).on('shiny:value', function(event) {
    $("#"+event.target.id).siblings(".shiny-spinner-spinner-container").hide();
    $("#"+event.target.id).siblings(".shiny-spinner-spinner-container").siblings().css('visibility', 'visible');
});

$(document).on('shiny:error', function(event) {
    $("#"+event.target.id).siblings(".shiny-spinner-spinner-container").hide();
    $("#"+event.target.id).siblings(".shiny-spinner-spinner-container").siblings().css('visibility', 'visible');
});
