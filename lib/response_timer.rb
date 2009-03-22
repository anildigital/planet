class ResponseTimer
  def initialize(app)
    @app = app
  end
  
  def call(env)
    @start = Time.now
    @status, @headers, @response = @app.call(env)
    @stop = Time.now
    return [@status, @headers, self]
  end
  
  def each(&block)
    block.call("<!-- Response Time: #{@stop - @start} -->\n") if @headers["Content-Type"].include? "text/html"
    @response.each(&block)
  end
end