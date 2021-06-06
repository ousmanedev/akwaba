(function(document) {
    function getHost() {
        var src = currentScript.getAttribute('src');
        var linkElement = document.createElement('a');
        linkElement.href = src;

        return linkElement.origin;
    }

    function renderComments(response) {
        var container = document.querySelector(currentScript.getAttribute('data-container') || '#akwaba')
        container.insertAdjacentHTML('afterBegin', response);

        var forms = document.querySelectorAll('div#akwaba-comments form.comment-form');
        for (index = 0 ; index < forms.length; index++) {
            setupForm(forms[index]);
        }
    }

    function setupForm(form) {
        if(!form) { return; }
        form.addEventListener('submit', submitComment);
        form.querySelector('input#url').value = window.location.href;
        form.parentElement.querySelector('button.reply').addEventListener('click', function(event) {
            toggleReplyForm(form)
        });
    }

    function insertNewComment(parentCommentElement, html) {
        if(parentCommentElement.id == 'akwaba-comments') {
            parentCommentElement.querySelector('form.comment-form').insertAdjacentHTML('afterEnd', html);
        } else {
            parentCommentElement.querySelector('.replies').insertAdjacentHTML('afterBegin', html);
        }
    }

    var toggleReplyForm = function(form) {
        if(form.id == 'root') { return; }

        var replyButton = form.parentElement.querySelector('button.reply')
        if (form.style.display == 'block') {
            form.style.display = 'none';
            replyButton.innerText = 'Reply'
        } else {
            form.style.display = 'block';
            replyButton.innerText = 'Cancel reply';
        }
    };

    var submitComment = function(event) {
        event.preventDefault();

        var form = event.target;
        var submitButton = form.querySelector('input[type="submit"]')
        var submissionUrl = form.getAttribute('action');
        var formData = new FormData(form);

        var xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.onload = function(e) {
            submitButton.value = 'Submit';
            toggleReplyForm(form);
            var newCommentHtml = xhr.response['html'];
            var newFormId = xhr.response['id'];

            insertNewComment(form.parentElement, newCommentHtml);
            setupForm(document.getElementById(newFormId));
        };
        xhr.open('post', submissionUrl);
        xhr.send(formData);
        submitButton.value = 'Loading ...'
    }

    var currentScript = document.currentScript;
    var databaseId = currentScript.getAttribute('data-database-id')
    var xhr = new XMLHttpRequest();
    xhr.onload = function(e) {
        renderComments(xhr.response);
    }
    xhr.open('get', `${getHost()}/comments/${databaseId}?url=${window.location.href}`, true);
    xhr.send();
})(document);