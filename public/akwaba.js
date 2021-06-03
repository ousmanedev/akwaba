(function(document) {
    function getHost() {
        var src = document.currentScript.getAttribute('src');
        var linkElement = document.createElement('a');
        linkElement.href = src;

        return linkElement.origin;
    }

    var databaseId = document.currentScript.getAttribute('data-database-id')
    var xhr = new XMLHttpRequest();
    var container = document.querySelector(document.currentScript.getAttribute('data-container') || '#akwaba')

    xhr.onload = function(e) {
        container.insertAdjacentHTML('beforeend', xhr.response);
        var url_inputs = document.querySelectorAll('div#akwaba-comments form.comment-form input#url');

        for (index = 0 ; index < url_inputs.length; index++) {
            url_inputs[index].value = window.location.href;
        }
    }
    xhr.open('get', `${getHost()}/comments/${databaseId}?url=${window.location.href}`, true);
    xhr.send();
})(document);