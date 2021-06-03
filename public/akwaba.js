(function(document) {
    var databaseId = document.currentScript.getAttribute('data-database-id')
    var xhr = new XMLHttpRequest();

    xhr.onload = function(e) {
        document.querySelector('#akwaba').insertAdjacentHTML('beforeend', xhr.response)
    }
    xhr.open('get', `comments/${databaseId}?url=${window.location.href}`, true);
    xhr.send();
 }
)(document)