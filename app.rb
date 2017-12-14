require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'data_mapper'
require './model'

set :bind, '0.0.0.0'

enable :sessions

# 액션 라우팅이 되기 전 동작
before do
  # puts "before filter Test"
  # check_login
end

def check_login
  #로그인이 안되어있으면 
  unless session[:email]
    redirect to '/'
  end
end

get '/' do
  #지금까지 써진 모든 글을 보여준다ㅏ
  # 글쓰기 링크가 있고 '/new'
  @Posts = Post.all.reverse
  erb :index
end

get '/new' do
  # 새로운 글을 쓸 수 있는
  # <form>, title, content, writer
  # -> '/create'
  erb :new
end

get '/create' do
  # new 에서 보내준 정보를 바탕으로
  # Post.create()
  writer = ""
  if session[:email]
    writer = session[:email]
  else
    writer = "익명사용자"
  end
  # Post.create(
  #   :writer => writer,
  #   :title => params["title"],
  #   :content => params["content"]
  # )
  Post.create(
    wirter: writer,
    title: params["title"],
    contetn: params["content"]
  )
  redirect to '/'
end
# 로그인 가능하게
# 1. 회원가입 'signup' -> 'register'
# 2. 로그인 'login' -> 'login_session'
# 3. 로그인이 되어 있으면, 글쓴이도 추가
# 4. 로그인이 안되어 있으면, 익명
get '/signup' do
  erb :signup
end

get '/destory/:id' do
  # 지우기
 # post = Post.get("지우고싶은 포스트 id")
 # post.destory
 # 1번 지우려면 /destroy/1
 # :기호는 symbol..
 post = Post.get(params[:id])
 post.destroy
 redirect to '/'
end

get '/edit/:id' do
  @post = Post.get(params[:id])
  erb :edit
end

get '/update/:id' do
  # Post.get(params[:id]).update(
  #   :title => params["title"],
  #   :content => params["content"]
  # )

  Post.get(params[:id]).update(
    title:  params["title"],
    content: params["content"]
  )
  redirect to '/'
end


# variable routing  :가 없으면 사용자는 localhost:port/hello/name 으로만 와야함
# :가 있으면 사용자는 localhost:port/hello/aefydshar23 막 됨
get '/hello/:name' do
  @name = params[:name]
  #params hash는 form의 name을 받아올 수 있고
  # variable routing으로 전달받는 밸류를 보관할 수도 있다.
  erb :hello
end

get '/square/:number' do
  @number =""
  val = params[:number].to_i
  if val != 0
      @number = val ** 2
  else
      @number = "숫자가아님"
  end
  erb :square
end

get '/register' do
  User.create(
    :email => params["email"],
    :password => params["password"]
  )
  flash[:msg] = "회원가입 완료"
  redirect to '/'
end

get '/login' do
  erb :login
end

get '/logout' do
  session.clear
  redirect to '/'
end

get '/login_session' do
  if User.first(:email => params["email"])
      if User.first(:email => params["email"]).password == params["password"]
        session[:email] = params["email"]

        flash[:msg] = "로그인 됨"
      else
        flash[:msg] = "비번 틀림"
      end
  else
      flash[:msg] = "해당 이메일 유저 없음"
  end
  redirect to '/'
end
