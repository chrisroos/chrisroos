// TODO: Deal with multiple keys (find an example that actually requires this before implementing though).
// TODO: Check that the modifier callback is a function.
// TODO: Find a way to run all javascript tests at once.
// TODO: Make the code more 'javascript' like.
// TODO: Test that the link rel=canonical actually gets added to the head of the document.
// TODO: Think about Permalink.add_rule(name, key_or_callback) type method instead of pushing directly onto the rules array.
// TODO: Think about I can externalise all the rules (maybe GM_xmlhttpRequest will help?)
// TODO: Should I be returning empty strings (or undefined) when permalinks cannot be generated?
// TODO: Name the rules and test them (e.g. test the ebay rule).
// TODO: Create a rule object (which has url and callback).
// TODO: Rename modifier to something more useful (apply, for example).
// TODO: Namespace stuff!
// TODO: Investigate requiring other files from the extension, that way I could have a rule per file that just get required.
// TODO: Add metadata
// TODO: Make my own Location-like object that also comes with a queryString method.  Supply this to the rules so that they don't have to generate the querystring themselves.

function Url(url) {
  this.url = url;
}
Url.prototype.queryString = function() {
  var keysAndValues = {};
  if (m = this.url.match(/\?(.*)/)) {
    var queryString = m[1];
    var keyValuePairs = queryString.split('&');
    if (keyValuePairs.length > 0) {
      for (var i = 0; i < keyValuePairs.length; i++) {
        var key = keyValuePairs[i].split('=')[0];
        var value = keyValuePairs[i].split('=')[1];
        if (key)
          keysAndValues[key] = value;
      }
    }
  }
  return keysAndValues;
}

function Permalink(location) {
  this.location = location;
}
Permalink.prototype.href = function() {
  var permalink = '';
  for (var i = 0; i < Permalink.rules.length; i++) {
    var rule = Permalink.rules[i];
    if (rule.urlPattern.test(this.location.href)) {
      if (rule.modifier)
        permalink = rule.modifier(this.location);
    }
  }
  return permalink;
}

var requiredKeyRule = function(location, key) {
  var queryStringKeysAndValues = new Url(location.href).queryString();
  if (key && queryStringKeysAndValues && queryStringKeysAndValues[key]) {
    var queryString = [key, queryStringKeysAndValues[key]].join('=');
    return location.protocol + '//' + location.host + location.pathname + '?' + queryString;
  } else {
    return '';
  }
}

Permalink.rules = [];
Permalink.rules.push({
  'urlPattern' : /google\.co\.uk\/search/, 
  'modifier' : function(location) { 
    return requiredKeyRule(location, 'q');
  }
});
Permalink.rules.push({
  'urlPattern' : /theyworkforyou\.com\/wrans/, 
  'modifier' : function(location) { 
    return requiredKeyRule(location, 'id');
  }
});
Permalink.rules.push({
  'urlPattern' : /cgi\.ebay\.co\.uk/,
  'modifier'   : function(location) {
    var queryString = new Url(location.href).queryString();
    var hash = queryString.hash;
    if (m = hash.match(/item(\d+)/)) {
      var itemId = m[1];
      return 'http://cgi.ebay.co.uk/ws/eBayISAPI.dll?ViewItem&item=' + itemId;
    }
  }
});

CanonicalLink = {
  'write' : function(permalink) {
    if (href = permalink.href()) {
      var canonicalLink = document.createElement('link');
      canonicalLink.setAttribute('rel', 'canonical');
      canonicalLink.setAttribute('href', href);
      var head = document.getElementsByTagName('head')[0];
      head.appendChild(canonicalLink);
    }
  }
}

var permalink = new Permalink(document.location);
CanonicalLink.write(permalink);