require 'sinatra'
require 'sinatra/cookies'

set :protection, false
set :protect_from_csrf, false
set :cookie_options, { httponly: false }

get '/' do
  <<EOH
<title>3rd Cookie Block test on IE</title>
<h1>3rd Cookie Block test on IE</h1>

<ul>
<li><a href="/set-cookie"><code>/set-cookie</code></a>
<li><a href="/view-cookie"><code>/view-cookie</code></a>
<li><a href="/iframe"><code>/iframe</code>: should be loaded via iframe</a>
<li><a href="/with-p3p"><code>/with-p3p</code>: response empty <code>application/json</code> with the P3P header</a>
<li><a href="/without-p3p"><code>/without-p3p</code>: response empty <code>application/json</code> without the P3P header</a>
<li><a href="/js-with-p3p"><code>/js-with-p3p</code>: response JavaScript, which set some Cookie, with the P3P header</a>
</ul>
EOH
end

get '/set-cookie' do
  cookies[:foo] = "123"
  cookies[:bar] = "456"
  headers 'P3P' => 'CP="ADM NOI OUR"'
  <<EOH
<title>Set Cookies</title>
<h1>Set Cookies</h1>

<p>Set cookies: <code>foo=123</code> and <code>bar=456</code>

<p><a href="/">Top</a>
EOH
end

get '/view-cookie' do
  c = cookies.reduce('') do |result, (k, v)|
    result + "<tr><th>#{k}</th><td>#{v}</td><tr>\n"
  end
  <<EOH
<title>View Cookies</title>
<h1>View Cookies</h1>

<table border="1">
<tr><th>Name</th><th>Value</th></tr>
#{c}
</table>
EOH
end

get '/iframe' do
  headers 'P3P' => 'CP="ADM NOI OUR"'
  <<EOH
<script>
document.cookie = 'foo=abc; domain=ie-3rd-party-cookie.herokuapp.com; path=/';
</script>
EOH
end

get '/with-p3p' do
  content_type 'application/json'
  headers 'P3P' => 'CP="ADM NOI OUR"'
  cookies[:foo] = "value-with-p3p"
  ''
end

get '/without-p3p' do
  content_type 'application/json'
  cookies[:foo] = "value-without-p3p"
  ''
end

get '/js-with-p3p' do
  content_type 'text/javascript'
  headers 'P3P' => 'CP="ADM NOI OUR"'
  document.cookie = 'foo=abc; domain=ie-3rd-party-cookie.herokuapp.com; path=/';
end
