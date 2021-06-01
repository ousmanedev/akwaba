(function(document) {
    var databaseId = document.currentScript.getAttribute('data-database-id')
    var xhr = new XMLHttpRequest();

    xhr.onload = function(e) {
        document.querySelector('#akwaba').insertAdjacentHTML('beforeend', xhr.response)
    }
    xhr.open('get', `comments/${databaseId}`, true);
    xhr.send();
 }
)(document)