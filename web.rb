require 'sinatra'
require 'sinatra/cookies'

get '/' do
  <<EOH
<title>3rd Cookie Block test on IE</title>
<h1>3rd Cookie Block test on IE</h1>

<ul>
<li><a href="/set-cookie">set cookies</a>
<li><a href="/view-cookie">view cookies</a>
</ul>
EOH
end

get '/set-cookie' do
  cookies[:foo] = "123"
  cookies[:bar] = "456"
  <<EOH
<title>Set Cookies</title>
<h1>Set Cookies</h1>

<p>Set cookies: <code>foo=123</code> and <code>bar=456</code>
EOH
end

get '/view-cookie' do
  c = cookies.reduce('') do |result, (k, v)|
    result + "<tr><th>#{k}</th><th>#{v}</th><tr>\n"
  end
  <<EOH
<title>View Cookies</title>
<h1>View Cookies</h1>

<table>
<tr><th>Name</th><th>Value</th></tr>
#{c}
</table>
EOH
end
