/**
 * @fileOverview Ajax Handler
 * @name ajax_cart.js
 * @author Kyung Mo Kweon
 * @license MIT
 */

/**
 * Post data and alert the response.message
 * @param {event} e - Event
 */
function ajaxHandler(e) {
    e.preventDefault();
    let post_url = $(this).attr("action");
    let form_data = $(this).serialize();

    $.post(post_url, form_data, function(response) {
        $.bootstrapGrowl(response.message, {
            offset: {
                from: 'top',
                amount: 60
            },
            type: 'success'
        });
        $(".cart-count").text(response.cart_count);
    });
}

var ajaxCart = {
    init: function() {
        $(function() {
            $(".cart-form").on("submit", ajaxHandler);
        });
    }
};

export default ajaxCart;
