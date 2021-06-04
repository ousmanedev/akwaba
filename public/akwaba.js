(function(document) {
    function getHost() {
        var src = currentScript.getAttribute('src');
        var linkElement = document.createElement('a');
        linkElement.href = src;

        return linkElement.origin;
    }

    function renderComments(response) {
        var container = document.querySelector(currentScript.getAttribute('data-container') || '#akwaba')
        container.insertAdjacentHTML('beforeend', response);
    }

    function setCommentForms() {
        var url_inputs = document.querySelectorAll('div#akwaba-comments form.comment-form input#url');
        var replyButtons = document.querySelectorAll('div#akwaba-comments .comment-box button.reply');

        for (index = 0 ; index < url_inputs.length; index++) {
            url_inputs[index].value = window.location.href;
        }

        for (index = 0 ; index < replyButtons.length; index++) {
            replyButtons[index].addEventListener('click', toggleReplyForm);
        }
    }

    var toggleReplyForm = function(event) {
        replyButton = event.target;
        form = document.getElementById(replyButton.getAttribute('data-form-id'));

        if (form.style.display == 'block') {
            form.style.display = 'none';
            replyButton.innerText = 'Reply'
        } else {
            form.style.display = 'block';
            replyButton.innerText = 'Cancel reply';
        }
    };

    var currentScript = document.currentScript;
    var databaseId = currentScript.getAttribute('data-database-id')
    var xhr = new XMLHttpRequest();
    xhr.onload = function(e) {
        renderComments(xhr.response);
        setCommentForms();
    }
    xhr.open('get', `${getHost()}/comments/${databaseId}?url=${window.location.href}`, true);
    xhr.send();
})(document);